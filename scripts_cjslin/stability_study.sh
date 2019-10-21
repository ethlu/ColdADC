#!/bin/bash

cd /home/dayabay/ColdADC/scripts/
./coldADC_resetADC.py
./coldADC_resetFPGA.py
./coldADC_enableCMOS_Ref_LN2.sh
cd /home/dayabay/ColdADC/USB-RS232
./setAmplitudeVolt.py 1.49
cd /home/dayabay/ColdADC/scripts_cjslin/
./writeCtrlReg.py 0 0x3

for i in `seq 1 5`;
do
  echo "Iteration #${i}"
  cd /home/dayabay/ColdADC/scripts_cjslin
  ../USB-RS232/turnFuncOFF.py
  ./writeCtrlReg.py 9 0
  sleep 1s
  echo "Iteration #${i} calibration"
  ./writeCtrlReg.py 9 0b1000
  ./manualCalib.py
  ./writeCtrlReg.py 9 0b101000
  ../USB-RS232/turnFuncON.py
  ./manualCalib_plots.py
  sleep 1s
  echo "Iteration #${i} DNL/INL data"
  ./plotRamp_2MSamples.py
  python3 calc_linearity_sine.py
  mv temp_2M.txt Sinusoid_147KHz_NomVREF_2M_v${i}.txt
  mv temp.png Sinusoid_147KHz_NomVREF_v${i}.png
  mv temp_calibData.txt CalibData_NomVREF_v${i}.txt
  mv temp_S0-3.pdf S0-3_NomVREF_v${i}.pdf
  ./manualCalib_plots.py temp_calibData2.txt
  mv temp_calibData2.txt CalibData_NomVREF_ADC1_v${i}.txt
  mv temp_S0-3.pdf S0-3_NomVREF_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_NomVREF_v${i}.txt
  echo "Iteration #${i} completed"
done


