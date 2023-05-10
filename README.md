# Dotfiles

This repository contains my personal dotfiles, which are the configuration files for various operating systems and tools. I manage these dotfiles using the [Dotter](https://github.com/SuperCuber/dotter), a dotfile manager and templater written in Rust.

## Introduction

Dotfiles are configuration files that customize the behavior and appearance of software applications and operating systems. This repository serves as a centralized location for storing and version-controlling my dotfiles, making it easy to synchronize them across different machines and operating systems.

> I've other branches such `chezmoi` and `stow` which uses respective tools for managing dotfiles but `dotter` branch is the most up to date.

## Stored Configurations

This repository contains the dotfile configurations for the following tools:

- Bash: `.bashrc`
- Fish: `config.fish`
- Git: `.gitconfig` and `.gitmessage`
- Gnome Shell: `extensions`, `extensions-settings.ini`, `gnome-settings.ini`, and `.themes`

    > for more refer to gnome-shell [documentation](./gnome-shell/README)

- Grub: `grub` and `themes`
- Kitty: `kitty.conf` and `themes`
- Neofetch: `config.conf`
- Neovim:
- VSCode: `extension-manager.sh` and `extensions-list.txt`
- Zsh: `.zshrc`

## Usage

To use these dotfiles, follow these steps:

1. Clone this repository to your local machine:

    ```bash
    git clone --recursive https://github.com/your-username/dotfiles.git
    ```

2. Install Dotter if you haven't already. You can find the installation instructions in the [Dotter repository](https://github.com/SuperCuber/dotter).

3. Change to the dotfiles directory:

    ```bash
    cd dotfiles
    ```

4. Deploy the dotfiles using Dotter:

    ```bash
    dotter deploy
    ```
    > use `-f` flag to forcefully deploy

    This command will deploy the dotfiles to their respective target locations, based on the configurations defined in the `.dotter` directory.

5. Customize the dotfiles according to your preferences. Feel free to modify or add any configuration files to suit your needs.

## Contributing

If you find any issues with these dotfiles or have suggestions for improvements, please feel free to open an issue or submit a pull request. Contributions are welcome!

## License

This repository is licensed under the MIT License. See the [LICENSE](LICENSE) file for more information.
