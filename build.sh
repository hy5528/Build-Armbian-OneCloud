#!/bin/bash
# build.sh





menu() {
	echo "ArmbianOS SystemBuilder Started!--- -"

	read -p "Enter Target-Board: " board
	read -p "Enter Branch: " branch
	read -p "Enter Release: " release
	read -p "Enter Minimal(Yy|Nn): " minimal
	read -p "Enter Desktop(YyNn): " desktop
	read -p "Enter Kernel(Yy|Nn): " kernel
	read -p "Enter Kernel_Configure(Yy|Nn): " kernelconfigure

	./compilse.sh BOARD=$board BRANCH=$branch RELEASE=$release BUILD_MINIMAL=$minimal BUILD_DESKTOP=$desktop KERNEL=$kernel KERNEL_CONFIGURE=$kernelconfigure
}
menu;
