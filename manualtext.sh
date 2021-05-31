read -p "optionally enter new label, else just press enter: "  newlabel
if  [ -z "$newlabel" ]; then
        echo "no new label"
else
        echo echo $newlabel>barcode.sh
fi
