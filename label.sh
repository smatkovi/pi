while true
do
	python3 /home/pi/scan.py&&timeout 10 feh -F $(./latestfile.sh)&&/home/pi/crop.sh&&/home/pi/conv.sh&&rm -f /home/pi/*.cr2&&python labeled/latestfile.py&&timeout 10 feh -F $(./latestfile.sh)&&rm -rf *.jpg
done
