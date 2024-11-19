#!/bin/bash

# arguments: $RELEASE $LINUXFAMILY $BOARD $BUILD_DESKTOP
#
# This is the image customization script

# NOTE: It is copied to /tmp directory inside the image
# and executed there inside chroot environment
# so don't reference any files that are not already installed

# NOTE: If you want to transfer files between chroot and host
# userpatches/overlay directory on host is bind-mounted to /tmp/overlay in chroot
# The sd card's root path is accessible via $SDCARD variable.

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

# GPIO-Hardware Board Detection
$include_board_determiner_directory="/tmp/overlay/boards/$BOARD/bananapi"
$board_determiner_directory="/var/lib/"

# Grant permissions for paths below
paths=("/var/lib" "/usr/local/bin" "/usr/share/libarys" "/var/lib/bananapi" "/etc/init.d/set_led_trigger.sh")
# Dirs to be build
dirs=("/var/lib" "/usr/local/bin" "/usr/share/libarys")

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
		sudo update-rc.d "$scriptname" "$option"
		;;
	*)
		echo "Invalid option: $option"
		echo "Options: defaults, remove, disable, enable"
		return 1
		;;
	esac
}

function board_determiner() {

	echo -e "${GREEN}INFO: ${CYAN}Executing Board Determiner!... .. ."
	echo "${RED}Detected Board:${BLUE} $BOARD "



	case $BOARD in
	bananapi)
		echo "Configuring: BananaPi"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapicm4io)
		echo "Configuring: BananaPi CM4IO"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim1plus)
		echo "Configuring: BananaPi M1 Plus"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim2)
		echo "Configuring: BananaPi M2"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim2berry)
		echo "Configuring: BananaPi M2 Berry"
		sleep 1
		echo "Copying Board Determiner-Files from overlay to /var/lib/bananapi !"
		sleep 1
		cp -r $include_board_determiner_directory $board_determiner_directory
		echo "Copying LED-Trigger from overlay to /etc/init.d !"
		sleep 1
		cp -r /tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh /etc/init.d/set_led_trigger.sh
		echo "Grant permissions!"
		grant_permissions
		echo "Enable init.d Service!"
		sleep 1
		manage_service "set_led_trigger.sh" "defaults"
		echo "INFO: Board-Determiner Function Execution Finished!!"
		sleep 2
		;;
	bananapim2ultra)
		echo "Configuring: BananaPi M2 Ultra"
		sleep 1
		echo "Copying Board Determiner-Files from overlay to /var/lib/bananapi !"
		sleep 1
		cp -r $include_board_determiner_directory $board_determiner_directory
		echo "Copying LED-Trigger from overlay to /etc/init.d !"
		sleep 1
		cp -r /tmp/overlay/scripts/bpi-m2u-m2b/set_led_trigger.sh /etc/init.d/set_led_trigger.sh
		echo "Grant permissions!"
		grant_permissions
		echo "Enable init.d Service!"
		sleep 1
		manage_service "set_led_trigger.sh" "defaults"
		echo "INFO: Board-Determiner Function Execution Finished!!"
		sleep 2
		;;
	bananapim2plus)
		echo "Configuring: BananaPi M2 Plus"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim2pro)
		echo "Configuring: BananaPi M2 Pro"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim2s)
		echo "Configuring: BananaPi M2S"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim2zero)
		echo "Configuring: BananaPi M2 Zero"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim3)
		echo "Configuring: BananaPi M3"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim4zero)
		echo "Configuring: BananaPi M4 Zero"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim5)
		echo "Configuring: BananaPi M5"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim7)
		echo "Configuring: BananaPi M7"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapim64)
		echo "Configuring: BananaPi M64"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapipro)
		echo "Configuring: BananaPi Pro"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapir2)
		echo "Configuring: BananaPi R2"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	bananapir2pro)
		echo "Configuring: BananaPi R2 Pro"
		cp -r $include_board_determiner_directory $board_determiner_directory
		;;
	*)
		echo "Configuring: $BOARD "
		echo "Board not supported"
		;;
	esac
}

