%% Overleaf			
%% Software Manual and Technical Document Template	
%% 									
%% This provides an example of a software manual created in Overleaf.

\documentclass{ol-softwaremanual}

% Packages used in this example
\usepackage{graphicx}  % for including images
\usepackage{microtype} % for typographical enhancements
\usepackage{minted}    % for code listings
\usepackage{amsmath}   % for equations and mathematics
\setminted{style=friendly,fontsize=\small}
%\renewcommand{\listoflistingscaption}{List of Code Listings}
\usepackage{hyperref}  % for hyperlinks
\usepackage[a4paper,top=4.2cm,bottom=4.2cm,left=3.5cm,right=3.5cm]{geometry} % for setting page size and margins

\usepackage{listings}
\lstset{
  language=bash,
  basicstyle=\ttfamily,
  columns=fullflexible,
  frame=single,
  breaklines=true,
  postbreak=\mbox{\textcolor{red}{$\hookrightarrow$}\space},
}
% Custom macros used in this example document
%\newcommand{\doclink}[2]{\href{#1}{#2}\footnote{\url{#1}}}
\newcommand{\cs}[1]{\texttt{\textbackslash #1}}

% Frontmatter data; appears on title page
\title{photobox}
\version{1.0}
\author{sebastian matkovich}

\begin{document}

\maketitle

\tableofcontents
%\listoflistings
\newpage

\section{Introduction}
this is a photobox for creating pictures of barcode labeled parts utilizing gphoto2, imagemagick and feh to make a picture with a connected camera, triggered by scanning in a label. then the picture is displayed with 3 sizes to crop and the label in the bottom left corner. after 10 seconds or if q or [Esc] is pressed the picture is closed. then by entering a value between 1 and 4 the image can be cropped. afterwards the picture is then shown again for maximum 10 seconds and rsync is utilized to copy the new picture to a fat32 formatted usb-key mounted on /usb and then the program begins again at the beginning and waits for a new scan. 
\section{Including code samples}
running label.sh (the main executable) a python script to get the label from the scanner and saving it to a file called scan.py with following content is invoked:
\begin{minted}{python}
from evdev import InputDevice, categorize, ecodes
import glob, os
from plumbum import local
from plumbum.cmd import sudo
scancodes = {
    # Scancode: ASCIICode
    0: None, 1: u'ESC', 2: u'1', 3: u'2', 4: u'3', 5: u'4', 6: u'5', 7: u'6', 8: u'7', 9: u'8',
    10: u'9', 11: u'0', 12: u'-', 13: u'=', 14: u'BKSP', 15: u'TAB', 16: u'q', 17: u'w', 18: u'e', 19: u'r',
    20: u't', 21: u'y', 22: u'u', 23: u'i', 24: u'o', 25: u'p', 26: u'[', 27: u']', 28: u'CRLF', 29: u'LCTRL',
    30: u'a', 31: u's', 32: u'd', 33: u'f', 34: u'g', 35: u'h', 36: u'j', 37: u'k', 38: u'l', 39: u';',
    40: u'"', 41: u'`', 42: u'LSHFT', 43: u'\\', 44: u'z', 45: u'x', 46: u'c', 47: u'v', 48: u'b', 49: u'n',
    50: u'm', 51: u',', 52: u'.', 53: u'/', 54: u'RSHFT', 56: u'LALT', 57: u' ', 100: u'RALT'
}

capscodes = {
    0: None, 1: u'ESC', 2: u'!', 3: u'@', 4: u'#', 5: u'$', 6: u'%', 7: u'^', 8: u'&', 9: u'*',
    10: u'(', 11: u')', 12: u'_', 13: u'+', 14: u'BKSP', 15: u'TAB', 16: u'Q', 17: u'W', 18: u'E', 19: u'R',
    20: u'T', 21: u'Y', 22: u'U', 23: u'I', 24: u'O', 25: u'P', 26: u'{', 27: u'}', 28: u'CRLF', 29: u'LCTRL',
    30: u'A', 31: u'S', 32: u'D', 33: u'F', 34: u'G', 35: u'H', 36: u'J', 37: u'K', 38: u'L', 39: u':',
    40: u'\'', 41: u'~', 42: u'LSHFT', 43: u'|', 44: u'Z', 45: u'X', 46: u'C', 47: u'V', 48: u'B', 49: u'N',
    50: u'M', 51: u'<', 52: u'>', 53: u'?', 54: u'RSHFT', 56: u'LALT',  57: u' ', 100: u'RALT'
}

def readBarcode(devicePath):

    dev = InputDevice(devicePath)
    dev.grab() # grab provides exclusive access to the device

    x = ''
    caps = False

    for event in dev.read_loop():
        if event.type == ecodes.EV_KEY:
            data = categorize(event)  # Save the event temporarily to introspect it
            if data.scancode == 42:
                if data.keystate == 1:
                    caps = True
                if data.keystate == 0:
                    caps = False

            if data.keystate == 1:  # Down events only
                if caps:
                    key_lookup = u'{}'.format(capscodes.get(data.scancode)) or u'UNKNOWN:[{}]'.format(data.scancode)  # Lookup or return UNKNOWN:XX
                else:
                    key_lookup = u'{}'.format(scancodes.get(data.scancode)) or u'UNKNOWN:[{}]'.format(data.scancode)  # Lookup or return UNKNOWN:XX


                if (data.scancode != 42) and (data.scancode != 28):
                    x += key_lookup

                if(data.scancode == 28):
                    return(x)
print("please scan barcode, press q or [Esc] to close shown picture")
s = readBarcode("/dev/input/event0")
print("scanned")
subprocess.call(['sh', '/home/pi/capture.sh'])
list_of_files = glob.glob('/home/pi/*.jpg')
latest_file = max(list_of_files, key=os.path.getctime)
f = open("barcode.sh", "w")
f.write("echo " + s)
f.close()
f = open("latestfile.sh", "w")
f.write("echo " + latest_file)
f.close()
\end{minted}
then the following shellscript is called to display the taken picture with rectangles with the corresponding sizes of the cropping and a label, QUOTE DOUBLEQOUTE and JPG are environment variables with ', " and .jpg as content respectively, as a workaround to the problem that quotes seem to be excaped and later to prevent a whitespace between a variable filename and the fileextension:\\
\begin{lstlisting}
echo sudo convert -undercolor black -pointsize 200 -fill white -draw $QUOTE$TXT 270,3256 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) Image3$JPG >temp.sh
./temp.sh
sudo convert Image3.jpg -fill none -stroke red -strokewidth 25 -draw @rect.txt Image3.jpg
timeout 10 feh -F /home/pi/Image3.jpg
\end{lstlisting}
\\ \\
for cropping following script is envoked. by pressing 1 and enter no changes are made to the size. by pressing 2 and enter the image is cropped to 75\%, by pressing 3 the image is cropped to 50\% and by pressing 4 the image is cropped to 25\%:
\begin{lstlisting}
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
		echo sudo convert -undercolor black -pointsize 200 -fill white -draw $QUOTE$TXT 270,3256 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) labeled/$(./barcode.sh)$JPG>conv.sh&&/home/pi/conv.sh&&timeout 10 feh -F $(./labeled/latestfile.sh)
		#echo to show image again press l
        	#timeout 5 bash /home/pi/scanforl.sh
		break;
	fi
	if [[ $menu == "75%" ]]; then
		convert -undercolor \black $(./latestfile.sh) -gravity Center -crop 75x75%+0+0 $(./latestfile.sh)
		echo sudo convert -undercolor black -pointsize 150 -fill white -draw $QUOTE$TXT 203,2442 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) labeled/$(./barcode.sh)$JPG>conv.sh&&/home/pi/conv.sh&&python labeled/latestfile.py&&timeout 10 feh -F $(./labeled/latestfile.sh)
		rm -rf *.jpg
		break;
	fi
	if [[ $menu == "50%" ]]; then
		convert -undercolor \black $(./latestfile.sh) -gravity Center -crop 50x50%+0+0 $(./latestfile.sh)
		echo sudo convert -undercolor black -pointsize 100 -fill white -draw $QUOTE$TXT 135,1628 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) labeled/$(./barcode.sh)$JPG>conv.sh&&/home/pi/conv.sh&&python labeled/latestfile.py&&timeout 10 feh -F $(./labeled/latestfile.sh)
		rm -rf *.jpg
		break;
	fi
	if [[ $menu == "25%" ]]; then
		convert -undercolor \black $(./latestfile.sh) -gravity Center -crop 25x25%+0+0 $(./latestfile.sh)
		echo sudo convert -undercolor black -pointsize 50 -fill white -draw $QUOTE$TXT 68,814 $DOUBLEQUOTE$(./barcode.sh)$DOUBLEQUOTE$QUOTE $(./latestfile.sh) labeled/$(./barcode.sh)$JPG>conv.sh&&/home/pi/conv.sh&&python labeled/latestfile.py&&timeout 10 feh -F $(./labeled/latestfile.sh)
		rm -rf *.jpg
		break;
	fi
done
\end{lstlisting}
\\ \\
the following script called label.sh is responsible for launching all scripts:
\begin{lstlisting}
while true
do
	python3 /home/pi/scan.py
	./maketemp.sh
	/home/pi/crop.sh&&rm -f /home/pi/*.cr2&&sudo rsync -avz --exclude='tempimage.jpg' --include='*.jpg' --exclude='*' labeled/ /usb/&&rm -rf *.jpg
done
\end{lstlisting}




\end{document}

