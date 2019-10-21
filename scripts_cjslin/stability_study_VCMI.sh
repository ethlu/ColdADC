#!/bin/bash

# WARNING: 
# THIS SCRIPT IS NOW CONFIGURED FOR READING ONE CHANNEL FULL CHAIN


for j in 0p9 0p8 0p7; do

    #################################
    cd /home/dayabay/ColdADC/scripts/
    #./coldADC_resetADC.py
    #./coldADC_resetFPGA.py
    cd /home/dayabay/ColdADC/USB-RS232
    ./setAmplitudeVolt.py 1.4

    # Set input sine wave offset
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


    #################################
    ##### Nominal VREFPN
    ####  Looping over VCMI index j
    cd /home/dayabay/ColdADC/scripts_cjslin/enableCMOS/
    #./coldADC_enableCMOS_Ref_100mV_CMO${j}.sh
    ./coldADC_enableCMOS_NomRef_CMI${j}.sh

    # Disable frontend; single-ended SHA only
    cd /home/dayabay/ColdADC/scripts_cjslin/
    ./writeCtrlReg.py 0 0x63
    ./writeCtrlReg.py 1 0
    ./writeCtrlReg.py 4 0x3b

    for i in `seq 1 3`; do

	echo "Iteration #${i}"
	cd /home/dayabay/ColdADC/scripts_cjslin
	sleep 1s
	echo "Iteration #${i} DNL/INL data"

	./plotRamp_ADC0_2MSamples.py
	python3 calc_linearity_sine.py
	mv temp_2M.txt Sinusoid_20KHz_SE-SHA-ADC0_VCMI${j}_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SE-SHA-ADC0_VCMI${j}_v${i}.png

	./plotRamp_2MSamples.py
	python3 calc_linearity_sine.py
	mv temp_2M.txt Sinusoid_20KHz_SE-SHA-ADC1_VCMI${j}_2M_v${i}.txt
	mv temp.png Sinusoid_20KHz_SE-SHA-ADC1_VCMI${j}_v${i}.png
	echo "Iteration #${i} completed"

    done
done
