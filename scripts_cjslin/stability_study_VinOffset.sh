#!/bin/bash

# WARNING: 
# THIS SCRIPT IS NOW CONFIGURED FOR READING ONE CHANNEL FULL CHAIN


for j in 1.2 ; do

    #################################
    #cd /home/dayabay/ColdADC/scripts/
    #./coldADC_resetADC.py
    #./coldADC_resetFPGA.py
    cd /home/dayabay/ColdADC/USB-RS232
    ./setAmplitudeVolt.py 1.5
    ./setOffsetVolt.py ${j}

    #################################
    ##### Nominal CMOS VREFPN
    ####  Looping over offset index j

    # Disable frontend for ADC only
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0x63
    ./writeCtrlReg.py 9 0b101000


    for i in `seq 1 50`; do
	echo "Iteration #${i}"
	cd /home/dayabay/ColdADC/scripts_cjslin
	#../USB-RS232/turnFuncOFF.py
	#./writeCtrlReg.py 9 0
	#sleep 1s
	#echo "Iteration #${i} calibration"
	#./manualCalib.py

	#../USB-RS232/turnFuncON.py
	#./manualCalib_plots.py
	sleep 1s
	echo "Iteration #${i} DNL/INL data"

	sleep 1s
	./plotRamp_ADC0_2MSamples.py
	python3 calc_linearity_sine.py
	#mv temp_2M.txt Sinusoid_21KHz_ADC0Only_OffSet${j}V_2M_v${i}.txt
	mv temp.png Sinusoid_21KHz_ADC0Only_OffSet${j}V_v${i}.png
	echo "Iteration #${i} completed"

	sleep 1s
	./plotRamp_2MSamples.py
	python3 calc_linearity_sine.py
	#mv temp_2M.txt Sinusoid_21KHz_ADC1Only_OffSet${j}V_2M_v${i}.txt
	mv temp.png Sinusoid_21KHz_ADC1Only_OffSet${j}V_v${i}.png

	echo "Iteration #${i} completed"
	sleep 60s

    done
done
