#! /bin/bash

mkdir outputs
ipt=$(zenity --entry --text "How many seconds do you want to clip from the end")

for k in *; do mv "$k" `echo $k | tr ' ' '_'`; done

for f in *.mp4
do
    x=$(ffprobe -i "$f" -show_entries format=duration -v quiet -of csv="p=0")
    trim=$(bc <<< "$x - $ipt")
    ffmpeg -t $trim -i "$f" outputs/${f%.mp4}.mp4|y
done | zenity --progress --pulsate --title "Processing " \
              --text "Clipping please wait, this may take some time" \
              --pulsate --no-cancel --auto-close \
              --width 500 

for f in * ; do mv "$f" "${f//_/ }" ; done

cd \outputs 

for f in * ; do mv "$f" "${f//_/ }" ; done
              
zenity --notification --text "Videos have been clipped"
