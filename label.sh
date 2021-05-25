while true
do
	python3 /home/pi/scan.py&&timeout 10 feh -F $(./latestfile.sh)&&/home/pi/crop.sh&&rm -f /home/pi/*.cr2&&rm -rf *.jpg
done
