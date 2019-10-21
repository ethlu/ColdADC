#!/bin/bash

# WARNING: 
# THIS SCRIPT IS NOW CONFIGURED FOR READING ONE CHANNEL FULL CHAIN


for j in 1p20 1p22 1p18 1p24 1p16; do

    #################################
    cd /home/dayabay/ColdADC/scripts/
    #./coldADC_resetADC.py
    #./coldADC_resetFPGA.py
    cd /home/dayabay/ColdADC/USB-RS232
    ./setAmplitudeVolt.py 1.4

    #################################
    ##### Clap VREFPN by +-100mV
    ####  Looping over VCMO index j
    cd /home/dayabay/ColdADC/scripts_cjslin/enableCMOS/
    #./coldADC_enableCMOS_Ref_100mV_CMO${j}_LN2.sh
    ./coldADC_enableCMOS_NomRef_CMO${j}_LN2.sh

    # Disable frontend for ADC only
    cd /home/dayabay/ColdADC/scripts_cjslin/
    #./writeCtrlReg.py 0 0x3

    for i in `seq 1 3`; do
	echo "Iteration #${i}"
	cd /home/dayabay/ColdADC/scripts_cjslin
	../USB-RS232/turnFuncOFF.py
	./writeCtrlReg.py 9 0
	sleep 1s
	echo "Iteration #${i} calibration"
	./manualCalib.py

	#Configure for test input OR full chain; binary offset
	#./writeCtrlReg.py 9 0b101000
	./writeCtrlReg.py 9 0b1000

	../USB-RS232/turnFuncON.py
	./manualCalib_plots.py
	sleep 1s
	echo "Iteration #${i} DNL/INL data"
	./plotRamp_2MSamples.py
	python3 calc_linearity_sine.py
	mv temp_2M.txt Sinusoid_147KHz_NomVREFPN_CMO${j}_2M_v${i}.txt
	mv temp.png Sinusoid_147KHz_NomVREFPN_CMO${j}_v${i}.png
	mv temp_calibData.txt CalibData_NomVREFPN_CMO${j}_v${i}.txt
	mv temp_S0-3.pdf S0-3_NomVREFPN_CMO${j}_v${i}.pdf
        #./manualCalib_plots.py temp_calibData2.txt
        #mv temp_calibData2.txt CalibData_NomVREFPN_CMO${j}_ADC1_v${i}.txt
        #mv temp_S0-3.pdf S0-3_NomVREFPN_CMO${j}_ADC1_v${i}.pdf
	./readCalibWeights.py > CalibWts_NomVREFPN_CMO${j}_v${i}.txt
	echo "Iteration #${i} completed"
    done
done
