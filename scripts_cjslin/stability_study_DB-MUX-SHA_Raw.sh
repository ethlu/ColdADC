#!/bin/bash

# WARNING: 
# THIS SCRIPT IS NOW CONFIGURED FOR READING ONE CHANNEL FULL CHAIN

ADC0Ch=0
ADC1Ch=5
ADC1ChShift=$((ADC1Ch+8))
FrozenSHAWord=$(((ADC1Ch<<5)+(ADC0Ch<<2)+3))

cd /home/dayabay/ColdADC/USB-RS232
./freq20.5078KHz.py

for j in 1p20; do

    #################################
    cd /home/dayabay/ColdADC/scripts/
    #./coldADC_resetADC.py
    #./coldADC_resetFPGA.py
    cd /home/dayabay/ColdADC/USB-RS232
    ./setAmplitudeVolt.py 1.4

    #################################

    # DBypass -> Frozen SHA configuration
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0xa3
    ./writeCtrlReg.py 1 $FrozenSHAWord
    ./writeCtrlReg.py 4 0x33
    ./writeCtrlReg.py 9 0b1000
    #Default SHA Bias current to 50uA (for SE SHA)
    ./writeCtrlReg.py 4 0x33
    ./writeCtrlReg.py 5 0x33
    ./writeCtrlReg.py 6 0x33
    ./writeCtrlReg.py 7 0x33

    for i in `seq 1 2`; do
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

	./plotRamp_2MSamples_Raw.py Sinusoid_20KHz_DBypass-FrozenSHA_NomVREFPN_2M_v${i}.txt

	echo "Iteration #${i} completed"
    done
done

for j in 1p20; do

    #################################
    cd /home/dayabay/ColdADC/scripts/
    #./coldADC_resetADC.py
    #./coldADC_resetFPGA.py
    cd /home/dayabay/ColdADC/USB-RS232
    ./setAmplitudeVolt.py 1.4

    #################################

    # DBypass -> Free SHA configuration
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0xa3
    ./writeCtrlReg.py 1 0
    ./writeCtrlReg.py 4 0x33
    ./writeCtrlReg.py 9 0b1000
    #Default SHA Bias current to 50uA (for SE SHA)
    ./writeCtrlReg.py 4 0x33
    ./writeCtrlReg.py 5 0x33
    ./writeCtrlReg.py 6 0x33
    ./writeCtrlReg.py 7 0x33

    for i in `seq 1 2`; do
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

	./plotRamp_2MSamples_Raw.py Sinusoid_20KHz_DBypass-SHA_NomVREFPN_2M_v${i}.txt

	echo "Iteration #${i} completed"
    done
done


for j in 1p20; do

    #################################
    cd /home/dayabay/ColdADC/scripts/
    #./coldADC_resetADC.py
    #./coldADC_resetFPGA.py
    cd /home/dayabay/ColdADC/USB-RS232
    ./setAmplitudeVolt.py 1.4

    #################################

    # DIFF Inputs -> DB -> Frozen SHA ->ADC configuration
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0xa1
    ./writeCtrlReg.py 1 $FrozenSHAWord
    ./writeCtrlReg.py 4 0x33
    ./writeCtrlReg.py 9 0b1000
    #Default SHA Bias current to 50uA (for SE SHA)
    ./writeCtrlReg.py 4 0x33
    ./writeCtrlReg.py 5 0x33
    ./writeCtrlReg.py 6 0x33
    ./writeCtrlReg.py 7 0x33

    for i in `seq 1 2`; do
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

	./plotRamp_2MSamples_Raw.py Sinusoid_20KHz_DB-FrozenSHA_NomVREFPN_2M_v${i}.txt

	echo "Iteration #${i} completed"
    done
done


for j in 1p20; do

    #################################
    cd /home/dayabay/ColdADC/scripts/
    #./coldADC_resetADC.py
    #./coldADC_resetFPGA.py
    cd /home/dayabay/ColdADC/USB-RS232
    ./setAmplitudeVolt.py 1.4

    #################################

    # Diff inputs -> DB -> SHA (full chain) configuration
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0xa1
    ./writeCtrlReg.py 1 0
    ./writeCtrlReg.py 4 0x33
    ./writeCtrlReg.py 9 0b1000
    #Default SHA Bias current to 50uA (for SE SHA)
    ./writeCtrlReg.py 4 0x33
    ./writeCtrlReg.py 5 0x33
    ./writeCtrlReg.py 6 0x33
    ./writeCtrlReg.py 7 0x33

    for i in `seq 1 2`; do
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

	./plotRamp_2MSamples_Raw.py Sinusoid_20KHz_DB-SHA_NomVREFPN_2M_v${i}.txt
	echo "Iteration #${i} completed"
    done
done


