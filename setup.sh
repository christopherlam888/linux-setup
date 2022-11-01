#!/bin/bash

#A simple bash script to setup a Debian/Ubuntu-based Linux system by installing useful applications using the apt package manager.

AppNames=("ACPI" "BleachBit" "ClamTk" "FreeCAD" "GIMP" "Git" "GParted" "HandBrake" "htop" "Kdenlive" "OBS Studio" "OnlyOffice" "Psensor" "Vim" "VLC")

PackageNames=("acpi" "bleachbit" "clamtk" "freecad" "gimp" "git" "gparted" "handbrake" "htop" "kdenlive" "obs-studio" "onlyoffice-desktopeditors" "psensor" "vim" "vlc")

ToInstall=()

LibreWolfInstall="N"

BraveInstall="N"

SignalInstall="N"

ElementInstall="N"

#Get user input on whether to install each application
for i in ${!AppNames[@]}; do
	read -p "Would you like to install ${AppNames[$i]}? (y/N) " response
	if [[ $response == "y" ]] || [[ $response == "Y" ]]; then
		ToInstall+="${PackageNames[$i]} "
	fi
done

#Get user input on whether to install applications not included in default repos
read -p "Would you like to install LibreWolf? (y/N) " LibreWolfInstall
read -p "Would you like to install Brave? (y/N) " BraveInstall
read -p "Would you like to install Signal? (y/N) " SignalInstall
read -p "Would you like to install Element? (y/N) " ElementInstall


#Install each application package using apt
if (( ${#ToInstall[@]} != 0 )); then
	for package in ${ToInstall[@]}; do
       		sudo apt install ${package}
	done
fi

#Install tools
sudo apt install apt-transport-https curl wget

#Install LibreWolf
if [[ "$LibreWolfInstall" == "y" ]] || [[ "$LibreWolfInstall" == "Y" ]]; then
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
fi

#Install Brave
if [[ "$BraveInstall" == "y" ]] || [[ "$BraveInstall" == "Y" ]]; then
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
    sudo apt update && sudo apt install brave-browser
fi

#Install Signal
if [[ "$SignalInstall" == "y" ]] || [[ "$SignalInstall" == "Y" ]]; then
    wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > signal-desktop-keyring.gpg
    cat signal-desktop-keyring.gpg | sudo tee -a /usr/share/keyrings/signal-desktop-keyring.gpg > /dev/null
    echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' |\
      sudo tee -a /etc/apt/sources.list.d/signal-xenial.list
    sudo apt update && sudo apt install signal-desktop
fi

#Install Element
if [[ "$ElementInstall" == "y" ]] || [[ "$ElementInstall" == "Y" ]]; then
    sudo wget -O /usr/share/keyrings/element-io-archive-keyring.gpg https://packages.element.io/debian/element-io-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/element-io-archive-keyring.gpg] https://packages.element.io/debian/ default main" | sudo tee /etc/apt/sources.list.d/element-io.list
    sudo apt update && sudo apt install element-desktop
fi

