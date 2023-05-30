#!/bin/bash

# Copyright (c) 2023 LaRoccx LLC <http://www.laroccx.com>

script_version='2.7.8'
script_release='release' # options devel, beta, release

# Require root privileges
require_root_privileges() {
	if [ "$UID" != "0" ]; then
		# logger -i "Error: $(basename "$0") must be run as root!"
		echo "Error: $(basename "$0") must be run as root!"
		exit 1
	fi
}

install_packages() {
	echo 'Managing packages...'
	rm -f /etc/apt/sources.list.d/*dell*
	apt clean
	apt autoclean
	apt update
	apt --yes upgrade
	apt --yes full-upgrade
	apt --yes install \
		byobu \
		dnsutils \
		git \
		htop \
		net-tools \
		smbclient \
		tasksel \
	snap refresh
	fwupdmgr --force refresh
	fwupdmgr update
}

hide_applications() {
	echo 'Hiding applications...'
	for desktop_file in \
		/usr/share/applications/byobu.desktop \
		/usr/share/applications/gnome-language-selector.desktop \
		/usr/share/applications/htop.desktop \
		/usr/share/applications/icedtea-netx-javaws.desktop \
		/usr/share/applications/im-config.desktop \
		/usr/share/applications/info.desktop \
		/usr/share/applications/itweb-settings.desktop \
		/usr/share/applications/mutt.desktop \
		/usr/share/applications/nm-connection-editor.desktop \
		/usr/share/applications/org.gnome.Software.desktop \
		/usr/share/applications/software-properties-drivers.desktop \
		/usr/share/applications/software-properties-gtk.desktop \
		/usr/share/applications/sonicwall-netextender.desktop \
		/usr/share/applications/update-manager.desktop \
		/usr/share/applications/via.desktop \
		/usr/share/applications/vim.desktop \
		/usr/share/applications/vmware-netcfg.desktop \
		/usr/share/applications/vmware-player.desktop \
		/var/lib/snapd/desktop/applications/powershell_powershell.desktop; do
		if [[ "$(grep --count NoDisplay=true $desktop_file 2>/dev/null)" == "0" ]]; then
			echo 'NoDisplay=true' >>$desktop_file
			echo "$(basename $desktop_file) is now hidden."
		fi
	done
}

rename_applications() {
	echo 'Renaming applications...'
	sed -E -i s/'Name=AisleRiot Solitaire'/'Name=Solitaire'/g /usr/share/applications/sol.desktop
	sed -E -i s/'Name=Cheese'/'Name=Webcam'/g /usr/share/applications/org.gnome.Cheese.desktop
	sed -E -i s/'Name=Chromium Web Browser'/'Name=Chromium'/g /var/lib/snapd/desktop/applications/chromium_chromium.desktop
	sed -E -i s/'Name=Disk Usage Analyzer'/'Name=Disk Usage'/g /usr/share/applications/org.gnome.baobab.desktop
	sed -E -i s/'Name=Disks'/'Name=Disk Utility'/g /usr/share/applications/org.gnome.DiskUtility.desktop
	sed -E -i s/'Name=Document Viewer'/'Name=Preview'/g /usr/share/applications/org.gnome.Evince.desktop
	sed -E -i s/'Name=Empathy'/'Name=Messages'/g /usr/share/applications/empathy.desktop
	sed -E -i s/'Name=Evolution'/'Name=Mail'/g /usr/share/applications/org.gnome.Evolution.desktop
	sed -E -i s/'Name=Geary'/'Name=Mail'/g /usr/share/applications/org.gnome.Geary.desktop
	sed -E -i s/'Name=Google Chrome'/'Name=Chrome'/g /usr/share/applications/google-chrome.desktop
	sed -E -i s/'Name=LibreOffice Base'/'Name=Base'/g /usr/share/applications/libreoffice-base.desktop
	sed -E -i s/'Name=LibreOffice Calc'/'Name=Calc'/g /usr/share/applications/libreoffice-calc.desktop
	sed -E -i s/'Name=LibreOffice Draw'/'Name=Draw'/g /usr/share/applications/libreoffice-draw.desktop
	sed -E -i s/'Name=LibreOffice Impress'/'Name=Impress'/g /usr/share/applications/libreoffice-impress.desktop
	sed -E -i s/'Name=LibreOffice Math'/'Name=Math'/g /usr/share/applications/libreoffice-math.desktop
	sed -E -i s/'Name=LibreOffice Writer'/'Name=Writer'/g /usr/share/applications/libreoffice-writer.desktop
	sed -E -i s/'Name=Microsoft Teams - Preview'/'Name=Teams'/g /usr/share/applications/teams.desktop
	sed -E -i s/'Name=Passwords and Keys'/'Name=Keyring'/g /usr/share/applications/org.gnome.seahorse.Application.desktop
	sed -E -i s/'Name=Polari'/'Name=Internet Chat'/g /usr/share/applications/org.gnome.Polari.desktop
	sed -E -i s/'Name=Power Statistics'/'Name=Power Stats'/g /usr/share/applications/org.gnome.PowerStats.desktop
	sed -E -i s/'Name=Rhythmbox'/'Name=Music'/g /usr/share/applications/rhythmbox.desktop
	sed -E -i s/'Name=Startup Applications'/'Name=Startup Apps'/g /usr/share/applications/gnome-session-properties.desktop
	sed -E -i s/'Name=Ubuntu Software'/'Name=Software'/g /usr/share/applications/org.gnome.Software.desktop
	sed -E -i s/'Name=Ubuntu Software'/'Name=Software'/g /var/lib/snapd/desktop/applications/snap-store_ubuntu-software.desktop
	sed -E -i s/'Name=Visual Studio Code'/'Name=Code'/g /usr/share/applications/code.desktop
	sed -E -i s/'Name=VMware Workstation'/'Name=Workstation'/g /usr/share/applications/vmware-workstation.desktop
	sed -E -i s/'Name=Web'/'Name=Browser'/g /usr/share/applications/org.gnome.Epiphany.desktop
}

icon_applications() {
	echo 'Changing application icons...'
	sed -E -i s/'^Icon=.*'/'Icon=org.gnome.gedit'/g /usr/share/applications/code.desktop
	# sed -E -i s_'^Icon=.*'_'Icon=/usr/share/icons/custom/code.svg'_g /usr/share/applications/code.desktop
	sed -E -i s_'^Icon=.*'_'Icon=/usr/share/icons/custom/sublime-text.svg'_g /usr/share/applications/sublime_text.desktop
	sed -E -i s/'^Icon=.*'/'Icon=cheese'/g /usr/share/applications/teams.desktop
	sed -E -i s/'^Icon=.*'/'Icon=games-app'/g /usr/share/applications/org.gnome.Games.desktop
	sed -E -i s/'^Icon=.*'/'Icon=gnome-books'/g /usr/share/applications/org.gnome.Books.desktop
	sed -E -i s/'^Icon=.*'/'Icon=internet-chat'/g /usr/share/applications/org.gnome.Polari.desktop
	sed -E -i s/'^Icon=.*'/'Icon=jockey'/g /usr/share/applications/vmware-player.desktop
	sed -E -i s/'^Icon=.*'/'Icon=jockey'/g /usr/share/applications/vmware-workstation.desktop
	sed -E -i s/'^Icon=.*'/'Icon=mail-app'/g /usr/share/applications/org.gnome.Geary.desktop
	sed -E -i s/'^Icon=.*'/'Icon=messaging-app'/g /usr/share/applications/element-desktop.desktop
	sed -E -i s/'^Icon=.*'/'Icon=messaging-app'/g /var/lib/snapd/desktop/applications/fractal_fractal.desktop
	sed -E -i s/'^Icon=.*'/'Icon=software-store'/g /usr/share/applications/org.gnome.Software.desktop
	sed -E -i s/'^Icon=.*'/'Icon=software-store'/g /var/lib/snapd/desktop/applications/snap-store_ubuntu-software.desktop
	sed -E -i s/'^Icon=.*'/'Icon=web-browser'/g /usr/share/applications/google-chrome.desktop
	sed -E -i s/'^Icon=.*'/'Icon=web-browser'/g /var/lib/snapd/desktop/applications/chromium_chromium.desktop
}

add_startup_wmclass() {
	echo 'Changing window settings...'
	sed -i '/^StartupNotify=.*/a StartupWMClass=Microsoft Teams - Preview' /usr/share/applications/teams.desktop
	sed -i '/^StartupNotify=.*/a StartupWMClass=vmplayer' /usr/share/applications/vmware-player.desktop
	sed -i '/^StartupNotify=.*/a StartupWMClass=vmware-netcfg' /usr/share/applications/vmware-netcfg.desktop
	sed -i '/^StartupNotify=.*/a StartupWMClass=vmware' /usr/share/applications/vmware-workstation.desktop
}

