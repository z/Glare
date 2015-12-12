#!/bin/sh
if [ ! -t 0 ]; then
	x-terminal-emulator -e "$0"
	exit 0
fi
basedir="$(dirname "$(readlink -f "${0}")")"
cd "$basedir"
if [ ! -f x-changecolor.sh ]; then
	exit 1
fi

###things we need here
type convert >/dev/null 2>&1 || {
	echo >&2 "I require ImageMagick(convert) but it's not installed. Aborting."
	_missing_dep=1
}
type composite >/dev/null 2>&1 || {
	echo >&2 "I require ImageMagick(composite) but it's not installed. Aborting."
	_missing_dep=1
}
type sed >/dev/null 2>&1 || { 
	echo >&2 "I require GNUsed but it's not installed. Aborting."
	_missing_dep=1
}
type bc >/dev/null 2>&1 || {
	echo >&2 "I require bc but it's not installed. Aborting."
	_missing_dep=1
}
type tr >/dev/null 2>&1 || {
	echo >&2 "I require tr but it's not installed. Aborting."
	_missing_dep=1
}
type 7z >/dev/null 2>&1 || {
	echo >&2 "I require p7zip(7z) but it's not installed. Aborting."
	_missing_dep=1
}
type make >/dev/null 2>&1 || {
	echo >&2 "I require make but it's not installed. Aborting."
	_missing_dep=1
}
if [ "$_missing_dep" = "1" ]; then
	sleep 5
	exit 1
fi

