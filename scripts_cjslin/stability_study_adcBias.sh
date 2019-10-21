#!/bin/bash


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

###########################################
# ADC Bias current 40uA ; 80-10*ibias[2:0]
./writeCtrlReg.py 8 0xc

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
  mv temp_2M.txt Sinusoid_147KHz_VREFPN-300mV_Reg8-0xc_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_VREFPN-300mV_Reg8-0xc_v${i}.png
  mv temp_calibData.txt CalibData_VREFPN-300mV_Reg8-0xc_v${i}.txt
  mv temp_S0-3.pdf S0-3_VREFPN-300mV_Reg8-0xc_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_VREFPN-300mV_Reg8-0xc_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_VREFPN-300mV_Reg8-0xc_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_VREFPN-300mV_Reg8-0xc_v${i}.txt
  echo "Iteration #${i} completed"
done


###########################################
# ADC Bias current 20uA ; 80-10*ibias[2:0]
./writeCtrlReg.py 8 0xe

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
  mv temp_2M.txt Sinusoid_147KHz_VREFPN-300mV_Reg8-0xe_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_VREFPN-300mV_Reg8-0xe_v${i}.png
  mv temp_calibData.txt CalibData_VREFPN-300mV_Reg8-0xe_v${i}.txt
  mv temp_S0-3.pdf S0-3_VREFPN-300mV_Reg8-0xe_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_VREFPN-300mV_Reg8-0xe_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_VREFPN-300mV_Reg8-0xe_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_VREFPN-300mV_Reg8-0xe_v${i}.txt
  echo "Iteration #${i} completed"
done


###########################################
# ADC Bias current 10uA ; 80-10*ibias[2:0]
./writeCtrlReg.py 8 0xf

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
  mv temp_2M.txt Sinusoid_147KHz_VREFPN-300mV_Reg8-0xf_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_VREFPN-300mV_Reg8-0xf_v${i}.png
  mv temp_calibData.txt CalibData_VREFPN-300mV_Reg8-0xf_v${i}.txt
  mv temp_S0-3.pdf S0-3_VREFPN-300mV_Reg8-0xf_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_VREFPN-300mV_Reg8-0xf_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_VREFPN-300mV_Reg8-0xf_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_VREFPN-300mV_Reg8-0xf_v${i}.txt
  echo "Iteration #${i} completed"
done

###########################################
# ADC Bias current 70uA ; 80-10*ibias[2:0]
./writeCtrlReg.py 8 0x9

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
  mv temp_2M.txt Sinusoid_147KHz_VREFPN-300mV_Reg8-0x9_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_VREFPN-300mV_Reg8-0x9_v${i}.png
  mv temp_calibData.txt CalibData_VREFPN-300mV_Reg8-0x9_v${i}.txt
  mv temp_S0-3.pdf S0-3_VREFPN-300mV_Reg8-0x9_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_VREFPN-300mV_Reg8-0x9_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_VREFPN-300mV_Reg8-0x9_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_VREFPN-300mV_Reg8-0x9_v${i}.txt
  echo "Iteration #${i} completed"
done


###########################################
# ADC Bias current 50uA ; 80-10*ibias[2:0]
./writeCtrlReg.py 8 0xb

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
  mv temp_2M.txt Sinusoid_147KHz_VREFPN-300mV_Reg8-0xb_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_VREFPN-300mV_Reg8-0xb_v${i}.png
  mv temp_calibData.txt CalibData_VREFPN-300mV_Reg8-0xb_v${i}.txt
  mv temp_S0-3.pdf S0-3_VREFPN-300mV_Reg8-0xb_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_VREFPN-300mV_Reg8-0xb_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_VREFPN-300mV_Reg8-0xb_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_VREFPN-300mV_Reg8-0xb_v${i}.txt
  echo "Iteration #${i} completed"
done




#######################################################################
# Nominal VREFN/P
#######################################################################

