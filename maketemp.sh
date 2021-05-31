echo sudo convert -undercolor black -pointsize 200 -fill white -draw $QUOTE$TXT 270,3256 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) Image3$JPG >temp.sh
./temp.sh
sudo convert Image3.jpg -fill none -stroke red -strokewidth 25 -draw @rect.txt Image3.jpg
timeout 10 feh -F /home/pi/Image3.jpg
