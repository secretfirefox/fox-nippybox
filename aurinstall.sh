#!/usr/bin/env bash

instalarAUR () {
	echo -e "\nHá alguns pacotes que compõe o Nippybox que estão no AUR (Arch Linux User Repository), e para instalar eles é necessário o uso de um ajudante de AUR. O yay é o Ajudante de AUR que esse Script utiliza."
	sleep 1

	echo -e "\n## Instalando as Dependências do Yay..."
	sudo pacman -S git go make --noconfirm

	echo -e "\n## Clonando o Repositório do Yay..."
	git clone https://aur.archlinux.org/yay.git
	cd yay

	echo -e "\n## Instalando o Yay"
	makepkg -si --noconfirm --needed

	echo "## Instalando as Dependências Faltantes..."
	sudo yay -S betterlockscreen --noconfirm --needed
}

instalarAUR