cd /home/dayabay/ColdADC/scripts/
./coldADC_resetADC.py
./coldADC_resetFPGA.py
./coldADC_enableCMOS_Ref_LN2.sh
cd /home/dayabay/ColdADC/USB-RS232
./setAmplitudeVolt.py 1.49
cd /home/dayabay/ColdADC/scripts_cjslin/
./writeCtrlReg.py 0 0x3

###########################################
# ADC Bias current 40uA ; 80-10*ibias[2:0]
./writeCtrlReg.py 8 0xc

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
  mv temp_2M.txt Sinusoid_147KHz_NomVREFPN_Reg8-0xc_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_NomVREFPN_Reg8-0xc_v${i}.png
  mv temp_calibData.txt CalibData_NomVREFPN_Reg8-0xc_v${i}.txt
  mv temp_S0-3.pdf S0-3_NomVREFPN_Reg8-0xc_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_NomVREFPN_Reg8-0xc_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_NomVREFPN_Reg8-0xc_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_NomVREFPN_Reg8-0xc_v${i}.txt
  echo "Iteration #${i} completed"
done


###########################################
# ADC Bias current 20uA ; 80-10*ibias[2:0]
./writeCtrlReg.py 8 0xe

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
  mv temp_2M.txt Sinusoid_147KHz_NomVREFPN_Reg8-0xe_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_NomVREFPN_Reg8-0xe_v${i}.png
  mv temp_calibData.txt CalibData_NomVREFPN_Reg8-0xe_v${i}.txt
  mv temp_S0-3.pdf S0-3_NomVREFPN_Reg8-0xe_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_NomVREFPN_Reg8-0xe_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_NomVREFPN_Reg8-0xe_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_NomVREFPN_Reg8-0xe_v${i}.txt
  echo "Iteration #${i} completed"
done


###########################################
# ADC Bias current 10uA ; 80-10*ibias[2:0]
./writeCtrlReg.py 8 0xf

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
  mv temp_2M.txt Sinusoid_147KHz_NomVREFPN_Reg8-0xf_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_NomVREFPN_Reg8-0xf_v${i}.png
  mv temp_calibData.txt CalibData_NomVREFPN_Reg8-0xf_v${i}.txt
  mv temp_S0-3.pdf S0-3_NomVREFPN_Reg8-0xf_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_NomVREFPN_Reg8-0xf_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_NomVREFPN_Reg8-0xf_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_NomVREFPN_Reg8-0xf_v${i}.txt
  echo "Iteration #${i} completed"
done

###########################################
# ADC Bias current 70uA ; 80-10*ibias[2:0]
./writeCtrlReg.py 8 0x9

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
  mv temp_2M.txt Sinusoid_147KHz_NomVREFPN_Reg8-0x9_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_NomVREFPN_Reg8-0x9_v${i}.png
  mv temp_calibData.txt CalibData_NomVREFPN_Reg8-0x9_v${i}.txt
  mv temp_S0-3.pdf S0-3_NomVREFPN_Reg8-0x9_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_NomVREFPN_Reg8-0x9_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_NomVREFPN_Reg8-0x9_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_NomVREFPN_Reg8-0x9_v${i}.txt
  echo "Iteration #${i} completed"
done


###########################################
# ADC Bias current 50uA ; 80-10*ibias[2:0]
./writeCtrlReg.py 8 0xb

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
  mv temp_2M.txt Sinusoid_147KHz_NomVREFPN_Reg8-0xb_2M_${i}.txt
  mv temp.png Sinusoid_147KHz_NomVREFPN_Reg8-0xb_v${i}.png
  mv temp_calibData.txt CalibData_NomVREFPN_Reg8-0xb_v${i}.txt
  mv temp_S0-3.pdf S0-3_NomVREFPN_Reg8-0xb_v${i}.pdf
  #./manualCalib_plots.py temp_calibData2.txt
  #mv temp_calibData2.txt CalibData_NomVREFPN_Reg8-0xb_ADC1_v${i}.txt
  #mv temp_S0-3.pdf S0-3_NomVREFPN_Reg8-0xb_ADC1_v${i}.pdf
  ./readCalibWeights.py > CalibWts_NomVREFPN_Reg8-0xb_v${i}.txt
  echo "Iteration #${i} completed"
done

