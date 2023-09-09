RebootSystem ()
{
    dialog --title "Rebooting system" --msgbox "Press ENTER to reboot the system to make changes effect!" 20 30
    reboot
}


Install_Build_Essentials_Kernel_Headers ()
{
    (
        echo 50
        xbps-install base-devel make cmake rust cargo linux-headers -y
        sleep 1 
        echo 100
    ) |
    dialog --title "KDE Void Installer Script - Install Build Essentias and Kernel Headers" --gauge "Installing Build Essentials and Kernel Headers..." 20 30

    Install_Drivers
}



# Declare function for install Drivers

Install_Drivers ()
{
    if (lspci | grep VGA | grep "Intel"); then
        echo "Intel Graphics detected!"
        (
            echo 50
            xbps-install intel-video-accel mesa-vulkan-intel vulkan-loader mesa-intel-dri ffmpeg ffmpegthumbs pulseaudio alsa-utils pipewire -y
            sleep 1 
            echo 100
        ) |
        dialog --title "KDE Void Installer Script - Install Graphics drivers (Intel)" --gauge "Installing Intel graphics driver..." 20 30

    elif (lspci |grep VGA | grep "nVidia\|NVIDIA"); then
        echo "NVIDIA Graphics Card detected!"
        progress_graphics=0
        (
            echo 50
            xbps-install nvidia vulkan-loader ffmpeg ffmpegthumbs pulseaudio alsa-utils pipewire -y
            sleep 1 
            echo 100
        ) |
        dialog --title "KDE Void Installer Script - Install Graphics drivers (NVIDIA)" --gauge "Installing NVIDIA graphics driver..." 20 30
        
    elif (lspci | grep VGA | grep "ATI\|AMD"); then
        echo "AMD/ATI Graphics detcted!"
        progress_graphics=0
        (
            echo 50
            xbps-install linux-firmware-amd mesa-dri vulkan-loader mesa-vulkan-radeon mesa-vaapi mesa-vdpau -y
            sleep 1 
            echo 100
        ) |
        dialog --title "KDE Void Installer Script - Install Graphics drivers (ATI/AMD)" --gauge "Installing AMD graphics driver..." 20 30

    fi

    Install_KDE
}



# Declare function for Install KDE Desktop
Install_KDE () 
{
    echo "Installing Xorg and KDE Desktop....."

        
    progress_audio_drivers=0
    ( 
        echo 50
        xbps-install alsa-utils alsa-plugins-pulseaudio ffmpeg ffmpegthumbs pulseaudio pipewire -y
        sleep 1
        echo 100
    ) |
    dialog --title "KDE Void Installer Script - Install Audio Libraries" --gauge "Installing audio drivers.." 20 30




    progress_install_kde=0
    (
        echo 50
        xbps-install xorg kde5 kde5-baseapps xdg-user-dirs xdg-utils xtools  micro NetworkManager bluez tlp tlp-rdw preload rsync -y
        sleep 1
        echo 100
    ) |
    dialog --title "KDE Void Installer Script - Install KDE Plasma Desktop" --gauge "Installing KDE DESKTOP..." 20 30

    progress_install_system_utilities=0
    (
        echo 50
        xbps-install gvfs gvfs-mtp gzip ntp procps-ng udisks2 unzip zip ark wget curl plymouth bluez tlp tlp-rdw preload zstd -y
        sleep 1
        echo 100
    ) |
    dialog --title "KDE Void Installer Script - Install System Utilities" --gauge "Installing system utilities..." 20 30

    progress_install_additional_apps=0
    (
        echo 50
        xbps-install neofetch htop alacritty kvantum timeshift qt5-devel exa grub-customizer spectacle kcalc gwenview fbv ntfs-3g telegram-desktop hplip octoxbps qbittorrent micro kate nano okular gimp libreoffice vlc obs ranger atool zsh -y
        sleep 1
        echo 100
    ) |
    dialog --title "KDE Void Installer Script - Install Additional Apps" --gauge "Installing additional apps..." 20 30

}

# Declare function for enable the services
EnableServices () 
{
    echo "Enabling services and starting..."
    # Make symbolic link to /var/service folder
    # /var/service it's the folder where are all services
    
    # Example:
    # /var/service has every single service run when turn on the system
    
    # Added by callmezatiel
    sed -i "s/--noclear/--noclear\ --skip-login\ --login-options=$USER/g" /etc/sv/agetty-tty1/conf
    rm -f /var/service/agetty-tty{3,4,5,6}
    ln -s /etc/sv/dbus /var/service/
    ln -s /etc/sv/sddm /var/service/
    ln -s /etc/sv/NetworkManager /var/service/

    sv up dbus
    #Enable Display Manager (SDDM)
    sv up sddm
    #Enable NetworkManager (This service it's fundamental for have network access)
    sv up NetworkManager

    RebootSystem
}

Welcome ()
{
    dialog --title "KDE Void Installer Script - Welcome" \
    --yesno "Welcome to a simple script to get a vanilla KDE Plasma Desktop on Void Linux. Are you sure to continue?" 20 30
    response=$?

    case $response in
        0) SystemUpgrade;;
        1) echo "Thanks for trying, Goodbye!";;
        255) echo "Thanks for trying, Goodbye!";
    esac
    
}

# Declare system upgrade function
SystemUpgrade ()
{
    dialog --title "KDE Void Installer Script - System Upgrade" \
    --yesno "Would you like to perform a system upgrade before continuing ?" 20 30
    response_system_upgrader=$?

    case $response_system_upgrader in
        0) echo "Yes i needed" ;;
        1) EnableNonFreeRepos;;
        255) EnableNonFreeRepos;
    esac
    
    (
        echo 50
        xbps-install -Syu
        sleep 1 
        echo 100
    ) |
    dialog --title "System upgrade" --gauge "Upgrading system...." 20 30

    EnableNonFreeRepos
    
}


# Declare function for enable non free repos for Void Linux
EnableNonFreeRepos () 
{
    echo "Enabling and installing non-free repos...."
    $progress_nonfree=0
    (
        echo 50
        xbps-install void-repo-nonfree void-repo-multilib void-repo-multilib-nonfree -y
        sleep 1
        echo 100
    ) |
    dialog --title "KDE Void Installer Script - Enable Non-Free Repos" --gauge "Enabling and installing non-free repos...." 20 30
    

    clear
    Install_Build_Essentials
}

