read -rsn1 input
if [ "$input" = "l" ]; then
    timeout 10 feh -F $(./latestfile.sh)&&rm -rf *.jpg
fi
