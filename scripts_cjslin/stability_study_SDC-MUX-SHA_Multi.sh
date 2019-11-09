#!/bin/bash

# WARNING: 
# THIS SCRIPT IS NOW CONFIGURED FOR READING ONE CHANNEL FULL CHAIN

ADC0Ch=7
ADC1Ch=7
ADC1ChShift=$((ADC1Ch+8))
FrozenSHAWord=$(((ADC1Ch<<5)+(ADC0Ch<<2)+3))

for j in 1p20; do

    #################################
    cd /home/dayabay/ColdADC/scripts/
    #./coldADC_resetADC.py
    #./coldADC_resetFPGA.py
    cd /home/dayabay/ColdADC/USB-RS232
    ./setAmplitudeVolt.py 1.4

    #################################

    # SE -> Frozen SHA configuration
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0x63
    ./writeCtrlReg.py 1 $FrozenSHAWord
    ./writeCtrlReg.py 4 0x3b
    ./writeCtrlReg.py 9 0b1000
    #Default SHA Bias current to 50uA (for SE SHA)
    ./writeCtrlReg.py 4 0x3b
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

	./plotRamp_2MSamples_Multi.py $ADC0Ch $ADC1ChShift

	python3 calc_linearity_sine.py "temp_2M_${ADC0Ch}.txt"
	mv temp_2M_${ADC0Ch}.txt Sinusoid_20KHz_SE-FrozenSHA-ADC0_NomVREFPN_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SE-FrozenSHA-ADC0_NomVREFPN_v${i}.png

	python3 calc_linearity_sine.py "temp_2M_${ADC1ChShift}.txt"
	mv temp_2M_${ADC1ChShift}.txt Sinusoid_20KHz_SE-FrozenSHA-ADC1_NomVREFPN_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SE-FrozenSHA-ADC1_NomVREFPN_v${i}.png

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

    # SE -> Free SHA configuration
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0x63
    ./writeCtrlReg.py 1 0
    ./writeCtrlReg.py 4 0x3b
    ./writeCtrlReg.py 9 0b1000
    #Default SHA Bias current to 50uA (for SE SHA)
    ./writeCtrlReg.py 4 0x3b
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

	./plotRamp_2MSamples_Multi.py $ADC0Ch $ADC1ChShift

	python3 calc_linearity_sine.py "temp_2M_${ADC0Ch}.txt"
	mv temp_2M_${ADC0Ch}.txt Sinusoid_20KHz_SE-SHA-ADC0_NomVREFPN_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SE-SHA-ADC0_NomVREFPN_v${i}.png

	python3 calc_linearity_sine.py "temp_2M_${ADC1ChShift}.txt"
	mv temp_2M_${ADC1ChShift}.txt Sinusoid_20KHz_SE-SHA-ADC1_NomVREFPN_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SE-SHA-ADC1_NomVREFPN_v${i}.png

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

    # SE -> SDC -> Frozen SHA ->ADC configuration
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0x62
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
	./plotRamp_2MSamples_Multi.py $ADC0Ch $ADC1ChShift

	python3 calc_linearity_sine.py "temp_2M_${ADC0Ch}.txt"
	mv temp_2M_${ADC0Ch}.txt Sinusoid_20KHz_SDC-FrozenSHA-ADC0_NomVREFPN_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SDC-FrozenSHA-ADC0_NomVREFPN_v${i}.png

	python3 calc_linearity_sine.py "temp_2M_${ADC1ChShift}.txt"
	mv temp_2M_${ADC1ChShift}.txt Sinusoid_20KHz_SDC-FrozenSHA-ADC1_NomVREFPN_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SDC-FrozenSHA-ADC1_NomVREFPN_v${i}.png

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

    # SE -> SDC -> SHA (full chain) configuration
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0x62
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

	./plotRamp_2MSamples_Multi.py $ADC0Ch $ADC1ChShift

	python3 calc_linearity_sine.py "temp_2M_${ADC0Ch}.txt"
	mv temp_2M_${ADC0Ch}.txt Sinusoid_20KHz_SDC-SHA-ADC0_NomVREFPN_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SDC-SHA-ADC0_NomVREFPN_v${i}.png

	python3 calc_linearity_sine.py "temp_2M_${ADC1ChShift}.txt"
	mv temp_2M_${ADC1ChShift}.txt Sinusoid_20KHz_SDC-SHA-ADC1_NomVREFPN_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SDC-SHA-ADC1_NomVREFPN_v${i}.png

	echo "Iteration #${i} completed"
    done
done


