Install_Build_Essentials ()
{
    echo "Installing build-essentials...."
    xbps-install base-devel make cmake rust cargo -y

}



# Declare function for install Drivers

Install_Drivers ()
{
    if (lspci | grep VGA | grep "Intel"); then
        echo "Intel Graphics detected!"
        xbps-install intel-video-accel mesa-vulkan-intel vulkan-loader mesa-intel-dri ffmpeg ffmpegthumbs pulseaudio alsa-utils pipewire -y
    elif (lspci |grep VGA | grep "nVidia\|NVIDIA"); then
        echo "NVIDIA Graphics Card detected!"
        xbps-install nvidia vulkan-loader ffmpeg ffmpegthumbs pulseaudio alsa-utils pipewire -y
    elif (lspci | grep VGA | grep "ATI\|AMD"); then
        echo "AMD/ATI Graphics detcted!"
        xbps-install linux-firmware-amd mesa-dri vulkan-loader mesa-vulkan-radeon mesa-vaapi mesa-vdpau -y
    fi
}



# Declare function for Install KDE Desktop
Install_KDE () 
{
    echo "Installing Xorg and KDE Desktop....."
    xbps-install xorg kde5 kde5-baseapps xdg-user-dirs xdg-utils xtools  micro NetworkManager bluez tlp tlp-rdw preload rsync -y
    clear
}

# Declare function for enable the services
EnableServices () 
{
    echo "Enabling services..."
    # Make symbolic link to /var/service folder
    # /var/service it's the folder where are all services
    
    # Example:
    # /var/service has every single service run when turn on the system

    ln -s /etc/sv/dbus /var/service/
    ln -s /etc/sv/sddm /var/service/
    ln -s /etc/sv/NetworkManager /var/service/
    ln -s /etc/sv/tlp /var/service/
    ln -s /etc/sv/bluetoothd /var/service/
    ln -s /etc/sv/preload /var/service
    ln -s /etc/sv/acpid /var/service
    ln -s /etc/sv/rsync /var/service
    ln -s /etc/sv/uuidd /var/service/
    ln -s /etc/sv/polkitd /var/service/
    ln -s /etc/sv/rtkit /var/service/

    sv up dbus
    #Enable Display Manager (SDDM)
    sv up sddm
    #Enable NetworkManager (This service it's fundamental for have network access)
    sv up NetworkManager

    sv up bluetoothd
    sv up acpid
    sv up rsync
    sv up tlp
    tlp start
    sv up uuidd
    sv up polkitd
    sv up rtkit
}

# Declare function for enable non free repos for Void Linux
EnableNonFreeRepos () 
{
    echo "Enabling and installing non-free repos...."
    xbps-install -Su
    xbps-install void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree -y

    clear
}

