#!/bin/bash

# install packages following Arch-based installation (developed in CachyOS. Requires pre-intall of yay <sudo pacman -S yay>)

# Update the package database and upgrade all packages
sudo pacman -Syu --noconfirm

# List of packages to install
packages=(
    "mullvad-vpn-bin"
    "discord"
    "qbittorrent"
    "calibre"
    "thunderbird"
    "darktable"
    "vlc"
    "timeshift"
    "mullvad-browser"
    "hyprland"
    "hyprpaper"
    "xdg-desktop-portal-hyprland"
    "waybar"
    "wofi"
    "kitty"
    # Add more packages here
)

# Function to check if a package is installed
is_installed() {
    pacman -Q "$1" &> /dev/null
}

# Function to check if a package is available in the official repositories
is_available_in_pacman() {
    pacman -Ss "$1" | grep -q "^extra/$1" || pacman -Ss "$1" | grep -q "^core/$1" || pacman -Ss "$1" | grep -q "^community/$1"
}

# Arrays to hold packages that need to be installed
to_install_pacman=()
to_install_aur=()

# Check each package and add to the appropriate array if not installed
for package in "${packages[@]}"; do
    if ! is_installed "$package"; then
        if is_available_in_pacman "$package"; then
            to_install_pacman+=("$package")
        else
            to_install_aur+=("$package")
        fi
    else
        echo "$package is already installed."
    fi
done

# Install the official repository packages that are not already installed
if [ ${#to_install_pacman[@]} -ne 0 ]; then
    echo "Installing the following official repository packages: ${to_install_pacman[*]}"
    sudo pacman -S --noconfirm "${to_install_pacman[@]}"
else
    echo "All specified official repository packages are already installed."
fi

# Install the AUR packages that are not already installed
if [ ${#to_install_aur[@]} -ne 0 ]; then
    echo "Installing the following AUR packages: ${to_install_aur[*]}"
    yay -S --noconfirm "${to_install_aur[@]}"
else
    echo "All specified AUR packages are already installed."
fi

echo "Script completed."
