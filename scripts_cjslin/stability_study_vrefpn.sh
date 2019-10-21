#!/bin/bash

#################################
##### Nominal VREFPN
cd /home/dayabay/ColdADC/scripts/
./coldADC_resetADC.py
./coldADC_resetFPGA.py
./coldADC_enableCMOS_Ref_LN2.sh
cd /home/dayabay/ColdADC/USB-RS232
./setAmplitudeVolt.py 1.49
cd /home/dayabay/ColdADC/scripts_cjslin/
./writeCtrlReg.py 0 0x3

for i in `seq 1 3`;
do
  echo "Iteration #${i}"
  cd /home/dayabay/ColdADC/scripts_cjslin
  ../USB-RS232/turnFuncOFF.py
  ./writeCtrlReg.py 9 0
  sleep 1s
  echo "Iteration #${i} calibration"
  ./manualCalib.py
  ./writeCtrlReg.py 9 0b101000
  ../USB-RS232/turnFuncON.py
  ./manualCalib_plots.py
  sleep 1s
  echo "Iteration #${i} DNL/INL data"
  ./plotRamp_2MSamples.py
  python3 calc_linearity_sine.py
  mv temp_2M.txt Sinusoid_147KHz_NomVREFPN_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_NomVREFPN_v${i}.png
  mv temp_calibData.txt CalibData_NomVREFPN_v${i}.txt
  mv temp_S0-3.pdf S0-3_NomVREFPN_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_NomVREFPN_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_NomVREFPN_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_NomVREFPN_v${i}.txt
  echo "Iteration #${i} completed"
done

#################################
##### Clap VREFPN by +-100mV
cd /home/dayabay/ColdADC/scripts/
./coldADC_resetADC.py
./coldADC_resetFPGA.py
./coldADC_enableCMOS_Ref_100mV_LN2.sh
cd /home/dayabay/ColdADC/USB-RS232
./setAmplitudeVolt.py 1.29
cd /home/dayabay/ColdADC/scripts_cjslin/
./writeCtrlReg.py 0 0x3

for i in `seq 1 3`;
do
  echo "Iteration #${i}"
  cd /home/dayabay/ColdADC/scripts_cjslin
  ../USB-RS232/turnFuncOFF.py
  ./writeCtrlReg.py 9 0
  sleep 1s
  echo "Iteration #${i} calibration"
  ./manualCalib.py
  ./writeCtrlReg.py 9 0b101000
  ../USB-RS232/turnFuncON.py
  ./manualCalib_plots.py
  sleep 1s
  echo "Iteration #${i} DNL/INL data"
  ./plotRamp_2MSamples.py
  python3 calc_linearity_sine.py
  mv temp_2M.txt Sinusoid_147KHz_VREFPN-100mV_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_VREFPN-100mV_v${i}.png
  mv temp_calibData.txt CalibData_VREFPN-100mV_v${i}.txt
  mv temp_S0-3.pdf S0-3_VREFPN-100mV_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_VREFPN-100mV_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_VREFPN-100mV_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_VREFPN-100mV_v${i}.txt
  echo "Iteration #${i} completed"
done


#################################
##### Clap VREFPN by +-200mV
cd /home/dayabay/ColdADC/scripts/
./coldADC_resetADC.py
./coldADC_resetFPGA.py
./coldADC_enableCMOS_Ref_200mV_LN2.sh
cd /home/dayabay/ColdADC/USB-RS232
./setAmplitudeVolt.py 1.09
cd /home/dayabay/ColdADC/scripts_cjslin/
./writeCtrlReg.py 0 0x3

for i in `seq 1 3`;
do
  echo "Iteration #${i}"
  cd /home/dayabay/ColdADC/scripts_cjslin
  ../USB-RS232/turnFuncOFF.py
  ./writeCtrlReg.py 9 0
  sleep 1s
  echo "Iteration #${i} calibration"
  ./manualCalib.py
  ./writeCtrlReg.py 9 0b101000
  ../USB-RS232/turnFuncON.py
  ./manualCalib_plots.py
  sleep 1s
  echo "Iteration #${i} DNL/INL data"
  ./plotRamp_2MSamples.py
  python3 calc_linearity_sine.py
  mv temp_2M.txt Sinusoid_147KHz_VREFPN-200mV_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_VREFPN-200mV_v${i}.png
  mv temp_calibData.txt CalibData_VREFPN-200mV_v${i}.txt
  mv temp_S0-3.pdf S0-3_VREFPN-200mV_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_VREFPN-200mV_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_VREFPN-200mV_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_VREFPN-200mV_v${i}.txt
  echo "Iteration #${i} completed"
done

#################################
##### Clap VREFPN by +-300mV
cd /home/dayabay/ColdADC/scripts/
./coldADC_resetADC.py
./coldADC_resetFPGA.py
./coldADC_enableCMOS_Ref_300mV_LN2.sh
cd /home/dayabay/ColdADC/USB-RS232
./setAmplitudeVolt.py 0.89
cd /home/dayabay/ColdADC/scripts_cjslin/
./writeCtrlReg.py 0 0x3

for i in `seq 1 3`;
do
  echo "Iteration #${i}"
  cd /home/dayabay/ColdADC/scripts_cjslin
  ../USB-RS232/turnFuncOFF.py
  ./writeCtrlReg.py 9 0
  sleep 1s
  echo "Iteration #${i} calibration"
  ./manualCalib.py
  ./writeCtrlReg.py 9 0b101000
  ../USB-RS232/turnFuncON.py
  ./manualCalib_plots.py
  sleep 1s
  echo "Iteration #${i} DNL/INL data"
  ./plotRamp_2MSamples.py
  python3 calc_linearity_sine.py
  mv temp_2M.txt Sinusoid_147KHz_VREFPN-300mV_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_VREFPN-300mV_v${i}.png
  mv temp_calibData.txt CalibData_VREFPN-300mV_v${i}.txt
  mv temp_S0-3.pdf S0-3_VREFPN-300mV_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_VREFPN-300mV_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_VREFPN-300mV_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_VREFPN-300mV_v${i}.txt
  echo "Iteration #${i} completed"
done

