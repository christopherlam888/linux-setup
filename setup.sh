#!/bin/bash

#A simple bash script to setup a Debian/Ubuntu-based Linux system by installing useful applications using the apt package manager.

# Declare packages
declare -A packages

packages=(
    [1]="ACPI"
    [2]="BleachBit"
    [3]="Brave"
    [4]="ClamTk"
    [5]="Element"
    [6]="FreeCAD"
    [7]="GIMP"
    [8]="Git"
    [9]="GParted"
    [10]="Handbrake"
    [11]="htop"
    [12]="Kdenlive"
    [13]="LibreWolf"
    [14]="OnlyOffice"
    [15]="OBS Studio"
    [16]="Psensor"
    [17]="Signal"
    [18]="Vim"
    [19]="VLC"
)

# Prompt user input
echo "Which program(s) would you like to install? Enter the corresponding number(s) separated by commas:"
for key in $(IFS=$'\n'; echo "${!packages[*]}" | sort -n); do
    echo "$key. ${packages[$key]}"
done

# Read user input
read program_choice

# Remove spaces
program_choice=${program_choice// /}

# Convert to array
IFS=',' read -ra choices <<< "$program_choice"

# Install tools
sudo apt install apt-transport-https curl wget -y

# Install packages
for choice in "${choices[@]}"; do
    case $choice in
        1) # ACPI
            echo "Installing ${packages[$choice]}..."
            sudo apt install acpi -y
            ;;
        2) # BleachBit
            echo "Installing ${packages[$choice]}..."
            sudo apt install bleachbit -y
            ;;
        3) # Brave
            echo "Installing ${packages[$choice]}..."
            sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
            sudo apt update && sudo apt install brave-browser -y
            ;;
        4) # ClamTk
            echo "Installing ${packages[$choice]}..."
            sudo apt install clamtk -y
            ;;
        5) # Element
            echo "Installing ${packages[$choice]}..."
            sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list
            sudo apt update && sudo apt install element-desktop -y
            ;;
        6) # FreeCAD
            echo "Installing ${packages[$choice]}..."
            sudo apt install freecad -y
            ;;
        7) # GIMP
            echo "Installing ${packages[$choice]}..."
            sudo apt install gimp -y
            ;;
        8) # Git
            echo "Installing ${packages[$choice]}..."
            sudo apt install git -y
            ;;
        9) # GParted
            echo "Installing ${packages[$choice]}..."
            sudo apt install gparted -y
            ;;
        10) # Handbrake
            echo "Installing ${packages[$choice]}..."
            sudo apt install handbrake -y
            ;;
        11) # htop
            echo "Installing ${packages[$choice]}..."
            sudo apt install htop -y
            ;;
        12) # Kdenlive
            echo "Installing ${packages[$choice]}..."
            sudo apt install kdenlive -y
            ;;
        13) # LibreWolf
            echo "Installing ${packages[$choice]}..."
            distro=$(if echo " bullseye focal impish jammy uma una vanessa" | grep -q " $(lsb_release -sc) "; then echo $(lsb_release -sc); else echo focal; fi)
            wget -O- https://deb.librewolf.net/keyring.gpg | sudo gpg --dearmor -o /usr/share/keyrings/librewolf.gpg
            sudo tee /etc/apt/sources.list.d/librewolf.sources << EOF > /dev/null
            Types: deb
            URIs: https://deb.librewolf.net
            Suites: $distro
            Components: main
            Architectures: amd64
            Signed-By: /usr/share/keyrings/librewolf.gpg
EOF
            sudo apt update && sudo apt install librewolf -y
            ;;
        14) # OnlyOffice
            echo "Installing ${packages[$choice]}..."
            sudo apt install onlyoffice-desktopeditors -y
            ;;
        15) # OBS Studio
            echo "Installing ${packages[$choice]}..."
            sudo apt install obs-studio -y
            ;;
        16) # Psensor
            echo "Installing ${packages[$choice]}..."
            sudo apt install psensor -y
            ;;
        17) # Signal
            echo "Installing ${packages[$choice]}..."
            wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
            cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
            echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
              sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
            sudo apt update && sudo apt install signal-desktop -y
            ;;
        18) # Vim
            echo "Installing ${packages[$choice]}..."
            sudo apt install vim -y
            ;;
        19) # VLC
            echo "Installing ${packages[$choice]}..."
            sudo apt install vlc -y
            ;;
        *) # Invalid choice
            echo "Invalid choice: $choice. Skipping..."
            ;;
    esac
done

echo "Done!"