install() {
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

install_packages() {
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
	done <"$package_file"
}

git_repos() {
	echo -e "${RED}Console > ${NC}${CYAN} Cloning Git-Repoisotrys!"

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

	# If /tmp/overlay/etc exists, copy it to /etc
}

build() {
	create_dirs
	grant_permissions
	board_determiner
	apt-get update
	install "default"
	copy_overlay
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

InstallOpenMediaVault() {
	# use this routine to create a Debian based fully functional OpenMediaVault
	# image (OMV 3 on Jessie, OMV 4 with Stretch). Use of mainline kernel highly
	# recommended!
	#
	# Please note that this variant changes Armbian default security
	# policies since you end up with root password 'openmediavault' which
	# you have to change yourself later. SSH login as root has to be enabled
	# through OMV web UI first
	#
	# This routine is based on idea/code courtesy Benny Stark. For fixes,
	# discussion and feature requests please refer to
	# https://forum.armbian.com/index.php?/topic/2644-openmediavault-3x-customize-imagesh/

	echo root:openmediavault | chpasswd
	rm /root/.not_logged_in_yet
	. /etc/default/cpufrequtils
	export LANG=C LC_ALL="en_US.UTF-8"
	export DEBIAN_FRONTEND=noninteractive
	export APT_LISTCHANGES_FRONTEND=none

	case ${RELEASE} in
	jessie)
		OMV_Name="erasmus"
		OMV_EXTRAS_URL="https://github.com/OpenMediaVault-Plugin-Developers/packages/raw/master/openmediavault-omvextrasorg_latest_all3.deb"
		;;
	stretch)
		OMV_Name="arrakis"
		OMV_EXTRAS_URL="https://github.com/OpenMediaVault-Plugin-Developers/packages/raw/master/openmediavault-omvextrasorg_latest_all4.deb"
		;;
	esac

	# Add OMV source.list and Update System
	cat >/etc/apt/sources.list.d/openmediavault.list <<-EOF
		deb https://openmediavault.github.io/packages/ ${OMV_Name} main
		## Uncomment the following line to add software from the proposed repository.
		deb https://openmediavault.github.io/packages/ ${OMV_Name}-proposed main

		## This software is not part of OpenMediaVault, but is offered by third-party
		## developers as a service to OpenMediaVault users.
		# deb https://openmediavault.github.io/packages/ ${OMV_Name} partner
	EOF

	# Add OMV and OMV Plugin developer keys, add Cloudshell 2 repo for XU4
	if [ "${BOARD}" = "odroidxu4" ]; then
		add-apt-repository -y ppa:kyle1117/ppa
		sed -i 's/jessie/xenial/' /etc/apt/sources.list.d/kyle1117-ppa-jessie.list
	fi
	mount --bind /dev/null /proc/mdstat
	apt-get update
	apt-get --yes --force-yes --allow-unauthenticated install openmediavault-keyring
	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7AA630A1EDEE7D73
	apt-get update

	# install debconf-utils, postfix and OMV
	HOSTNAME="${BOARD}"
	debconf-set-selections <<<"postfix postfix/mailname string ${HOSTNAME}"
	debconf-set-selections <<<"postfix postfix/main_mailer_type string 'No configuration'"
	apt-get --yes --force-yes --allow-unauthenticated --fix-missing --no-install-recommends \
		-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
		debconf-utils postfix
	# move newaliases temporarely out of the way (see Ubuntu bug 1531299)
	cp -p /usr/bin/newaliases /usr/bin/newaliases.bak && ln -sf /bin/true /usr/bin/newaliases
	sed -i -e "s/^::1         localhost.*/::1         ${HOSTNAME} localhost ip6-localhost ip6-loopback/" \
		-e "s/^127.0.0.1   localhost.*/127.0.0.1   ${HOSTNAME} localhost/" /etc/hosts
	sed -i -e "s/^mydestination =.*/mydestination = ${HOSTNAME}, localhost.localdomain, localhost/" \
		-e "s/^myhostname =.*/myhostname = ${HOSTNAME}/" /etc/postfix/main.cf
	apt-get --yes --force-yes --allow-unauthenticated --fix-missing --no-install-recommends \
		-o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install \
		openmediavault

	# install OMV extras, enable folder2ram and tweak some settings
	FILE=$(mktemp)
	wget "$OMV_EXTRAS_URL" -qO $FILE && dpkg -i $FILE

	/usr/sbin/omv-update
	# Install flashmemory plugin and netatalk by default, use nice logo for the latter,
	# tweak some OMV settings
	. /usr/share/openmediavault/scripts/helper-functions
	apt-get -y -q install openmediavault-netatalk openmediavault-flashmemory
	AFP_Options="mimic model = Macmini"
	SMB_Options="min receivefile size = 16384\nwrite cache size = 524288\ngetwd cache = yes\nsocket options = TCP_NODELAY IPTOS_LOWDELAY"
	xmlstarlet ed -L -u "/config/services/afp/extraoptions" -v "$(echo -e "${AFP_Options}")" /etc/openmediavault/config.xml
	xmlstarlet ed -L -u "/config/services/smb/extraoptions" -v "$(echo -e "${SMB_Options}")" /etc/openmediavault/config.xml
	xmlstarlet ed -L -u "/config/services/flashmemory/enable" -v "1" /etc/openmediavault/config.xml
	xmlstarlet ed -L -u "/config/services/ssh/enable" -v "1" /etc/openmediavault/config.xml
	xmlstarlet ed -L -u "/config/services/ssh/permitrootlogin" -v "0" /etc/openmediavault/config.xml
	xmlstarlet ed -L -u "/config/system/time/ntp/enable" -v "1" /etc/openmediavault/config.xml
	xmlstarlet ed -L -u "/config/system/time/timezone" -v "UTC" /etc/openmediavault/config.xml
	xmlstarlet ed -L -u "/config/system/network/dns/hostname" -v "${HOSTNAME}" /etc/openmediavault/config.xml
	xmlstarlet ed -L -u "/config/system/monitoring/perfstats/enable" -v "0" /etc/openmediavault/config.xml
	echo -e "OMV_CPUFREQUTILS_GOVERNOR=${GOVERNOR}" >>/etc/default/openmediavault
	echo -e "OMV_CPUFREQUTILS_MINSPEED=${MIN_SPEED}" >>/etc/default/openmediavault
	echo -e "OMV_CPUFREQUTILS_MAXSPEED=${MAX_SPEED}" >>/etc/default/openmediavault
	for i in netatalk samba flashmemory ssh ntp timezone interfaces cpufrequtils monit collectd rrdcached; do
		/usr/sbin/omv-mkconf $i
	done
	/sbin/folder2ram -enablesystemd || true
	sed -i 's|-j /var/lib/rrdcached/journal/ ||' /etc/init.d/rrdcached

	# Fix multiple sources entry on ARM with OMV4
	sed -i '/stretch-backports/d' /etc/apt/sources.list

	# rootfs resize to 7.3G max and adding omv-initsystem to firstrun -- q&d but shouldn't matter
	echo 15500000s >/root/.rootfs_resize
	sed -i '/systemctl\ disable\ armbian-firstrun/i \
	mv /usr/bin/newaliases.bak /usr/bin/newaliases \
	export DEBIAN_FRONTEND=noninteractive \
	sleep 3 \
	apt-get install -f -qq python-pip python-setuptools || exit 0 \
	pip install -U tzupdate \
	tzupdate \
	read TZ </etc/timezone \
	/usr/sbin/omv-initsystem \
	xmlstarlet ed -L -u "/config/system/time/timezone" -v "${TZ}" /etc/openmediavault/config.xml \
	/usr/sbin/omv-mkconf timezone \
	lsusb | egrep -q "0b95:1790|0b95:178a|0df6:0072" || sed -i "/ax88179_178a/d" /etc/modules' /usr/lib/armbian/armbian-firstrun
	sed -i '/systemctl\ disable\ armbian-firstrun/a \
	sleep 30 && sync && reboot' /usr/lib/armbian/armbian-firstrun

	# add USB3 Gigabit Ethernet support
	echo -e "r8152\nax88179_178a" >>/etc/modules

	# Special treatment for ODROID-XU4 (and later Amlogic S912, RK3399 and other big.LITTLE
	# based devices). Move all NAS daemons to the big cores. With ODROID-XU4 a lot
	# more tweaks are needed. CS2 repo added, CS1 workaround added, coherent_pool=1M
	# set: https://forum.odroid.com/viewtopic.php?f=146&t=26016&start=200#p197729
	# (latter not necessary any more since we fixed it upstream in Armbian)
	case ${BOARD} in
	odroidxu4)
		HMP_Fix='; taskset -c -p 4-7 $i '
		# Cloudshell stuff (fan, lcd, missing serials on 1st CS2 batch)
		echo "H4sIAKdXHVkCA7WQXWuDMBiFr+eveOe6FcbSrEIH3WihWx0rtVbUFQqCqAkYGhJn
			tF1x/vep+7oebDfh5DmHwJOzUxwzgeNIpRp9zWRegDPznya4VDlWTXXbpS58XJtD
			i7ICmFBFxDmgI6AXSLgsiUop54gnBC40rkoVA9rDG0SHHaBHPQx16GN3Zs/XqxBD
			leVMFNAz6n6zSWlEAIlhEw8p4xTyFtwBkdoJTVIJ+sz3Xa9iZEMFkXk9mQT6cGSQ
			QL+Cr8rJJSmTouuuRzfDtluarm1aLVHksgWmvanm5sbfOmY3JEztWu5tV9bCXn4S
			HB8RIzjoUbGvFvPw/tmr0UMr6bWSBupVrulY2xp9T1bruWnVga7DdAqYFgkuCd3j
			vORUDQgej9HPJxmDDv+3WxblBSuYFH8oiNpHz8XvPIkU9B3JVCJ/awIAAA==" |
			tr -d '[:blank:]' | base64 --decode | gunzip -c >/usr/local/sbin/cloudshell2-support.sh
		chmod 755 /usr/local/sbin/cloudshell2-support.sh
		apt install -y i2c-tools odroid-cloudshell cloudshell2-fan
		sed -i '/systemctl\ disable\ armbian-firstrun/i \
			lsusb | grep -q -i "05e3:0735" && sed -i "/exit\ 0/i echo 20 > /sys/class/block/sda/queue/max_sectors_kb" /etc/rc.local \
			/usr/sbin/i2cdetect -y 1 | grep -q "60: 60" && /usr/local/sbin/cloudshell2-support.sh' /usr/lib/armbian/armbian-firstrun
		;;
	bananapim3)
		HMP_Fix='; taskset -c -p 4-7 $i '
		;;
	edge* | ficus | firefly-rk3399 | nanopct4 | nanopim4 | nanopineo4 | renegade-elite | roc-rk3399-pc | rockpro64 | station-p1)
		HMP_Fix='; taskset -c -p 4-5 $i '
		;;
	esac
	echo "* * * * * root for i in \`pgrep \"ftpd|nfsiod|smbd|afpd|cnid\"\` ; do ionice -c1 -p \$i ${HMP_Fix}; done >/dev/null 2>&1" \
		>/etc/cron.d/make_nas_processes_faster
	chmod 600 /etc/cron.d/make_nas_processes_faster

	# add SATA port multiplier hint if appropriate
	[ "${LINUXFAMILY}" = "sunxi" ] &&
		echo -e "#\n# If you want to use a SATA PM add \"ahci_sunxi.enable_pmp=1\" to bootargs above" \
			>>/boot/boot.cmd

	# Filter out some log messages
	echo ':msg, contains, "do ionice -c1" ~' >/etc/rsyslog.d/omv-armbian.conf
	echo ':msg, contains, "action " ~' >>/etc/rsyslog.d/omv-armbian.conf
	echo ':msg, contains, "netsnmp_assert" ~' >>/etc/rsyslog.d/omv-armbian.conf
	echo ':msg, contains, "Failed to initiate sched scan" ~' >>/etc/rsyslog.d/omv-armbian.conf

	# Fix little python bug upstream Debian 9 obviously ignores
	if [ -f /usr/lib/python3.5/weakref.py ]; then
		wget -O /usr/lib/python3.5/weakref.py \
			https://raw.githubusercontent.com/python/cpython/9cd7e17640a49635d1c1f8c2989578a8fc2c1de6/Lib/weakref.py
	fi

	# clean up and force password change on first boot
	umount /proc/mdstat
	chage -d 0 root
} # InstallOpenMediaVault

