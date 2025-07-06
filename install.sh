#!/usr/bin/env bash
set -e

OndeEstou=`pwd`

verificarDiretorios () {
	mkdir -p $HOME/.local/bin
	mkdir -p $HOME/.config
	mkdir -p $HOME/.themes/nippybox
}

instalarPacotes () {
	echo -e "\n## Instalando Pacotes..."
	sleep 1
	sudo pacman -Syu openbox xorg obconf-qt archlinux-xdg-menu polybar rofi libnotify dunst nitrogen picom xcompmgr plank xfce4-settings xfce4-power-manager python-pywal maim xclip slop xdg-user-dirs ffmpeg acpi thunar alacritty geany pavucontrol viewnior network-manager-applet blueman gvfs xfce4-terminal pulsemixer xorg-xbacklight --noconfirm
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

creditos () {
	echo -e "\nCréditos ao Aditya Shakya, que foi o responsável pelas personalizações do Rofi, da Polybar e dos seguintes Scripts:\n\n	- nippy-shot: Originalmente era o ob-shot, mas foi modificado para também ter a função de ser um Pipemenu\n	- nippy-rec: Originalmente era o ac-record, e foi modificado para trabalhar como um gravador simples por linha de comando\n	- ac-randr: Não foi modificado.\n	- nippy-sysinfo: Originalmente era o ac-sysinfo e foi modificado para trabalhar como um simples fetch.\n"

}

echo -e "\nBem-vindo ao instalador do Nippybox!\nO Nippybox é uma personalização do Openbox com o objetivo de ser simples de usar em que juntei algumas coisas legais por aí e que me agradaram."

verificarDiretorios
sleep 1
instalarPacotes
instalarFontes
copiarConfigs
finalizarConfig
creditos
sleep 5
startx
