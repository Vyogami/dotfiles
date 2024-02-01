# Remove banner
$env.config = {
  show_banner: false,
  cursor_shape: {
    vi_insert: underscore
    vi_normal: block
    emacs: line
  }
}

# Starship config
source ~/.cache/starship/init.nu

# Pokemon
pokemon-colorscripts -r --no-title


source /home/vyogami/.config/broot/launcher/nushell/br
