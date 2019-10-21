#!/bin/bash

# WARNING: 
# THIS SCRIPT IS NOW CONFIGURED FOR READING ONE CHANNEL FULL CHAIN


for j in 1p20; do

    #################################
    #cd /home/dayabay/ColdADC/scripts/
    #./coldADC_resetADC.py
    #./coldADC_resetFPGA.py
    cd /home/dayabay/ColdADC/USB-RS232
    ./setAmplitudeVolt.py 1.4

    #################################

    # SE -> Frozen SHA configuration
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0x63
    ./writeCtrlReg.py 1 0x13
    ./writeCtrlReg.py 4 0x3b
    ./writeCtrlReg.py 9 0b1000
    #Default SHA Bias current to 50uA (for SE SHA)
    ./writeCtrlReg.py 4 0x3b
    ./writeCtrlReg.py 5 0x33
    ./writeCtrlReg.py 6 0x33
    ./writeCtrlReg.py 7 0x33

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
	./plotRamp_ADC0_2MSamples.py
	python3 calc_linearity_sine.py
	mv temp_2M.txt Sinusoid_20KHz_SE-FrozenSHA-ADC0_NomVREFPN_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SE-FrozenSHA-ADC0_NomVREFPN_v${i}.png
	echo "Iteration #${i} completed"

	sleep 1s
	./plotRamp_2MSamples.py
	python3 calc_linearity_sine.py
	mv temp_2M.txt Sinusoid_20KHz_SE-FrozenSHA-ADC1_NomVREFPN_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SE-FrozenSHA-ADC1_NomVREFPN_v${i}.png

	echo "Iteration #${i} completed"

    done
done

