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





# Prüfen, ob die Variable $BOARD gesetzt ist
if [ -z "$BOARD" ]; then
  echo "${RED}ERROR${NC}: ${CYAN}Var \$BOARD not set!."
  exit 1
fi


# Setzen der hwboard-Variablen
hwboard=$BOARD





# Pfade, dessen rechte gesetzt werden müssen
paths=("/etc/init.d/set_led_trigger.sh" "/var/lib/bananapi" "/usr/share/libarys")

# Verzeichnisse die erstellt werden müssen
dirs=("/var/lib" "/usr/local/bin" "/usr/share/libarys")


# Definiere onBOARD LED init.d-Service Trigger Scripts
TMP_LED_TRIGGER="/tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh" # File in OVERLAY (NEEDS COPY TO)
LED_TRIGGER_SERVICE="/etc/init.d/set_led_trigger.sh" # File in CHROOT-TARGET


# GPIO Libarys Dir
#$GPIO_LIBARYS="/usr/share/libarys"


# Definieren des Quell- und Zielverzeichnisses der Board-Determinier Datein
BOARD_DETERMINER_SOURCE_DIR="/tmp/overlay/boards/$hwboard"
BOARD_DETERMINER_TARGET_DIR="/var/lib"


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



function create_dirs() {
    echo "${GREEN}INFO ${BLACK}: ${CYAN}Creating directories: ${dirs[@]} ${NC}"
	for dir in "${dirs[@]}"; do
		mkdir -p "$dir"
		chmod 777 -R "$dir"
	done
}

function grant_permissions() {
	echo "${GREEN}INFO ${BLACK}: ${CYAN}GRANT PERMISSIONS: ${paths[@]} ${NC}"
	for path in "${paths[@]}"; do
		chmod 777 -R "$path"
	done
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
	  stretch|buster|bullseye|bookworm|trixie|sid|xenial|bionic|focal|jammy|noble)
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

  if [[ ! -f "$package_file" ]]; then
    echo "File $package_file not found!"
    return 1
  fi
  while IFS= read -r package; do
    if [[ -n "$package" ]]; then
      echo "installing $package..."
      apt-get install -y "$package"
    fi
  done < "$package_file"
}

function git_repos() {
    echo -e "${RED}Console > ${NC}${CYAN} Cloning Git-Repoisotrys!"

  	git_repos="/tmp/overlay/git_repos/repos.txt"
  	if [ ! -f "$git_repos" ]; then
	    echo "$git_repos does not exist."
	    exit 1
	fi

	while IFS= read -r repo; do
	    echo "Cloning $repo..."
		cd /usr/share/libarys
	    git clone "$repo"
	done < "$git_repos"
}




function board_determiner() {
    # Überprüfen, ob das Quellverzeichnis existiert
    if [ -d "$BOARD_DETERMINER_SOURCE_DIR" ]; then
        # Kopieren der Dateien und Verzeichnisse
        cp -r "$BOARD_DETERMINER_SOURCE_DIR"/* "$BOARD_DETERMINER_TARGET_DIR"/
  
        echo "${GREEN}INFO: ${CYAN}COPYIN FROM > $BOARD_DETERMINER_SOURCE_DIR | to >  $BOARD_DETERMINER_TARGET_DIR | !."
    else
        echo "${RED}ERROR: ${CYAN}Dir $BOARD_DETERMINER_SOURCE_DIR dosent exist."
        exit 1
    fi
}


function led_trigger() {
	echo "${GREEN}INFO: Settingup onBOARD LED Trigger to: ${RED}RED: ${BLUE}CPU0 ${GREEN}GREEN: ${CYAN}heartbeat!"

	case $hwboard in 
		bananapim2ultra)
			echo "${GREEN}INFO: ${CYAN}Copying LED-Trigger from overlay to /etc/init.d !"
			cp -r "${TMP_LED_TRIGGER}" "${LED_TRIGGER_SERVICE}"
			grant_permissions;
			echo "Enable init.d Service!"
			sleep 1
			manage_service "set_led_trigger.sh" "defaults"
			;;
		bananapim2berry)
			echo "${GREEN}INFO: ${CYAN}Copying LED-Trigger from overlay to /etc/init.d !"
			cp -r "${TMP_LED_TRIGGER}" "${LED_TRIGGER_SERVICE}"
			grant_permissions;
			echo "Enable init.d Service!"
			sleep 1
			manage_service "set_led_trigger.sh" "defaults"
			;;
        *)
            echo "INVALID"
            ;;
    esac
}





function build() {
    apt-get update
    install "ubuntu" "noble"
    
    create_dirs
    board_determiner
    grant_permissions
    led_trigger
    git_repos
    grant_permissions
}


Main() {
	case $RELEASE in
		stretch)
			build;
			;;
		buster)
			build;
			;;
		jammy)
			build
			;;
		xenial)
			build;
			;;
		bookworm)
			build;
			;;
		bullseye)
			build;
			;;
		bionic)
			build;
			;;
		focal)
			build;
			;;
		noble)
			build;
			;;
        sid)
			build;
			;;
        trixie)
			build;
			;;
	esac
}
