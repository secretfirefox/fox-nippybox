#!/usr/bin/env bash
set -e

OndeEstou=$(dirname "$0")
if [[ "$OndeEstou" == "." ]]; then
    OndeEstou=$(pwd)
fi

LightDMBack="Oranges by tamanna_rumee.png"

verificarDiretorios () {
	echo -e "\n## Verificando Diretórios..."
	mkdir -p $HOME/.local/bin
	mkdir -p $HOME/.local/share/plank/themes
	mkdir -p $HOME/.config
	mkdir -p $HOME/.themes/nippybox
	mkdir -p $HOME/.config/xfce4/xfconf/xfce-perchannel-xml/
}

instalarPacotes () {
	echo -e "\n## Instalando Pacotes Básicos..."
	sleep 1
	sudo pacman -Syu nano fastfetch openbox xorg obconf-qt archlinux-xdg-menu polybar rofi libnotify dunst nitrogen picom xcompmgr plank xfce4-settings xfce4-power-manager python-pywal maim xclip slop xdg-user-dirs ffmpeg acpi thunar alacritty geany pavucontrol viewnior network-manager-applet blueman gvfs xfce4-terminal pulsemixer xorg-xbacklight pulseaudio pulseaudio-bluetooth pulseaudio-alsa playerctl clipnotify noto-fonts-emoji bash-completion mate-system-monitor brightnessctl system-config-printer bluez-utils redshift curl qt5ct qt6ct --noconfirm --needed
}

