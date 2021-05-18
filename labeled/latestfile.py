import glob, os
list_of_files = glob.glob('/home/pi/labeled/*.jpg')
latest_file = max(list_of_files, key=os.path.getctime)
f = open("latestfile.sh", "w")
f.write("echo " + latest_file)
f.close()
