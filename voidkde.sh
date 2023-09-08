#!/bin/bash
# Idea by callmezatiel
# version by hhk02 and callmezatiel


##Update and repo Installation:
sudo xbps-install -Su
sudo xbps-install void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree

##Base KDE Installation:
sudo xbps-install xorg kde5 kde5-baseapps xdg-user-dirs xdg-utils xtools  micro NetworkManager bluez tlp tlp-rdw preload rsync

##Services:
sudo ln -s /etc/sv/dbus /var/service/
sudo ln -s /etc/sv/sddm /var/service/
sudo ln -s /etc/sv/NetworkManager /var/service/

##Start Services:
sudo sv up dbus
sudo sv up sddm
sudo sv up NetworkManager

##Build essentials:
sudo xbps-install base-devel make cmake rust cargo

##Drivers:
sudo xbps-install intel-video-accel mesa-vulkan-intel vulkan-loader mesa-intel-dri ffmpeg ffmpegthumbs pulseaudio alsa-utils pipewire

##Services:
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

##Reboot:
sudo reboot

##Applications:
sudo xbps-install neofetch htop alacritty firefox libreoffice wget curl kvantum  timeshift qt5 qt5-core qt5-devel ark vlc udisks2 exa zsh grub-customizer spectacle evince kcalc gwenview fbv ntfs-3g telegram-desktop hplip octoxbps qbittorrent pipewire obs gnome-disk-utility plymouth

##Fonts
sudo xbps-install nerd-fonts nerd-fonts-ttf ttf-ubuntu-font-family terminus-font

##Browser Font Configuration:
sudo ln -s /usr/share/fontconfig/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d/
sudo xbps-reconfigure -f fontconfig

#MSCoreFonts:
git clone https://github.com/void-linux/void-packages.git
cd void-packages
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
./xbps-src binary-bootstrap
./xbps-src pkg msttcorefonts
xi msttcorefonts

##Bangla Fonts
wget --no-check-certificate https://raw.githubusercontent.com/fahadahammed/linux-bangla-fonts/master/font.sh -O font.sh;chmod +x font.sh;bash font.sh;rm font.sh

or,

wget --no-check-certificate https://raw.githubusercontent.com/fahadahammed/linux-bangla-fonts/master/dist/lbfi -O lbfi;chmod +x lbfi;./lbfi


##OpenBangla Keyboard
sudo xbps-install ibus ibus-devel
git clone --recursive https://github.com/OpenBangla/OpenBangla-Keyboard.git
cd OpenBangla-Keyboard
mkdir build && cd build
cmake ..
make
sudo make install
#Logo Change:
sudo cp BN.png /usr/share/openbangla-keyboard/icons
sudo micro /usr/share/ibus/component/openbangla.xml

##Plymouth Theme:
sudo plymouth-set-default-theme --list
sudo plymouth-set-default-theme -R bgrt

##Touchegg (Fot Laptop touchpad gestures)
add touchegg
sudo ln -s /etc/sv/touchegg /var/service/
sudo sv up touchegg
mkdir -p ~/.config/touchegg && cp -n /usr/share/touchegg/touchegg.conf ~/.config/touchegg/touchegg.conf
#kate .config/touchegg/touchegg.conf  ###Configure to your likings

##Reboot:
sudo reboot