instalarFontes () {
	echo -e "\n## Instalando as Fontes..."
	sudo cp fonts/* /usr/share/fonts
	sudo fc-cache -f
	cd $ondeEstou
}

copiarConfigs () {
	echo -e "## Copiando as Configurações..."
	cp -r $OndeEstou/config/* $HOME/.config/

	echo "## Copiando Temas..."
	cp -r $OndeEstou/themes/* $HOME/.themes/

	echo "## Copiando Scripts..."
	cp -r $OndeEstou/scripts/* $HOME/.local/bin/
	chmod +x $HOME/.local/bin/*
}

finalizarConfig () {
	echo "## Gerando as pastas do Usuário"
	xdg-user-dirs-update

	echo "## Aplicando o Esquema de Cores"
	bash $HOME/.local/bin/nippy-colorizer "/usr/share/backgrounds/Tongue Cat by Nennieinszweidrei.png" --no-X11
	
	echo "## Aplicando Temas"
	xfconf-query -c xsettings -p /Net/ThemeName -s "Dracula"
	xfconf-query -c xsettings -p /Net/IconThemeName -s "Papirus-Dark"
	xfconf-query -c xsettings -p /Gtk/FontName -s "Cantarell 9"

	echo "## Configurando a Doca"
	dconf write /net/launchpad/plank/docks/dock1/zoom-enabled true
	dconf write /net/launchpad/plank/docks/dock1/theme "'Nippy'"
	

	echo "## Gerando o .xinitrc..."

	{
		cat <<EOF
#!/bin/bash

XDG_SESSION_TYPE=x11
exec openbox-session

EOF
	} > $HOME/.xinitrc
}

instalarExtras () {
	echo "## Instalando Pacotes Extras..."
	sleep 1
	sudo pacman -S lightdm lightdm-gtk-greeter mate-system-monitor galculator xarchiver mpv xreader arj cpio lha lrzip lzip lzop p7zip unarj unzip cups sane thunar-volman thunar-archive-plugin thunar-media-tags-plugin tumbler ffmpegthumbnailer libgepub libgsf libopenraw poppler-glib freetype2 firefox gst-plugins-ugly gst-plugins-good gst-plugins-base gst-plugins-bad gst-libav gstreamer ntfs-3g mpv-mpris webp-pixbuf-loader libwebp tumbler papirus-icon-theme --noconfirm --needed

	if ! [ -z "$(ls /sys/class/power_supply/)" ]; then
		echo "## Instalando o TLP..."
		sudo pacman -S tlp --noconfirm --needed
	fi

	echo "## Instalando Suporte ao Flatpak..."
	sleep 1
	sudo pacman -S flatpak xdg-desktop-portal-gtk --noconfirm --needed

	echo "## Habilitando o Serviço do LightDM no SystemD"
	sudo systemctl enable lightdm
	
	echo "## Copiando Wallpapers para /usr/share/backgrounds..."
	sudo cp -r $OndeEstou/backgrounds /usr/share

	echo "## Definindo o Wallpaper do LightDM"
	sudo cp "/usr/share/backgrounds/$LightDMBack" /usr/share/pixmaps
	sudo mv "/usr/share/pixmaps/$LightDMBack" "/usr/share/pixmaps/background.png"
	sudo sed -i 's|^#\(background=.*\)|\1|' /etc/lightdm/lightdm-gtk-greeter.conf # Descomentando a linha certa para que o Lightdm configure o Background
	sudo sed -i 's|^background=.*|background=/usr/share/pixmaps/background.png|' /etc/lightdm/lightdm-gtk-greeter.conf # Configurando o Background do Lightdm
	
	echo "## Definindo o Tema do LightDM..."
	sudo sed -i 's|^#\(theme-name=.*\)|\1|' /etc/lightdm/lightdm-gtk-greeter.conf
	sudo sed -i 's|^theme-name=.*|theme-name=Dracula|' /etc/lightdm/lightdm-gtk-greeter.conf

	sudo sed -i 's|^#\(icon-theme-name=.*\)|\1|' /etc/lightdm/lightdm-gtk-greeter.conf
	sudo sed -i 's|^icon-theme-name=.*|icon-theme-name=Papirus-Dark|' /etc/lightdm/lightdm-gtk-greeter.conf
	
	echo "## Habilitando o Suporte à Impressão"
	sudo systemctl enable cups
	
	echo "## Habilitando o Bluetooth"
	sudo systemctl enable bluetooth
	
	echo "## Copiando Hooks para uso no Pacman..."
	chmod +x $OndeEstou/misc/hooks/*
	sudo cp $OndeEstou/misc/hooks/* /usr/bin/
	sudo cp $OndeEstou/misc/libalpm/* /usr/share/libalpm/hooks

	echo "## Corrigindo o Thunar..."
	sudo nippy-hooks fix-thunar

}

temaPlank () {
	{
		cat <<EOF
		
[PlankDrawingTheme]
TopRoundness=6
BottomRoundness=6
LineWidth=0
OuterStrokeColor=41;;41;;41;;255
FillStartColor=0;;0;;0;;217
FillEndColor=0;;0;;0;;217
InnerStrokeColor=255;;255;;255;;255

EOF
	} > $HOME/.local/share/plank/themes/hover.theme
	
}

chaoticAUR () {
	sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
	sudo pacman-key --lsign-key 3056513887B78AEB
	
	sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' --noconfirm --needed
	sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' --noconfirm --needed
	
	sudo echo -e "[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
	
	sudo pacman -Syu yay betterlockscreen dracula-gtk-theme --noconfirm --needed
}

instalarAUR () {
	cd /tmp
	echo -e "\nHá alguns pacotes que compõe o Nippybox que estão no AUR (Arch Linux User Repository), e para instalar eles é necessário o uso de um ajudante de AUR. O yay é o Ajudante de AUR que esse Script utiliza."
	sleep 1

	echo -e "\n## Instalando as Dependências do Yay..."
	sudo pacman -S git go make --noconfirm

	echo -e "\n## Clonando o Repositório do Yay..."
	git clone https://aur.archlinux.org/yay.git
	cd yay

	echo -e "\n## Construindo e Instalando o Yay..."
	makepkg -si --noconfirm --needed

	echo -e "\n## Removendo o Pacote Go, usado na Construção do Yay..."
	sudo pacman -Rs go --noconfirm

	echo -e "\n## Gerando Banco de Dados do Yay..."
	yay -Y –gendb

	echo "## Instalando os Pacotes do AUR..."
	yay -S betterlockscreen dracula-gtk-theme --noconfirm

	cd $OndeEstou
}

creditos () {
	echo -e "\nCréditos ao Aditya Shakya, que foi o responsável pelas personalizações do Rofi, da Polybar e de alguns dos Scripts que foram implementados no Nippybox"

}

echo -e "\nBem-vindo ao instalador do Nippybox!\nO Nippybox é uma personalização do Openbox com o objetivo de ser simples de usar em que juntei algumas coisas legais por aí e que me agradaram."

verificarDiretorios
sleep 1
instalarPacotes
instalarExtras
instalarFontes
copiarConfigs
#instalarAUR
chaoticAUR
finalizarConfig
temaPlank
creditos
sleep 5
reboot
