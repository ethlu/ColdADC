#!/usr/bin/env python3

import time
import binascii
import sys, os
import RPi.GPIO as GPIO
import spidev
import serial
import readADC
import readCtrlReg
import matplotlib.pyplot as plt
import matplotlib.animation as animation
from matplotlib import style
from scipy.optimize import curve_fit
import numpy as np

def getChADCVal(ADC_Data,chnum):
    adcArray=[]
    ichnum=chnum
    for iCnt in range (0,int((len(ADC_Data))/16)):
        adcArray.append(ADC_Data[ichnum])
        ichnum += 16
    return(adcArray)

def getADCVal(ADC_Data,adcNum):
    adcArray=[]
    ichNum=int(adcNum*8)
    for iCnt in range (0,int((len(ADC_Data))/16)):
        for iCh in range (0,8):
            adcArray.append(ADC_Data[ichNum])
            ichNum += 1
        ichNum += 8
    return(adcArray)


#######################################################################

def checkRegisters(serial0):
    Reg50Val=readCtrlReg.main(serial0,50)
    Reg9Val=readCtrlReg.main(serial0,9)
    if (( Reg50Val !=0) or (Reg9Val != 0 )):
        print("Error: register 9 and/or register 50 are NOT set to zero")
        sys.exit()

def printADCdata(iData):
    for iCnt in range (0,len(iData)):
        if ((iCnt%16) == 0 ):
            print("------------------------------------------------")
        print("Block",int(iCnt/16)," ADC Ch(",str(iCnt%16).zfill(2),") = ",hex(iData[iCnt]),
              " (",bin(iData[iCnt])[2:].zfill(16),")","(",iData[iCnt],")")
    return()

ADC0Num=5

