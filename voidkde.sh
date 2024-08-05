#!/bin/bash
# Idea by callmezatiel
# version by hhk02 and callmezatiel

# Functions
EnableServices() {
  ##Services
  echo "Enabling necessary services and starting"
  sudo ln -s /etc/sv/dbus /var/service/
  sudo ln -s /etc/sv/sddm /var/service/
  sudo ln -s /etc/sv/NetworkManager /var/service/

  ##Start Services:
  sudo sv up dbus
  sudo sv up sddm
  sudo sv up NetworkManager

  sudo ln -s /etc/sv/tlp /var/service/
  sudo ln -s /etc/sv/bluetoothd /var/service/
  sudo ln -s /etc/sv/preload /var/service
  sudo ln -s /etc/sv/acpid /var/service
  sudo ln -s /etc/sv/rsync /var/service
  sudo ln -s /etc/sv/uuidd /var/service/
  sudo ln -s /etc/sv/polkitd /var/service/
  sudo ln -s /etc/sv/rtkit /var/service/

##Start service:

  sudo sv up bluetoothd
  sudo sv up acpid
  sudo sv up rsync
  sudo sv up tlp
  sudo tlp start
  sudo sv up uuidd
  sudo sv up polkitd
  sudo sv up rtkit
  echo "Done!"
}

# Main function
Start() {
  # Check if are in Void Linux
  if ( cat /etc/os-release | grep 'Void' ); then
    echo "Void Linux detected!"
  # Check if package manager it's installed or exists!
  if [ -f "/usr/bin/xbps-install" ]; then
    ##Update and repo Installation:
    echo "Updating repos"
    sudo xbps-install -Su
    echo "Adding Void Linux non-free repositories"
    sudo xbps-install void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree -y
    echo "Done!"
  ##Base KDE Installation:
    echo "Installing KDE Desktop"
    sudo xbps-install xorg kde5 kde5-baseapps xdg-user-dirs xdg-utils xtools  micro NetworkManager bluez tlp tlp-rdw preload rsync -y
    echo "Done!"
    # Install build-essential
    echo "Installing essential build libraries (build-essential)"
    sudo xbps-install base-devel make cmake rust cargo -y
    echo "Done!"
  
    # Install drivers
    echo "Installing necessary drivers for your hardware"
    if [ lspci -knn | grep -e Radeon || lspci -knn | grep -e ATI ]; then
      sudo xbps-install linux-firmware-amd mesa-vulkan-radeon vulkan-loader xf86-video-amdgpu xf86-video-ati ffmpeg ffmpegthumbs pulseaudio alsa-utils pipewire -y
      echo "Done!"
    fi
    if [ lspci -knn | grep -e NVIDIA ]; then
      echo "NVIDIA Detected!"
      sudo xbps-install nvidia vulkan-loader ffmpeg ffmpegthumbs pulseaudio alsa-utils pipewire -y
      echo "Done!"
    fi
    if [ lspci -knn | grep -e Intel ]; then
      echo "Intel Detected!"
      sudo xbps-install linux-firmware-intel mesa-vulkan-intel intel-video-accel  vulkan-loader ffmpeg ffmpegthumbs pulseaudio alsa-utils pipewire -y
      echo "Done!"
    fi
    echo "Installing apps"
    sudo xbps-install neofetch htop alacritty firefox libreoffice wget curl kvantum  timeshift qt5 qt5-core qt5-devel ark vlc udisks2 exa zsh grub-customizer spectacle evince kcalc gwenview fbv ntfs-3g telegram-desktop hplip octoxbps qbittorrent pipewire obs gnome-disk-utility plymouth -y
    echo "Done!"
    echo "Installing fonts"
    sudo xbps-install nerd-fonts nerd-fonts-ttf ttf-ubuntu-font-family terminus-font -y
    echo "Done!"
    echo "Reconfiguring fonts"
    sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
    sudo xbps-reconfigure -f fontconfig
    echo "Done!"

    echo "Downloading additional fonts"
    if [ -f "/usr/bin/git" ]; then
      git clone https://github.com/void-linux/void-packages.git
    else
      sudo xbps-install git -y
      git clone https://github.com/void-linux/void-packages.git
    fi
    cd void-packages
    echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
    ./xbps-src binary-bootstrap
    ./xbps-src pkg msttcorefonts
    xi msttcorefonts
    wget --no-check-certificate https://raw.githubusercontent.com/fahadahammed/linux-bangla-fonts/master/font.sh -O font.sh;chmod +x font.sh;bash font.sh;rm font.sh
    wget --no-check-certificate https://raw.githubusercontent.com/fahadahammed/linux-bangla-fonts/master/dist/lbfi -O lbfi;chmod +x lbfi;./lbfi

    echo "Installing OpenBangala Keyboard..."
    sudo xbps-install ibus ibus-devel -y
    git clone --recursive https://github.com/OpenBangla/OpenBangla-Keyboard.git
    cd OpenBangla-Keyboard
    mkdir build && cd build
    cmake ..
    make
    sudo make install
    echo "Done!"

    echo "Changing logo"
    sudo cp BN.png /usr/share/openbangla-keyboard/icons
    sudo micro /usr/share/ibus/component/openbangla.xml
    echo "Done!"

    echo "Chaning plymouth theme!"
    sudo plymouth-set-default-theme --list
    sudo plymouth-set-default-theme -R bgrt
    echo "Done!"

    ##Touchegg (Fot Laptop touchpad gestures)
    add touchegg
    sudo ln -s /etc/sv/touchegg /var/service/
    sudo sv up touchegg
    mkdir -p ~/.config/touchegg && cp -n /usr/share/touchegg/touchegg.conf ~/.config/touchegg/touchegg.conf
    echo "Done!"
    EnableServices
  else
    echo "No xbps found! Are you running Void Linux?"
  fi
else
  echo "No Void Linux detected!"
fi
}
if [[ "$EUID" -eq 0 ]]; then
  Start
else
  echo "ERROR: Please run as root!"
fi

