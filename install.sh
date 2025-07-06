#!/usr/bin/env bash

OndeEstou=`pwd`

verificarDiretorios () {
	mkdir -p $HOME/.local/bin
	mkdir -p $HOME/.config
	mkdir -p $HOME/.themes/nippybox
}

verificarDependencias () {
	echo -e "\n## Verificando Dependências..."
	install=""
	## Verificando se as Dependências estão instaladas

	echo "=== DESKTOP ==="
	## Openbox, xorg, obconf-qt
	if [ -z "$(command -v openbox)" ]; then
			echo "- Openbox: Não Instalado"
			install+="openbox xorg obconf-qt archlinux-xdg-menu "
		else
			echo "- Openbox: OK"
	fi

	## Polybar
	if [ -z "$(command -v polybar)" ]; then
			echo "- Polybar: Não Instalado"
			install+="polybar "
		else
			echo "- Polybar: OK"
	fi

	## Rofi
	if [ -z "$(command -v rofi)" ]; then
			echo "- Rofi: Não Instalado"
			install+="rofi "
		else
			echo "- Rofi: OK"
	fi

	## Dunst
	if [ -z "$(command -v dunst)" ]; then
			echo "- Dunst: Não Instalado"
			install+="libnotify dunst "
		else
			echo "- Dunst: OK"
	fi

	## Nitrogen
	if [ -z "$(command -v nitrogen)" ]; then
			echo "- Nitrogen: Não Instalado"
			install+="nitrogen "
		else
			echo "- Nitrogen: OK"
	fi

	## Picom
	if [ -z "$(command -v picom)" ]; then
			echo "- Picom: Não Instalado"
			install+="picom "
		else
			echo "- Picom: OK"
	fi

	## Plank
	if [ -z "$(command -v plank)" ]; then
			echo "- Plank: Não Instalado"
			install+="plank "
		else
			echo "- Plank: OK"
	fi

	echo -e "\n=== UTILITÁRIOS ==="
	## XFCE4 Settings
	if [ -z "$(command -v xfsettingsd)" ]; then
			echo "- XFCE Settings: Não Instalado"
			install+="xfce4-settings "
		else
			echo "- XFCE Settings: OK"
	fi

	## XFCE4 Power Manager
	if [ -z "$(command -v xfce4-power-manager)" ]; then
			echo "- XFCE Power Manager: Não Instalado"
			install+="xfce4-power-manager "
		else
			echo "- XFCE Power Manager: OK"
	fi

	echo -e "\n=== DEPENDÊNCIAS DE SCRIPTS ==="
	## PyWal
	if [ -z "$(command -v wal)" ]; then
			echo "- PyWal: Não Instalado"
			install+="python-pywal "
		else
			echo "- PyWal: OK"
	fi

	## Maim
	if [ -z "$(command -v maim)" ]; then
			echo "- Maim: Não Instalado"
			install+="maim "
		else
			echo "- Maim: OK"
	fi

	## XClip
	if [ -z "$(command -v xclip)" ]; then
			echo "- Xclip: Não Instalado"
			install+="xclip "
		else
			echo "- Xclip: OK"
	fi

	## XClip
	if [ -z "$(command -v slop)" ]; then
			echo "- Slop: Não Instalado"
			install+="slop "
		else
			echo "- Slop: OK"
	fi

	## XDG Users Dirs
	if [ -z "$(command -v xdg-user-dir)" ]; then
			echo "- XDG Users Dirs: Não Instalado"
			install+="xdg-user-dirs "
		else
			echo "- XDG Users Dirs: OK"
	fi

	## FFMPEG
	if [ -z "$(command -v ffmpeg)" ]; then
			echo "- FFMPEG: Não Instalado"
			install+="ffmpeg "
		else
			echo "- FFMPEG: OK"
	fi

	## ACPI
	if [ -z "$(command -v acpi)" ]; then
			echo "- ACPI: Não Instalado"
			install+="acpi "
		else
			echo "- ACPI: OK"
	fi

	echo -e "\n=== APLICATIVOS BÁSICOS ==="

	## Thunar
	if [ -z "$(command -v thunar)" ]; then
			echo "- Thunar: Não Instalado"
			install+="thunar "
		else
			echo "- Thunar: OK"
	fi

	## Alacritty
	if [ -z "$(command -v alacritty)" ]; then
			echo "- Alacritty: Não Instalado"
			install+="alacritty "
		else
			echo "- Alacritty: OK"
	fi

	## Geany
	if [ -z "$(command -v geany)" ]; then
			echo "- Geany: Não Instalado"
			install+="geany "
		else
			echo "- Geany: OK"
	fi

	##  Pulse Audio Volume Control
	if [ -z "$(command -v pavucontrol)" ]; then
			echo "- Pulse Audio Volume Control: Não Instalado"
			install+="pavucontrol "
		else
			echo "- Pulse Audio Volume Control: OK"
	fi

	##  Viewnior
	if [ -z "$(command -v viewnior)" ]; then
			echo "- Viewnior: Não Instalado"
			install+="viewnior "
		else
			echo "- Viewnior: OK"
	fi

	echo -e "\n=== APPLETS ==="
	## Network Manager Applet
	if [ -z "$(command -v nm-applet)" ]; then
			echo "- Network Manager Applet: Não Instalado"
			install+="network-manager-applet "
		else
			echo "- Network Manager Applet: OK"
	fi

	## Blueman Applet
	if [ -z "$(command -v blueman-applet)" ]; then
			echo "- Blueman Applet: Não Instalado"
			install+="blueman "
		else
			echo "- Blueman Applet: OK"
	fi
}

