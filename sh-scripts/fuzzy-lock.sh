#!/bin/bash

if pgrep i3lock > /dev/null
then
	echo "Already running"
	exit
fi

if pgrep stepmania > /dev/null
then
	echo "Stepmania running"
	# xset s off -dpms # don't blank screen if stepmania is running
	exit
fi

REVIVE_WORKRAVE=false;
if pgrep workrave > /dev/null
then
	REVIVE_WORKRAVE=true;
	killall workrave
fi

# mute microphone so I'm not recorded while afk
ponymix -t source mute

# Take a screenshot
scrot --overwrite /tmp/screen_locked.png

# mogrify -scale 10% -scale 1000% /tmp/screen_locked.png
mogrify -blur 3x4 +level 35% -brightness-contrast -30x0 /tmp/screen_locked.png

xset s 20 20

# Lock screen displaying this image.
i3lock \
	--beep \
	--ignore-empty-password \
	--show-failed-attempts \
	--nofork \
	--pointer=win \
	--image=/tmp/screen_locked.png

# i3lock -n -f -b -e -p win -i /home/evan/Dropbox/Photos/Pictures/backgrounds/sans-papyrus.png -t

xset s 600 600

if [ "$HOSTNAME" = ArchMajestic ]; then
	~/dotfiles/sh-scripts/paswitch.sh speakers
fi
if [ "$HOSTNAME" = Endor ]; then
	~/dotfiles/sh-scripts/paswitch.sh speakers
fi

if $REVIVE_WORKRAVE;
then
	sleep 0.5
	workrave &
	dbus-send --print-reply \
		--dest=org.workrave.WorkraveApplication \
		/org/workrave/Workrave/Core \
		org.workrave.CoreInterface.SetOperationMode \
		string:'normal'
fi
