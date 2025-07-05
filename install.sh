#!/usr/bin/env bash

OndeEstou=`pwd`

verificarDiretorios () {

	if [ -d "$HOME/.local/bin" ]; then
		mkdir -p $HOME/.local/bin
	else
		echo "" > /dev/null
	fi

	if [ -d "$HOME/.config" ]; then
		mkdir -p $HOME/.config
	else
		echo "" > /dev/null
	fi

}

verificarDependencias () {
	echo -e "\n## Verificando Dependências..."
	install=""
	## Verificando se as Dependências estão instaladas

	echo "=== DESKTOP ==="
	## Openbox, xorg, obconf-qt
	if [ -z "$(command -v openbox)" ]; then
			echo "- Openbox: Não Instalado"
			install+="openbox xorg obconf-qt "
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

	## PyWal
	if [ -z "$(command -v wal)" ]; then
			echo "- PyWal: Não Instalado"
			install+="python-pywal "
		else
			echo "- PyWal: OK"
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

# 	echo -e "\n=== PACOTES DO AUR ==="
# 	## betterlockscreen (AUR)
# 	if [ -z "$(command -v betterlockscreen)" ]; then
# 			echo "- betterlockscreen: Não Instalado"
# 			AURinstall+="betterlockscreen "
# 		else
# 			echo "- betterlockscreen: OK"
# 	fi

}

instalarDependenciasAUR () {
	echo -e "\n## Instalando as Dependências do AUR..."
	yay $install --answerdiff=None --noconfirm
}

# instalarAUR () {
# 	if [[ $AURinstall == "" ]]; then
# 		echo "" >> /dev/null
# 	else
#
# 		echo -e "\nHá alguns pacotes que compõe o Nippybox que estão no AUR (Arch Linux User Repository), e para instalar eles é necessário o uso de um ajudante de AUR. O yay é o Ajudante de AUR que esse Script utiliza."
#
# 		if [ -z "$(command -v yay)" ]; then
# 			read -p "O Yay não foi encontrado. Deseja instalar o yay? [S/n]: " iYay
#
# 			if [[ $iYay == "S" ]]; then
# 				echo -e "\n## Instalando as Dependências do Yay..."
# 				sudo pacman -S git go --noconfirm
#
# 				echo -e "\n## Clonando o Repositório do Yay..."
# 				git clone https://aur.archlinux.org/yay.git
# 				cd yay
#
# 				echo -e "\n## Instalando o Yay"
# 				makepkg -si
# 				instalarDependenciasAUR
# 			else
# 				echo -e "\n## Ignorando os Pacotes do AUR..."
# 			fi
# 		else
# 			instalarDependenciasAUR
# 		fi
# 	fi
# }

instalarDependencias () {
	if [[ $install == "" ]]; then
		echo "" >> /dev/null
	else
		echo "## Instalando as Dependências Faltantes..."
		sudo pacman -Syu $install --noconfirm
	fi
}

instalarFontes () {
	echo -e "Para o Nippybox, são utilizadas algumas fontes para a Interface. E elas serão instaladas globalmente em /usr/share/fonts."
	sudo cp fonts/* /usr/share/fonts
	sudo fc-cache -vf
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

}

echo -e "Bem-vindo ao instalador do Nippybox!\nO Nippybox é uma personalização do Openbox que acabei criando e que atende às minhas necessidades\n\nEventualmente o Script irá pedir a senha do super-usuário (root) para instalar alguns pacotes faltantes e as fontes, mas não se preocupe."
sleep 1
verificarDependencias
instalarDependencias
instalarFontes
copiarConfigs
# instalarAUR




