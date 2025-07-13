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
	sudo pacman -Syu nano openbox xorg obconf-qt archlinux-xdg-menu polybar rofi libnotify dunst nitrogen picom xcompmgr plank xfce4-settings xfce4-power-manager python-pywal maim xclip slop xdg-user-dirs ffmpeg acpi thunar alacritty geany pavucontrol viewnior network-manager-applet blueman gvfs xfce4-terminal pulsemixer xorg-xbacklight pulseaudio pulseaudio-bluetooth pulseaudio-alsa playerctl --noconfirm --needed
}

instalarFontes () {
	echo -e "\n## Instalando as Fontes..."
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
	bash $HOME/.local/bin/nippy-colorizer "/usr/share/backgrounds/Tongue Cat by Nennieinszweidrei.png" --no-X11


	echo "## Gerando o .xinitrc..."

	{
		cat <<EOF
#!/bin/bash

XDG_SESSION_TYPE=x11
exec openbox-session

EOF
	} > $HOME/.xinitrc

	echo "## Configurando o Plano de Fundo da Tela de Bloqueio..."
	betterlockscreen -u "/usr/share/backgrounds/Tongue Cat by Nennieinszweidrei.png"

}

instalarExtras () {
	echo "## Instalando Pacotes Extras..."
	sleep 1
	sudo pacman -S lightdm lightdm-gtk-greeter parcellite galculator xarchiver mpv xreader arj cpio lha lrzip lzip lzop p7zip unarj unzip cups sane thunar-volman thunar-archive-plugin thunar-media-tags-plugin tumbler ffmpegthumbnailer libgepub libgsf libopenraw poppler-glib freetype2 firefox gst-plugins-ugly gst-plugins-good gst-plugins-base gst-plugins-bad gst-libav gstreamer ntfs-3g --noconfirm --needed

	echo "## Instalando Suporte ao Flatpak..."
	sleep 1
	sudo pacman -S flatpak xdg-desktop-portal-gtk --noconfirm --needed

	echo "## Habilitando o Serviço do LightDM no SystemD"
	sudo systemctl enable lightdm

	echo "## Copiando Wallpapers para /usr/share/backgrounds..."
	sudo cp -r $OndeEstou/backgrounds /usr/share

	echo "## Copiando Hooks para uso no Pacman..."
	chmod +x $OndeEstou/misc/hooks/*
	sudo cp $OndeEstou/misc/hooks/* /usr/bin/
	sudo cp $OndeEstou/misc/libalpm/* /usr/share/libalpm/hooks

	echo "## Corrigindo o Thunar..."
	sudo nippy-hooks fix-thunar

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
	yay -S betterlockscreen --noconfirm

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
instalarAUR
finalizarConfig
creditos
sleep 5
startx
