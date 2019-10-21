#!/bin/bash

# WARNING: 
# THIS SCRIPT IS NOW CONFIGURED FOR READING ONE CHANNEL FULL CHAIN


for j in 0p9 0p8 0p7; do
    cd /home/dayabay/ColdADC/USB-RS232

    if [ ${j} == '0p9' ]  
    then
	./setOffsetVolt.py 0.9
    elif [ ${j} == '0p8' ]  
    then
	./setOffsetVolt.py 0.8
    elif [ ${j} == '0p7' ]  
    then
	./setOffsetVolt.py 0.7
    fi

done
