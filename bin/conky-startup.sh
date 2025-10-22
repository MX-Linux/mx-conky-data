#!/bin/bash
#Launch default MX Conky script unless otherwise configured 

#check for presence of desktop autostart file
#or if autostart is disabled in existing file


#launch HOME configured conky, if it exists
#check for existence, because conky-manager does not make executable files
#start with sh for compatibility
if [ -f "$HOME/.conky/conky-startup.sh" ]; then
	sh "$HOME/.conky/conky-startup.sh"
	exit 0
fi

#special first boot stuff
if [ "$XDG_CURRENT_DESKTOP" = "XFCE" ]; then
	while ! pidof xfdesktop >>/dev/null;
		do
			sleep 1
		done
fi

if [ ! -e "$HOME/.cache/fontconfig" ] && [ -d /usr/share/fonts/extra ]; then
	fc-cache -r /usr/share/fonts/extra
fi

#ok we finally launch default conky if nothing all checks are passed
sleep 20
killall conky
cd "/usr/share/mx-conky-data/themes/MX-Infinity"
conky -c "/usr/share/mx-conky-data/themes/MX-Infinity/MX-Infinity-conkyrc" &
exit 0
