#!/bin/bash
#Copyright 2019 Gustavo Santana
#(C) 2017-2019 Mirai Works LLC
#Disable cursor 
setterm -cursor off
sleep 7;

resolution=$(tvservice -s | grep -oP '[[:digit:]]{1,4}x[[:digit:]]{1,4} ')
a="1920x1080 "
b="1280x720 "
c="720x480 "
d="320x240 "

#Clean Screen?
#sudo sh -c “TERM=linux setterm -foreground black -clear >/dev/tty0”
#Well better if no. So keep it comented

TIMER="2";
TXSEC="$(($TIMER * 60))";

IMAGIPATH="/home/uslu/elements/Kit_imagenes";

# Nombre de instancia para que no choque con la de uxmalstream
SERVICE="imagiplayer";

echo "$resolution"

if [ "$resolution" == "$a" ]
then
        boxed="--win 0,0,1920,1080";
elif [ "$resolution" == "$b" ]; 
then
        boxed="--win 0,0,1280,720";
elif [ "$resolution" == "$c" ]; 
then
        boxed="--win 23,37,695,443";
elif [ "$resolution" == "$d" ]; 
then
        exit;
fi
echo "$boxed"

# infinite loop!
while true; do
        if ps ax | grep -v grep | grep $SERVICE > /dev/null
        then
        sleep 1;
else
        for entry in $IMAGIPATH/*
        do
	echo "start $entry" >> log_$(date +%Y_%m_%d).txt;
        if [[ `lsof | grep /home/uslu/elements/Video_chico/` ]]
        then
        sleep 60;
        echo "espera por L activa" >> log_$(date +%Y_%m_%d).txt;
        fi
        if [[ `lsof | grep /home/uslu/uxmalstream/streamer/uploads/ads/` ]]
        then
        sleep 60;
        echo "espera por anuncio con audio" >> log_$(date +%Y_%m_%d).txt;
        fi
	if [[ `lsof | grep /home/uslu/uxmal_2.0/uploads/ads/` ]]
        then
        sleep 60;
        echo "espera por anuncio con audio" >> log_$(date +%Y_%m_%d).txt;
        fi
	if [[ `lsof | grep /home/uslu/elements/Spots_con_audio/` ]]
        then
        sleep 60;
        echo "espera por anuncio con audio" >> log_$(date +%Y_%m_%d).txt;
        fi
        date >> log_$(date +%Y_%m_%d).txt;
#	clear;
        ( cmdpid="$BASHPID";
        (omxiv $boxed -t 45 -T blend -l 20 -k "$entry" >> log_$(date +%Y_%m_%d).txt) \
        & while ! bash /home/uslu/ssignage/next_img.sh;
        do
               echo "Todo listo";
               #exit;
        done
        wait)
	date >> log_$(date +%Y_%m_%d).txt;
	echo "Stop $entry" >> log_$(date +%Y_%m_%d).txt;
        clear;
	/home/uslu/ssignage/ssignage_sleep $TXSEC;
        echo "Lapso de tiempo entre anuncios" >> log_$(date +%Y_%m_%d).txt;
        done
fi
done