UnattendedStorageBenchmark() {
	# Function to create Armbian images ready for unattended storage performance testing.
	# Useful to use the same OS image with a bunch of different SD cards or eMMC modules
	# to test for performance differences without wasting too much time.

	rm /root/.not_logged_in_yet

	apt-get -qq install time

	wget -qO /usr/local/bin/sd-card-bench.sh https://raw.githubusercontent.com/ThomasKaiser/sbc-bench/master/sd-card-bench.sh
	chmod 755 /usr/local/bin/sd-card-bench.sh

	sed -i '/^exit\ 0$/i \
	/usr/local/bin/sd-card-bench.sh &' /etc/rc.local
} # UnattendedStorageBenchmark

InstallAdvancedDesktop() {
	apt-get install -yy transmission libreoffice libreoffice-style-tango meld remmina thunderbird kazam avahi-daemon
	[[ -f /usr/share/doc/avahi-daemon/examples/sftp-ssh.service ]] && cp /usr/share/doc/avahi-daemon/examples/sftp-ssh.service /etc/avahi/services/
	[[ -f /usr/share/doc/avahi-daemon/examples/ssh.service ]] && cp /usr/share/doc/avahi-daemon/examples/ssh.service /etc/avahi/services/
	apt clean
} # InstallAdvancedDesktop

Main "$@"
