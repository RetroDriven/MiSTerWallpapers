# IMPORTANT NOTE

## Scripts End Of Life(January 2021) 

The Good News: My Family will be growing by one more with a new Baby on the way soon! 

The Bad News: Come January my Scripts will go EOL.

TLDR:New Baby,Not enough time,I will be back at some point

Full Details Below:

<a href="https://www.patreon.com/posts/scripts-end-of-44945379">https://www.patreon.com/posts/scripts-end-of-44945379</a>

# MiSTerWallpapers
The purpose of this Script to to aid in Downloading the Amazing Collection of MiSTer Menu Wallpapers that Ranny Snice is creating for us all.

# Updater Script Download

<a href="http://retrodriven-nextcloud.cloud.seedboxes.cc/s/MiSTerWallpapers_Updater/download"> Script Updater Download </a>

## Script Usage ##
* Download the ZIP file above and Extract/Copy <b>Update_MiSTerWallpapers.sh</b> and <b>Update_MiSTerWallpapers.ini</b> to your Scripts Folder on your MiSTer SD Card(/media/fat/Scripts)
* Simply run <b>Update_MiSTerWallpapers.sh</b> via MiSTer Scripts Menu to Download/Update the Wallpapers Collection
* Optional: Changing the <b>Update_MiSTerWallpapers.ini</b> file is optional based on your setup/needs

## Changing Menu Backgrounds via Managed Mode ##
* Change the INI option SELF_MANAGED="False" to SELF_MANAGED="True"
* Copy any/all Wallpapers that you' like from /wallpapers/snice to the root /wallpapers folder
* Doing so will Randomly select a Wallpaper image to display
* NOTE: You may need to Press F1 to use the Wallpaper Image
* NOTE: If you have menu.jpg or menu.png in the root of your SD Card the Wallpapers will not work
* NOTE: This Script will move the files above into /wallpapers for you automatically to avoid this issue

## Wallpaper Blacklist ##
* You can add Wallpapers that you do not want to Download to a Blacklist
* Open the <b>Update_MiSTerWallpapers.ini</b> file and add in the Case Sensitive Filename Keywords
* NOTE: The list is separated by space so only use part of the word if it's more than one word
* NOTE: The Script will not Delete the Blacklisted Wallpapers if you have already Downloaded before adding them to the Blacklist. Once they manually deleted and Blacklisted they wil not be downloaded going forward

* EXAMPLE: BLACKLIST="Powerpuff Bowsette Vampire"

## Credits ##
* <a href="https://twitter.com/RannySnice" target="_blank">Ranny Snice</a>
* <a href="https://github.com/MiSTer-devel/Main_MiSTer/wiki" target="_blank">Sorgelig</a>

## Contributions ##
* Please reach out to me via GitHub or Twitter if you'd like to add your MiSTer Wallpapers for the Script to download