###set the color
if type yad >/dev/null 2>&1; then
	newcolor=$(yad --color --init-color=#407dec --title="Please select a new #RRGGBB hilight color")
elif type qarma >/dev/null 2>&1; then
	newcolor=$(qarma --color-selection --color=#407dec --title="Please select a new #RRGGBB hilight color")
else
	read -p "Please enter your new hilight color in #RRGGBB(The '#' is a must!, #407dec is currently set): " newcolor
fi
if [ "$newcolor" = "" ]; then
	printf "no color was was selected, aborting!"
	exit 1
fi
###some fail colors(colors already used by theme)
if [ "$newcolor" = "#ff00ff" ]; then
	printf "this color is not available, aborting!"
	exit 1
fi
if [ "$newcolor" = "#ffffff" ]; then
	printf "this color is not available, aborting!"
	exit 1
fi
if [ "$newcolor" = "#ec4040" ]; then
	printf "this color is not available, aborting!"
	exit 1
fi

###convert hex to rgb
newcolorhexup=$(echo "$newcolor"|sed 's/#//'|tr '[:lower:]' '[:upper:]')
rhexup=$(echo $newcolorhexup|cut -c-2)
ghexup=$(echo $newcolorhexup|cut -c3-4)
bhexup=$(echo $newcolorhexup|cut -c5-6)
r=$(echo "ibase=16; $rhexup"|bc)
g=$(echo "ibase=16; $ghexup"|bc)
b=$(echo "ibase=16; $bhexup"|bc)
newcolorrgb="$r,$g,$b"
####create a darker new color
wardark=$(expr $r - 33)
wagdark=$(expr $g - 21)
wabdark=$(expr $b - 0)
#####no negative numbers
if [ "$wardark" -lt "0" ]; then
	wardark=$(expr $wardark - $wardark)
fi
if [ "$wagdark" -lt "0" ]; then
	wagdark=$(expr $wagdark - $wagdark)
fi
if [ "$wabdark" -lt "0" ]; then
	wabdark=$(expr $wabdark - $wabdark)
fi
warhexdark=$(echo "obase=16; $wardark"|bc)
waghexdark=$(echo "obase=16; $wagdark"|bc)
wabhexdark=$(echo "obase=16; $wabdark"|bc)
#####make sure hex is 2 bin digits
if [ ${#warhexdark} -lt 2 ]; then
wagrexdark="$warhexdark$warhexdark"
fi
if [ ${#waghexdark} -lt 2 ]; then
waghexdark="$waghexdark$waghexdark"
fi
if [ ${#wabhexdark} -lt 2 ]; then
wabhexdark="$wabhexdark$wabhexdark"
fi
#add the number sign
newcolordarkhex="#${warhexdark}${waghexdark}${wabhexdark}"

###recolor the xfwm/ui themes
_folders="xfwm4 GlareYang GlareYin xfce-notify-4.0 balou"
for _folder in $_folders; do
	cd $_folder
	find "$basedir/$_folder" -type f -exec sed -i 's/#407dec/'$newcolor'/g' {} \;
	find "$basedir/$_folder" -type f -exec sed -i 's/64,125,236/'$newcolorrgb'/g' {} \;
	find "$basedir/$_folder" -type f -name '*.png' -exec convert {} -define png:format=png32 -fill "$newcolor" -opaque "#407dec" {} \;
	cd $basedir
done

### EXTRAS ###
cd EXTRAS
###config files
find "ConfigFiles" -type f -exec sed -i 's/#407dec/'$newcolor'/g' {} \;
find "ConfigFiles" -type f -exec sed -i 's/64,125,236/'$newcolorrgb'/g' {} \;
###Old WM themes
find "WinDecos" -type f -exec sed -i 's/#407dec/'$newcolor'/g' {} \;
find "WinDecos" -type f -exec sed -i 's/64,125,236/'$newcolorrgb'/g' {} \;
find "WinDecos" -type f -name '*active.png' -not -name "*inactive.png" -not -path "*cupertino*" -exec convert {} -define png:format=png32 -fill "$newcolor" -opaque "#407dec" {} \;
###Mozilla
cd PaleMoonFixes
cd Glare
make clean
make
cd ../..
###Winamp Skin
cd Winamp2.xSkin

_folders="Glare Glare-qmmp"
for _folder in $_folders; do
	cd $_folder
	find "$basedir/EXTRAS/Winamp2.xSkin/$_folder" -type f -exec sed -i 's/#407dec/'$newcolor'/g' {} \;
	find "$basedir/EXTRAS/Winamp2.xSkin/$_folder" -type f -exec sed -i 's/64,125,236/'$newcolorrgb'/g' {} \;
	find "$basedir/EXTRAS/Winamp2.xSkin/$_folder" -type f -exec sed -i 's/31,104,236/'$wardark,$wagdark,$wabdark'/g' {} \;
	find "$basedir/EXTRAS/Winamp2.xSkin/$_folder" -type f -name '*.png' -exec convert {} -define png:format=png32 -fill "$newcolor" -opaque "#407dec" {} \;
	find "$basedir/EXTRAS/Winamp2.xSkin/$_folder" -type f -name '*.png' -exec convert {} -define png:format=png32 -fill "$newcolordarkhex" -opaque "#2c55a1" {} \;
	make clean
	make
	cd ..
done
cd ..

####create a colored wallpaper in the current resolution for feh, nitrogen & co
cd $basedir
if type xrandr >/dev/null 2>&1; then
	desktopres=$(xrandr|grep '*'|awk '{print $1}')
elif type xdpyinfo >/dev/null 2>&1; then
	desktopres=$(xdpyinfo|grep 'dimensions:'|awk '{print $2}')
else
	#if we fail create a big fat wp
	desktopres="4096x2160"
fi
convert -size $desktopres gradient:$newcolordarkhex-$newcolor /tmp/glarewpgradient.png
composite -tile EXTRAS/Wallpapers/Patterns/Glare_lines_trans.png /tmp/glarewpgradient.png EXTRAS/Wallpapers/Fixed/Glare_colorlines.png

###modify this script, too
sed -i 's/#407dec/'$newcolor'/g' x-changecolor.sh
sed -i 's/64,125,236/'$newcolorrgb'/g' x-changecolor.sh
sed -i 's/2c55a1/'$newcolordarkhex'/g' x-changecolor.sh

printf "\n\ndone\n\n"
sleep 3

###########very old stuff just keep this here until a opebox theme comes back
####recolor the openbox theme
#rdark=$(expr $r - 30)
#gdark=$(expr $g - 30)
#bdark=$(expr $b - 30)
#if [ "$rdark" -lt "0" ]; then
	#rdark=$(expr $rdark - $rdark)
#fi
#if [ "$gdark" -lt "0" ]; then
	#gdark=$(expr $gdark - $gdark)
#fi
#if [ "$bdark" -lt "0" ]; then
	#bdark=$(expr $bdark - $bdark)
#fi
#rhexdark=$(echo "obase=16; $rdark"|bc)
#ghexdark=$(echo "obase=16; $gdark"|bc)
#bhexdark=$(echo "obase=16; $bdark"|bc)
#find "$basedir" -type f -name "themerc" -exec sed -i "s#rgb:40/7d/ec#rgb:$rhexup\/$ghexup\/$bhexup#g" {} \;
#find "$basedir" -type f -name "themerc" -exec sed -i "s#rgb:32/62/b9#rgb:$rhexdark\/$ghexdark\/$bhexdark#g" {} \;