edit_startup_wmclass() {
	nano /usr/share/applications/teams.desktop
	nano /usr/share/applications/vmware-netcfg.desktop
	nano /usr/share/applications/vmware-player.desktop
	nano /usr/share/applications/vmware-workstation.desktop
}

edit_gsettings() {
	echo 'Changing gnome theme...'
	gsettings set org.gnome.desktop.interface gtk-theme 'Yaru-dark'
}

require_system_restart() {
	touch /var/run/reboot-required
	echo && read -p "Do you want to restart? [Y/n] " user_input_selection && echo
	case "$user_input_selection" in
	[Yy] | [Yy][Ee][Ss])
		shutdown --reboot now
		;;
	[Ss] | [Ss][Hh][Uu][Tt][Dd][Oo][Ww][Nn])
		shutdown --poweroff +1 'Initiated by $(basename -s .sh $0)'
		;;
	*)
		echo '*** System restart required ***' 1>&2
		exit 0
		;;
	esac
}

display_help_message() {
	cat <<-EOF_XYZ
		Usage: $(basename -s .sh $0) [OPTION]...
		Personalize Ubuntu with custom settings, icons, packages

		The following options and long options are understood:
		 -a, --all      All personalzation tasks
		 -d, --devel    Add 'StartupWMClass' to select applications
		 -h, --hide     Hide select applications
		 -i, --install  Install additional software packages
		 -m, --modify   Modify application settings using the default
		                  editor includs name, icon and gsettings
		 -H, --help     Display this help information
		 -V, --version  Display the version information

		Copyright:
		 Copyright (c) 2019-$(date +%Y) Robert LaRocca http://www.laroccx.com
		 License: The MIT License (MIT)
		 Source Code: https://github.com/robertlarocca/personalize-ubuntu-desktop
	EOF_XYZ
}

