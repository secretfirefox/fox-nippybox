# This script was written by Secret Firefox.
# It is based on coelhoposa/rapoelho's Nippybox script.
# A lot of the content is borrowed also from the work of Aditya Shakya on Archcraft.
# This is a rewrite for dinit-init in Artix Linux. 
# Enjoy! 

# Install necessary packages

sudo dinitctl start dhcpcd
sudo pacman -Sy
sudo pacman -Syu
sudo pacman -S nano openbox xorg obconf-qt polybar rofi libnotify dunst picom xcompmgr plank xfce4-settings xfce4-power-manager python-pywal maim xclip slop xdg-user-dirs ffmpeg acpi thunar alacritty geany pavucontrol viewnior network-manager-applet blueman gvfs xfce4-terminal pulsemixer xorg-xbacklight pulseaudio pulseaudio-bluetooth pulseaudio-alsa --noconfirm

# Make necessary directories

xdg-user-dirs-update
mkdir -p ~/.local/bin
mkdir -p ~/.config
mkdir -p ~/.themes/
mkdir -p ~/.themes/nippybox

# Copy provided fonts

sudo cp -r fonts/* /usr/share/fonts
sudo fc-cache -f 

# Copy provided config files

cp -r config/* ~/.config/

# Copy provided themes

cp -r themes/* ~/.themes

# Copy provided scripts

cp -r scripts/* ~/.local/bin
chmod +x ~/.local/bin/*

# Apply color scheme

bash ~/.local/bin/nippy-colorizer "/usr/share/backgrounds/Tongue Cat by Nennieinszweidrei.png" --no-X11

# Set default wallpaper 

#{
#		cat <<EOF
#
#[xin_-1]
#file=/usr/share/backgrounds/Tongue Cat by Nennieinszweidrei.png
#mode=5
#bgcolor=#000000
#
#EOF
#	} > $HOME/.config/nitrogen/bg-saved.cfg

# Copy the provided .xinitrc

cp -r .xinitrc ~/

# Install extra packages

sudo pacman -S lightdm lightdm-dinit lightdm-gtk-greeter galculator xarchiver mpv xreader arj cpio lha lrzip lzip lzop p7zip unzip cups sane thunar-volman thunar-archive-plugin thunar-media-tags-plugin tumbler ffmpegthumbnailer libgepub libgsf libopenraw poppler-glib freetype2 firefox gst-plugins-ugly gst-plugins-good gst-plugins-base gst-plugins-bad gst-libav gstreamer ntfs-3g --noconfirm 

# Install flatpak

sudo pacman -S flatpak xdg-desktop-portal-gtk --noconfirm

# Enabling lightdm service on dinit

sudo dinitctl enable lightdm

# Copy provided wallpapers

sudo cp -r backgrounds/* /usr/share/

# Copy hooks for use in pacman

sudo cp misc/hooks/* /usr/bin
sudo cp mims/libalpm/* /usr/share/libalpm/hooks

# Fix thunar

nippy-hooks fix-thunar

# Install yay for needed packages for Nippybox

sudo pacman -S git go make --noconfirm

git clone https://aur.archlinux.org/yay.git

cd yay 

makepkg -si --noconfirm --needed

sudo pacman -Rs go --noconfirm

yay -Y -gendb

yay -S betterlockscreen --noconfirm --needed

cd ..

rm -rf yay/

# Inform credits

echo -e "Rofi, Polybar and some of the Scripts implemented on Nippybox were made by Aditya Shakya."

echo -e "Original code for Nippybox made by rapoelho/coelhoposa."

echo -e "Adaptation in English for Artix dinit made by secretfirefox."

echo -e "Install complete. You may want to restart the computer." 
