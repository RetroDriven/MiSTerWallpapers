#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Copyright 2020 - RetroDriven and Ranny Snice

# You can download the latest version of this script from:
# https://github.com/RetroDriven/MiSTerWallpapers

# v1.1 - Added BLACKLIST Option for Filtering out Wallpapers you wish to skip Downloading
# v1.0 - Initial MiSTerWallpapers Script

#=========   URL OPTIONS   =========

#Main URL
MAIN_URL="https://www.retrodriven.appboxes.co"

#Wallpapers URL
WALLPAPERS_URL="https://www.retrodriven.appboxes.co/MiSTerWallpapers/"

#=========   USER OPTIONS   =========

#Choose if you'd like to manage the Wallpapers that appear on your MiSTer Menu
#Set to "False" if you'd like your MiSTer to randomly select a Wallpaper from everything downloaded
#Set to "True" if you'd like top manually manage/copy from /wallpapers/subfolders to /wallpapers 
SELF_MANAGED="False"

#Case Sensitive Keywords to Skip Downloading Wallpapers that you do not want
#NOTE: The list is separated by space so only use part of the word if it's more than one word
#EXAMPLE: BLACKLIST="Powerpuff Bowsette Vampire"
BLACKLIST=""

#========= DO NOT CHANGE BELOW =========

TIMESTAMP=`date "+%m-%d-%Y @ %I:%M%P"`
ALLOW_INSECURE_SSL="true"
CURL_RETRY="--connect-timeout 15 --max-time 120 --retry 3 --retry-delay 5"

ORIGINAL_SCRIPT_PATH="$0"
if [ "$ORIGINAL_SCRIPT_PATH" == "bash" ]
then
	ORIGINAL_SCRIPT_PATH=$(ps | grep "^ *$PPID " | grep -o "[^ ]*$")
fi
INI_PATH=${ORIGINAL_SCRIPT_PATH%.*}.ini
if [ -f $INI_PATH ]
then
	eval "$(cat $INI_PATH | tr -d '\r')"
fi

if [ -d "${BASE_PATH}/${OLD_SCRIPTS_PATH}" ] && [ ! -d "${BASE_PATH}/${SCRIPTS_PATH}" ]
then
	mv "${BASE_PATH}/${OLD_SCRIPTS_PATH}" "${BASE_PATH}/${SCRIPTS_PATH}"
	echo "Moved"
	echo "${BASE_PATH}/${OLD_SCRIPTS_PATH}"
	echo "to"
	echo "${BASE_PATH}/${SCRIPTS_PATH}"
	echo "please relaunch the script."
	exit 3
fi

SSL_SECURITY_OPTION=""
curl $CURL_RETRY -q $MAIN_URL &>/dev/null
case $? in
	0)
		;;
	60)
		if [ "$ALLOW_INSECURE_SSL" == "true" ]
		then
			SSL_SECURITY_OPTION="--insecure"
		else
			echo "CA certificates need"
			echo "to be fixed for"
			echo "using SSL certificate"
			echo "verification."
			echo "Please fix them i.e."
			echo "using security_fixes.sh"
			exit 2
		fi
		;;
	*)
		echo "No Internet connection"
		exit 1
		;;
esac

#========= FUNCTIONS =========

#RetroDriven Updater Banner Function
RetroDriven_Banner(){
echo
echo " ----------------------------------------------------------"
echo "|                  MiSTer Wallpapers v1.1                  |"
echo "|                  powered by RetroDriven                  |"
echo " ----------------------------------------------------------"
sleep 3
}

#Download Wallpapers Function
Download_Wallpapers(){

    echo
    echo "================================================================"
    echo "                 Downloading MiSTer Wallpapers                  "
    echo "================================================================"
	sleep 1

	#Make Directories if needed
	mkdir -p "/media/fat/wallpapers"
    cd "/media/fat/wallpapers"

	#Rename and move menu.jpg/png in root
	if [ -f /media/fat/menu.jpg ]; then
		mv -f "/media/fat/menu.jpg" "/media/fat/wallpapers/menu2.jpg" 2>/dev/null
	fi

	if [ -f /media/fat/menu.png ]; then
		mv -f "/media/fat/menu.png" "/media/fat/wallpapers/menu2.png" 2>/dev/null
	fi


	#Blacklist Handling	
	if [ "$BLACKLIST" != "" ];then

		BLACKLIST_ARRAY=($BLACKLIST)
		
		FILTER=()
		for i in "${BLACKLIST_ARRAY[@]}"
				do
				:
				FILTER+=$(echo -n "--exclude-glob *$i* ")
		done
	fi

    #Wallpapers Downloading
	echo
	echo "Checking Existing MiSTer Wallpapers by $ARTIST for Updates/New Files......"
	echo
	
		if [ $SELF_MANAGED == "True" ];then
    	#Sync Files

		if [ "$BLACKLIST" != "" ];then
			lftp "$WALLPAPERS_URL" -e "mirror -p -P 25 --exclude-glob *DS_Store $FILTER --ignore-time --verbose=1 --log="$LOGS_PATH/Wallpaper_Downloads.txt"; quit"
		else
	    	lftp "$WALLPAPERS_URL" -e "mirror -p -P 25 --exclude-glob *DS_Store --ignore-time --verbose=1 --log="$LOGS_PATH/Wallpaper_Downloads.txt"; quit"	
		fi
		fi

		if [ $SELF_MANAGED != "True" ];then
    	#Sync Files
		WALLPAPERS_URL="https://www.retrodriven.appboxes.co/MiSTerWallpapers/$SUB_FOLDER/"

    	if [ "$BLACKLIST" != "" ];then
			lftp "$WALLPAPERS_URL" -e "mirror -p -P 25 --exclude-glob *DS_Store $FILTER --ignore-time --verbose=1 --log="$LOGS_PATH/Wallpaper_Downloads.txt"; quit"
		else
	    	lftp "$WALLPAPERS_URL" -e "mirror -p -P 25 --exclude-glob *DS_Store --ignore-time --verbose=1 --log="$LOGS_PATH/Wallpaper_Downloads.txt"; quit"	
		fi
		fi

	sleep 1
    clear 	
}



#Footer Function
Footer(){
clear
echo
echo "================================================================"
echo "                MiSTer Wallpapers are up to date!               "
echo "================================================================"
echo
}

#========= MAIN CODE =========

#RetroDriven Updater Banner
RetroDriven_Banner

#Create Logs Folder
LOGS_PATH="/media/fat/Scripts/.RetroDriven/Logs"
mkdir -p "$LOGS_PATH"

#SSL Handling for LFTP
if [ ! -f ~/.lftp/rc ]; then
    mount | grep "on / .*[(,]ro[,$]" -q && RO_ROOT="true"
    [ "$RO_ROOT" == "true" ] && mount / -o remount,rw
    
    mkdir -p ~/.lftp
    echo "set ssl:verify-certificate no" >> ~/.lftp/rc
    echo "set xfer:log no" >> ~/.lftp/rc

    [ "$RO_ROOT" == "true" ] && mount / -o remount,ro
fi

#Download Wallpapers
	#Ranny Snice
	ARTIST="Ranny Snice"
	SUB_FOLDER="snice"
	Download_Wallpapers $SELF_MANAGED $ARTIST $SUB_FOLDER $BLACKLIST

echo

#Display Footer
Footer
echo "Wallpapers designed and provided by: Ranny Snice"
echo
echo "Wallpaper Collection located here: /media/fat/wallpapers"

echo