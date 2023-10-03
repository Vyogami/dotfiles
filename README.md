# Dotfiles

This repository contains my personal dotfiles, which are the configuration files for various operating systems and tools. I manage these dotfiles using the [Dotter](https://github.com/SuperCuber/dotter), a dotfile manager and templater written in Rust.

![codereaper-theme](./assets/codereaper-desktop-min.png)

## Introduction

Dotfiles are configuration files that customize the behavior and appearance of software applications and operating systems. This repository serves as a centralized location for storing and version-controlling my dotfiles, making it easy to synchronize them across different machines and operating systems.

## Stored Configurations

This repository contains the dotfile configurations for the following tools:

- Bash: `.bashrc`
- Fish: `config.fish`
- Git: `.gitconfig` and `.gitmessage`
- Gnome Shell: `extensions`, `extensions-settings.ini`, `gnome-settings.ini`, and `.themes`

     > It is not managed by dotter! for more information please refer to gnome-shell [documentation](https://github.com/legitShivam/gnome-shell-configs/blob/main/README.md)

- Grub: `grub` and `themes`
    > [deprecated] it is not managed by dotter
- Kitty: `kitty.conf` and `themes`
- Neofetch: `config.conf`
- Neovim:
- VSCode: `extension-manager.sh` and `extensions-list.txt`
- Zsh: `.zshrc`
- NuShell: `config.nu`, `env.nu` and `history.txt`

## Usage

To use these dotfiles, follow these steps:

1. Clone this repository to your local machine:

     ```bash
     git clone --recursive https://github.com/vyogami/dotfiles.git
     ```

1. Change to the dotfiles directory:

     ```bash
     cd dotfiles
     ```

1. Install Dotter if you haven't already. You can find the installation instructions in the [Dotter repository](https://github.com/SuperCuber/dotter).

1. Create `local.toml` using default config corresponding to your OS.
    - **Linux**: linux.toml
    - **Windows**: windows.toml

     ```bash
     cp .dotter/<os>.toml local.toml
     ```

1. Deploy the dotfiles using Dotter binary for respective os:
    - **Unix(x86)**: ./dotter
    - **Windows**: ./dotter.exe 
    - **Unix(arm)**: ./dotter.arm

     ```bash
     ./dotter deploy
     ```

     > use `-f` flag to forcefully deploy

     This command will deploy the dotfiles to their respective target locations, based on the configurations defined in the `.dotter` directory.

1. Customize the dotfiles according to your preferences. Feel free to modify or add any configuration files to suit your needs.

## Contributing

If you find any issues with these dotfiles or have suggestions for improvements, please feel free to open an issue or submit a pull request. Contributions are welcome!

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.

