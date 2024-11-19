#!/bin/bash
# customize-image.sh




RELEASE=$1
LINUXFAMILY=$2
BOARD=$3
BUILD_DESKTOP=$4




BLACK='\e[0;30m'
WHITE='\e[0;37m'
RED='\e[0;31m'
BLUE='\e[0;34m'
YELLOW='\e[0;33m'
GREEN='\e[0;32m'
PURPLE='\e[0;35m'
CYAN='\e[0;36m'
NC='\033[0m'



# onBoard LED Trigger
led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh" # File in OVERLAY (NEEDS COPY TO)
initd_led_trigger_service="/etc/init.d/set_led_trigger.sh" # File in CHROOT-TARGET


# GPIO-Hardware Board Detection
$include_board_determiner_directory="/tmp/overlay/boards/"${BOARD}"/bananapi"
$board_determiner_directory="/var/lib/bananapi"

# GPIO Libarys Dir
$gpio_libarys="/usr/share/libarys"


# Grant permissions for paths below
paths=("${board_determiner_directory}" "${initd_led_trigger_service}")



# Dirs to be build
dirs=("${$board_determiner_directory}" "/usr/local/bin" "${gpio_libarys}" "/etc/init.d/")



function create_dirs() {
	echo "${GREEN}INFO ${BLACK}: ${CYAN}Creating directories: ${dirs[@]} ${NC}"
	read -p "Press any key to Create Directorys!... .. ."

	for dir in "${dirs[@]}"; do
		mkdir -p "$dir"
		chmod 777 -R "$dir"
	done
}

function grant_permissions() {
	echo "${GREEN}INFO ${BLACK}: ${CYAN}GRANT PERMISSIONS: ${paths[@]} ${NC}"
	read -p "Press any key to Grant Permissions!... .. ."

	for path in "${paths[@]}"; do
		chmod 777 -R "$path"
	done
}


function manage_service() {
	local scriptname=$1
	local option=$2

	if [[ -z "$scriptname" || -z "$option" ]]; then
		echo "Usage: manage_service <scriptname> <option>"
		echo "Options: defaults, remove, disable, enable"
		return 1
	fi

	case $option in
	defaults | remove | disable | enable)
		echo "${GREEN}INFO: ${BLUE} Register init.d-service: $scriptname "
		sudo update-rc.d "$scriptname" "$option"
		;;
	*)
		echo "Invalid option: $option"
		echo "Options: defaults, remove, disable, enable"
		return 1
		;;
	esac
}


function led_trigger() {
	echo "${GREEN}INFO: Settingup onBOARD LED Trigger to: ${RED}RED: ${BLUE}CPU0 ${GREEN}GREEN: ${CYAN}heartbeat!"

	case $BOARD in 
		bananapim2ultra)
			echo "${GREEN}INFO: ${CYAN}Copying LED-Trigger from overlay to /etc/init.d !"
			cp -r "${led_trigger_file}" "${initd_led_trigger_service}"
			grant_permissions;
			echo "Enable init.d Service!"
			sleep 1
			manage_service "set_led_trigger.sh" "defaults"
			;;
		bananapim2berry)
			echo "${GREEN}INFO: ${CYAN}Copying LED-Trigger from overlay to /etc/init.d !"
			cp -r "${led_trigger_file}" "${initd_led_trigger_service}"
			grant_permissions;
			echo "Enable init.d Service!"
			sleep 1
			manage_service "set_led_trigger.sh" "defaults"
			;;
		bananapi)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapicm4io)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim1plus)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim2)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim2plus)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim2pro)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim2s)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim2zero)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim3)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim4zero)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim5)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim7)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapim64)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapipro)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapir2)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		bananapir2pro)
			led_trigger_file="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh"
			;;
		*)
			echo "Configuring: $BOARD "
			echo "Board not supported"
			;;
		esac
}