display_version_info() {
	cat <<-EOF_XYZ
		System: $(lsb_release -ds)
		Desktop: $(gnome-shell --version)
		Kernel: Linux $(uname -r)
		Shell: Bash $BASH_VERSION

		$(basename -s .sh $0) $script_version-$script_release
		Copyright (c) 2019-$(date +%Y) Robert LaRocca http://www.laroccx.com
		License: The MIT License (MIT)
		Source Code: https://github.com/robertlarocca/personalize-ubuntu-desktop
	EOF_XYZ
}

main() {
	case "$1" in
	-a | --all)
		require_root_privileges
		install_packages
		hide_applications
		rename_applications 2>/dev/null
		icon_applications 2>/dev/null
		add_startup_wmclass
		edit_startup_wmclass
		edit_gsettings
		require_system_restart
		;;
	-d | --devel)
		require_root_privileges
		add_startup_wmclass
		edit_startup_wmclass
		require_system_restart
		;;
	-D | --dpkg)
		require_root_privileges
		hide_applications
		rename_applications 2>/dev/null
		icon_applications 2>/dev/null
		exit 0
		;;
	-h | --hide)
		require_root_privileges
		hide_applications
		require_system_restart
		;;
	-i | --install)
		require_root_privileges
		install_packages
		require_system_restart
		;;
	-m | --modify)
		require_root_privileges
		rename_applications 2>/dev/null
		icon_applications 2>/dev/null
		edit_gsettings
		require_system_restart
		;;
	-H | --help)
		display_help_message
		exit 0
		;;
	-V | --version)
		display_version_info
		exit 0
		;;
	*)
		if [ ! -z "$1" ]; then
			echo "$(basename $0): invalid option '$1'"
			echo "Type '$(basename $0) --help' for a list of available options."
		else
			require_root_privileges
			hide_applications
			rename_applications 2>/dev/null
			icon_applications 2>/dev/null
			edit_gsettings
			require_system_restart
		fi
		;;
	esac
}

main "$1"

# vi: syntax=sh ts=4 noexpandtab