instalarDependenciasAUR () {
	echo -e "\n## Instalando as Dependências do AUR..."
	yay $install --answerdiff=None --noconfirm
}

instalarDependencias () {
	if [[ $install == "" ]]; then
		echo "" >> /dev/null
	else
		echo "## Instalando as Dependências Faltantes..."
		sudo pacman -Syu $install --noconfirm
	fi
}

instalarFontes () {
	echo -e "\nPara o Nippybox, são utilizadas algumas fontes para a Interface. E elas serão instaladas globalmente em /usr/share/fonts.\n\n## Copiando as Fontes..."
	sudo cp fonts/* /usr/share/fonts
	sudo fc-cache -f
	cd ..
}

copiarConfigs () {
	echo -e "\n## Copiando as Configurações..."
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

	echo "## Aplicando o Esquema de Cores e o Papel de Parede"
	nippy-colorizer $HOME/.config/openbox/wallpaper.jpg

{
	cat <<EOF
	#!/bin/bash

	exec openbox-session

EOF
	} > $HOME/.xinitrc
}

creditos () {
	echo -e "\nCréditos ao Aditya Shakya, que foi o responsável pelas personalizações do Rofi, da Polybar e dos seguintes Scripts:\n\n	- nippy-shot: Originalmente era o ob-shot, mas foi modificado para também ter a função de ser um Pipemenu\n	- nippy-rec: Originalmente era o ac-record, e foi modificado para trabalhar como um gravador simples por linha de comando\n	- ac-randr: Não foi modificado.\n	- nippy-sysinfo: Originalmente era o ac-sysinfo e foi modificado para trabalhar como um simples fetch.\n"

}

echo -e "Bem-vindo ao instalador do Nippybox!\nO Nippybox é uma personalização do Openbox que acabei criando e que atende às minhas necessidades\n\nEventualmente o Script irá pedir a senha do super-usuário (root) para instalar alguns pacotes faltantes e as fontes, mas não se preocupe."
verificarDiretorios
sleep 1
verificarDependencias
instalarDependencias
instalarFontes
copiarConfigs
finalizarConfig
creditos
sleep 5
startx