function board_determiner() {

	echo -e "${GREEN}INFO: ${CYAN}Executing Board Determiner!... .. ."
	echo "${RED}Detected Board:${BLUE} $BOARD "
	read -p "Press any key to Copy Board-Determinier!... .. ."


	case $BOARD in
		bananapi)
			echo "Configuring: BananaPi"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapicm4io)
			echo "Configuring: BananaPi CM4IO"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim1plus)
			echo "Configuring: BananaPi M1 Plus"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim2)
			echo "Configuring: BananaPi M2"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim2berry)
			echo "${GREEN}INFO: ${RED}Building Board-Determinier for: ${CYAN}BananaPi M2 Berry"
			echo "${GREEN}INFO: ${RED}Copying Board Determiner-Files from overlay to /var/lib/bananapi !"

			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			led_trigger;

			echo "INFO: Board-Determiner Function Execution Finished!!"
			;;
		bananapim2ultra)
			echo "${GREEN}INFO: ${RED}Building Board-Determinier for: ${CYAN}BananaPi M2 Berry"
			echo "${GREEN}INFO: ${RED}Copying Board Determiner-Files from overlay to /var/lib/bananapi !"

			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			led_trigger;
			
			echo "INFO: Board-Determiner Function Execution Finished!!"
			;;
		bananapim2plus)
			echo "Configuring: BananaPi M2 Plus"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim2pro)
			echo "Configuring: BananaPi M2 Pro"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim2s)
			echo "Configuring: BananaPi M2S"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim2zero)
			echo "Configuring: BananaPi M2 Zero"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim3)
			echo "Configuring: BananaPi M3"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim4zero)
			echo "Configuring: BananaPi M4 Zero"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim5)
			echo "Configuring: BananaPi M5"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim7)
			echo "Configuring: BananaPi M7"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapim64)
			echo "Configuring: BananaPi M64"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapipro)
			echo "Configuring: BananaPi Pro"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapir2)
			echo "Configuring: BananaPi R2"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		bananapir2pro)
			echo "Configuring: BananaPi R2 Pro"
			cp -r "${include_board_determiner_directory}" "${board_determiner_directory}"
			;;
		*)
			echo "Configuring: $BOARD "
			echo "Board not supported"
			;;
		esac
}

function install() {
	local distro=$1
	local release=$2

	if [[ -z "$distro" || -z "$release" ]]; then
		echo "Usage: install <distro> <release>"
		echo "Distro: debian, ubuntu"
		echo "Release-Debian: stretch, buster, bullseye, bookworm, trixie, sid"
		echo "Release-Ubuntu: xenial, bionic, focal, jammy, noble"
		echo "Release-Both: default"
		return 1
	fi

	case $release in
		stretch | buster | bullseye | bookworm | trixie | sid | xenial | bionic | focal | jammy | noble)
			packages_file="/tmp/overlay/packages_files/$distro/$release.txt"
			install_packages "${packages_file}"
			;;
		default)
			packages_file="/tmp/overlay/packages_files/$release.txt"
			install_packages "${packages_file}"
			;;
		*)
			echo "Invalid Release!"
			return 1
			;;
	esac
}

function install_packages() {
	local package_file=$1

	echo -e "${RED}Console > ${NC}${CYAN} Installing APT-Packages!"
    read -p "Press any key to continue!... .. ."

	if [[ ! -f "$package_file" ]]; then
		echo "File $package_file not found!"
		return 1
	fi
	while IFS= read -r package; do
		if [[ -n "$package" ]]; then
			echo "installing $package..."
			apt-get install -y "$package"
		fi
	done <"$package_file"
}

function git_repos() {
	echo -e "${RED}Console > ${NC}${CYAN} Cloning Git-Repoisotrys!"
    read -p "Press any key to continue!... .. ."

	git_repos="/tmp/overlay/git_repos/repos.txt"
	sleep 2
	if [ ! -f "$git_repos" ]; then
		echo "$git_repos does not exist."
		exit 1
	fi

	while IFS= read -r repo; do
		echo "Cloning $repo..."
		cd /usr/share/libarys
		git clone "$repo"
	done <"$git_repos"

	echo "INFO: Git-Repoisotrys Cloning Finished!"
	sleep 2
}



function copy_overlay() {
	echo -e "Executing Overlay Copy... .. ."
	echo "Copying overlay files to /tmp/overlay"
}


function build() {
	create_dirs
	grant_permissions
	board_determiner
	apt-get update
	install "ubuntu" "noble"
	git_repos

}



Main() {
	case $RELEASE in
	stretch)
		build
		;;
	buster)
		build
		;;
	bullseye)
		build
		;;
	bookworm)
		build
		;;
	jammy)
		build
		;;
	noble)
		build
		;;
	sid)
		build
		;;
	trixie)
		build
		;;
	bionic)
		build
		;;
	focal)
		build
		;;
	esac
}