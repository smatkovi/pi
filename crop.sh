read -p "optionally enter new label, else just press enter: "  newlabel
if  [ -z "$newlabel" ]; then
        echo "no new label"
else
        echo echo $newlabel>barcode.sh
fi
PS3="Choose cropping: "
options=(100\% 75\% 50\% 25\%)
select menu in "${options[@]}";
do
	echo -e "\nyou picked $menu ($REPLY)"
	if  [ -z "$REPLY" ]; then
		echo sudo convert -undercolor black -pointsize 200 -fill white -draw $QUOTE$TXT 270,3256 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) labeled/$(./barcode.sh)$JPG>conv.sh
		break;
	fi
	if [[ $menu == "100%" ]]; then
		echo sudo convert -undercolor black -pointsize 200 -fill white -draw $QUOTE$TXT 270,3256 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) labeled/$(./barcode.sh)$JPG>conv.sh&&/home/pi/conv.sh
		#echo to show image again press l
        	#timeout 5 bash /home/pi/scanforl.sh
		break;
	fi
	if [[ $menu == "75%" ]]; then
		convert -undercolor \black $(./latestfile.sh) -gravity Center -crop 75x75%+0+0 $(./latestfile.sh)
		echo sudo convert -undercolor black -pointsize 150 -fill white -draw $QUOTE$TXT 203,2442 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) labeled/$(./barcode.sh)$JPG>conv.sh&&/home/pi/conv.sh&&python labeled/latestfile.py&&timeout 10 feh -F $(./labeled/latestfile.sh)&&rm -rf *.jpg
		break;
	fi
	if [[ $menu == "50%" ]]; then
		convert -undercolor \black $(./latestfile.sh) -gravity Center -crop 50x50%+0+0 $(./latestfile.sh)
		echo sudo convert -undercolor black -pointsize 100 -fill white -draw $QUOTE$TXT 135,1628 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) labeled/$(./barcode.sh)$JPG>conv.sh&&/home/pi/conv.sh&&python /labeled/latestfile.py&&timeout 10 feh -F $(./labeled/latestfile.sh)&&rm -rf *.jpg
		break;
	fi
	if [[ $menu == "25%" ]]; then
		convert -undercolor \black $(./latestfile.sh) -gravity Center -crop 25x25%+0+0 $(./latestfile.sh)
		echo sudo convert -undercolor black -pointsize 50 -fill white -draw $QUOTE$TXT 68,814 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) labeled/$(./barcode.sh)$JPG>conv.sh&&/home/pi/conv.sh&&python labeled/latestfile.py&&timeout 10 feh -F $(./labeled/latestfile.sh)&&rm -rf *.jpg
		break;
	fi
done
