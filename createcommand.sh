echo sudo convert -pointsize 200 -fill yellow -draw $QUOTE$TXT 270,3256 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) labeled/$(./barcode.sh)$JPG>conv.sh
