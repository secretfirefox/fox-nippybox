#!/usr/bin/env bash
set -e

OndeEstou=`pwd`

verificarDiretorios () {
	mkdir -p $HOME/.local/bin
	mkdir -p $HOME/.config
	mkdir -p $HOME/.themes/nippybox
}

instalarPacotes () {
	echo -e "\n## Instalando Pacotes Básicos..."
	sleep 1
	sudo pacman -Syu openbox xorg obconf-qt archlinux-xdg-menu polybar rofi libnotify dunst nitrogen picom xcompmgr plank xfce4-settings xfce4-power-manager python-pywal maim xclip slop xdg-user-dirs ffmpeg acpi thunar alacritty geany pavucontrol viewnior network-manager-applet blueman gvfs xfce4-terminal pulsemixer xorg-xbacklight pulseaudio pulseaudio-bluetooth pulseaudio-alsa --noconfirm
}

instalarFontes () {
	echo -e "\nPara o funcionamento correto do Nippybox,algumas fontes precisam serem instaladas, e elas serão instaladas em /usr/share/fonts, para estarem disponíveis para todos os usuários\n\n## Instalando as Fontes..."
	sudo cp fonts/* /usr/share/fonts
	sudo fc-cache -f
	cd ..
}

copiarConfigs () {
	echo -e "## Copiando as Configurações..."
	cp -r $OndeEstou/config/* $HOME/.config/
	cd ..

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
	bash $HOME/.local/bin/nippy-colorizer $HOME/.config/openbox/wallpaper.jpg

	echo "## Configurando o Wallpaper Padrão..."

	{
		cat <<EOF

[xin_-1]
file=$HOME/.config/openbox/wallpaper.jpg
mode=5
bgcolor=#000000

EOF
	} > $HOME/.config/nitrogen/bg-saved.cfg


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
	sudo pacman -S lightdm lightdm-gtk-greeter parcellite galculator xarchiver mpv xreader arj cpio lha lrzip lzip lzop p7zip unarj unarj unzip cups sane thunar-volman thunar-archive-plugin thunar-media-tags-plugin tumbler ffmpegthumbnailer libgepub libgsf libopenraw poppler-glib freetype2 firefox --noconfirm

	echo "## Instalando Suporte ao Flatpak..."
	sleep 1
	sudo pacman -S flatpak xdg-desktop-portal-gtk --noconfirm

	echo "## Habilitando o Serviço do LightDM no SystemD"
	sudo systemctl enable lightdm

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
finalizarConfig
creditos
sleep 5
startx