def extract_raw(temp_file, channels):
    with open(temp_file, "r") as rawFile:
        firstBlock = [int(v) for v in rawFile]
    deSerialData = readADC.deSerialize(firstBlock)
    for ch in channels:
        ChNum = (ADC0Num+ch%8)%8 + 8*(ch//8)
        iadcVal = getChADCVal(deSerialData,ChNum)

        with open("ch{}_{}".format(ch, temp_file),"a") as outFile:
            for jx in range (0,len(iadcVal)):
                #iLine=str(x0[ix])+","+str(iadcVal[jx])+"\n"
                iLine=str(iadcVal[jx])+"\n"
                outFile.write(iLine)
#extract_raw("temp_2M_raw.txt", [0, 8])



if __name__ == '__main__':

#    if (len(sys.argv) != 3):
#        print("\readADC.py requires 2 arguments: address (int) and value (int,0x,0b)")
#        print("Example:  ./coldADC_writeCtrlReg.py 31 0b100 \n")
#        sys.exit()
    
#    #Set register address (config bit is already set to 1)
#    iAddress=int(sys.argv[1])
#    idata=sys.argv[2]


    ser = serial.Serial(
                port='/dev/serial0',
                baudrate=1000000,
                parity=serial.PARITY_NONE,
                stopbits=serial.STOPBITS_ONE,
                bytesize=serial.EIGHTBITS)

    print (ser.portstr)

    #Clear Serial buffers
    ser.flush()
    #ser.flushInput()
    #ser.flushOutput()

    #Configure spi0
    spi0 = spidev.SpiDev()
    spi0.open(0,0)
    spi0.max_speed_hz = 8000000
    #mode [CPOL][CPHA]: 0b01=latch on trailing edge of clock
    spi0.mode = 0b01
    
    #Configure GPIO
    GPIO.setmode(GPIO.BCM)
    #GPIO.setmode(GPIO.BOARD)
    GPIO.setwarnings(False)

    #Define GPIO pins
    FPGA_FIFO_FULL=12
    UART_SEL=27
    ADC_RESET=6
    FPGA_RESET=22

    #Set input and output pins
    GPIO.setup(FPGA_FIFO_FULL, GPIO.IN)
    GPIO.setup(UART_SEL, GPIO.OUT)
    GPIO.setup(FPGA_RESET, GPIO.OUT)
    GPIO.setup(ADC_RESET, GPIO.OUT)

    #Set output pin initial state
    GPIO.output(UART_SEL, GPIO.HIGH)
    GPIO.output(FPGA_RESET, GPIO.HIGH)
    GPIO.output(ADC_RESET, GPIO.HIGH)
    time.sleep(0.1)

    #Open output file
    #outFile=open("Sinusoid_66KHz_ReducedVRef_2MSamples.txt","w")
    #outFile=open("Sinusoid_11p2304KHz_NomRefV_VDDA2p5_SingleEnded-SHA-ADC_2M.txt","w")
    #outFile=open("Sinusoid_20p5078KHz_NomRefV_VDDA2p5_singleEnded-SHA-ADC_2M.txt","w")
    #outFile=open("Sinusoid_11p2304KHz_NomRefV_VDDA2p5_SDC-SHA-ADC_2M.txt","w")
    #outFile=open("Sinusoid_147p461KHz_NomRefV_VDDA2p5_ADC_2M.txt","w")
    #outFile=open("Sinusoid_147p461KHz_VREFPN-200mV_VDDA2p25_Reg23-0x30_ADC_2M.txt","w")
    #outFile=open("Sinusoid_147p461KHz_NomVREFPN_VDDA2p35_ADC_2M.txt","w")
    #outFile=open("Sinusoid_17KHz_NomRefV_VDDA2p5_ADC_2M.txt","w")
    #outFile=open("temp_2M.txt","w")

    #readADC.resetCHIP(GPIO, FPGA_RESET)
    #readADC.resetCHIP(GPIO, ADC_RESET)

    #Number of words in FPGA FIFO
    NWORDFIFO=65536

    #ColdADC synchronization. Find ADC channel 0
    #ADC0Num=readADC.findADCch0(GPIO,spi0,ser,FPGA_FIFO_FULL,NWORDFIFO)
    #print("ADC0 Channel 0 = ",ADC0Num)

    #Verify both registers 9 and 50 are set to 0
    #checkRegisters(ser)

    # For ADC Test input only NumSet=120 --> 2M samples
    # For Full chain reading out one channel need NumSet=960 to get 2M samples
    #NumSet=120
    NumSet=960
    #NumSet=1
    
    ##############################################
    #Readout Mode (0=read ADC0 block, 1=read ADC1 block, 2=single channel read)
    #             ChNum ignored if ReadMode<2
    ##############################################
    ReadMode=2

    #ChNum = (ADC0Num+0)%8  # ADC0

    SampRate=1./2E6

    #Number of time step
    NTimeStp=int((NWORDFIFO/32)*NumSet)
    if ReadMode != 2:
        NTimeStp=int(NTimeStp*8)
        SampRate=1./16E6

    if len(sys.argv)>1:
        temp_file = sys.argv[1]
    else:
        temp_file = "temp_2M_raw.txt"
    if os.path.exists(temp_file):
        print("{} exists, moving it to old_{}".format(temp_file, temp_file))
        os.rename(temp_file, "old_"+temp_file) 

    ix = 0
    iadcVal=[]
    idummy=readADC.main(GPIO,spi0,ser,FPGA_FIFO_FULL,NWORDFIFO)
    for iLoop in range(0,NumSet):
        readADC.pollFIFO(GPIO, FPGA_FIFO_FULL)
        firstBlock=spi0.readbytes(NWORDFIFO)

        with open(temp_file,"a") as outFile:
            for val in firstBlock:
                #iLine=str(x0[ix])+","+str(iadcVal[jx])+"\n"
                iLine=str(val)+"\n"
                outFile.write(iLine)
                ix += 1

        if (iLoop%10) == 0:
            print("Reading FIFO # ",iLoop)

    #Exit GPIO cleanly
    GPIO.cleanup

    #Close serial port
    ser.close()

    #Close spi0
    spi0.close()

    #Close output file
    #outFile.close()
