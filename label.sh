while true
do
	python3 /home/pi/scan.py
	./maketemp.sh
	/home/pi/crop.sh&&rm -f /home/pi/*.cr2&&sudo rsync -avz --exclude='tempimage.jpg' --include='*.jpg' --exclude='*' labeled/ /usb/&&rm -rf *.jpg
done
