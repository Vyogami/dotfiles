#!/usr/bin/env bash

# Exit on error
set -e

if curl --version &>/dev/null; then
  echo "Using curl for HTTP requests."
  HTTP_TOOL="curl"
elif wget --version &>/dev/null; then
  echo "Using wget for HTTP requests."
  HTTP_TOOL="wget"
else
  >&2 echo "ERROR: Neither Curl nor Wget is installed!"
  exit 1
fi

function download_file() {
  case $HTTP_TOOL in
    "curl")
      # -L = follow redirects
      # For some reason, GitHub lets you bypass ratelimiting by sending an authorization header...
      curl -qL $1 -H "Authorization: no" 2>/dev/null
      ;;
    "wget")
      # -q = silent, -O - = write output to stdout
      wget -qO - --header="Authorization: no" $1
      ;;
  esac
}

function download_latest_release() {
  local url="https://api.github.com/repos/SuperCuber/dotter/releases/latest"
  local download_urls

  download_urls=$(download_file "$url" | jq --raw-output ".assets | map(.browser_download_url) | .[]")

  for line in $download_urls; do
    local filename=$(echo "$line" | rev | cut -d / -f 1 | rev)
    echo "Downloading \"$filename\"..."
    
    # Overwrite dotter installation
    download_file "$line" >"$filename"
    echo "FINISHED downloading \"$filename\""
    
    if [[ $filename != *.exe ]]; then
      echo "Adding EXECUTE permissions to ./$filename"
      chmod +x "./$filename"
    fi
  done

  # Example value: 'Dotter 1.0.0'
  local dotter_version=$(./dotter --version 2>/dev/null)
  if [[ $dotter_version != "" ]]; then
    echo "Successfully downloaded $dotter_version"
  else
    >&2 echo "ERROR: Couldn't download the dotter update!"
  fi
}

# Print stderr in red and stdout in green
download_latest_release 2> >(while read -r line; do echo -e "\e[01;31m$line\e[0m" >&2; done) 1> >(while read -r line; do echo -e "\e[01;32m$line\e[0m" >&2; done)

# Remove the completions.zip file if it exists
if [ -f "completions.zip" ]; then
  echo "Removing completions.zip..."
  rm "completions.zip"
  echo "completions.zip removed."
fi
