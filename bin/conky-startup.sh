#!/bin/bash
#Launch default MX Conky script unless otherwise configured 

#check for presence of desktop autostart file
#or if autostart is disabled in existing file

if [ -e "$HOME/.config/autostart/conky.desktop" ]; then
	if [ "$(grep Hidden $HOME/.config/autostart/conky.desktop)" = "Hidden=true" ]; then
		#autostart disabled, exit
		exit 0
	fi
else
	#file missing, also exit
		exit 0
fi

#launch HOME configured conky, if it exists
if [ -x "$HOME/.conky/conky-startup.sh" ]; then
	"$HOME/.conky/conky-startup.sh"
	exit 0
fi

#special first boot stuff
if [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
	while ! pidof xfdesktop >>/dev/null;
		do
			sleep 1
		done
fi

if [ ! -e "$HOME/.cache/fontconfig" ]; then
	fc-cache -r /usr/share/fonts/extra
fi

#ok we finally launch default conky if nothing all checks are passed
sleep 20
killall conky
cd "/usr/share/mx-conky-data/themes/MX-CowonMildBlue"
conky -c "/usr/share/mx-conky-data/themes/MX-CowonMildBlue/MX-Cowon_MildBlue" &
exit 0
