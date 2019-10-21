#!/usr/bin/env python3

import time
import binascii
import sys
import RPi.GPIO as GPIO
import spidev
import serial
import readADC
import writeCtrlReg
import readCtrlReg
import writeCalibReg

def computeAvgADC(GPort,SPI0,SERIAL0,FIFO_FULL,NWORD,numset):
    AvgADC=[0,0]

    idummy=readADC.main(GPort,SPI0,SERIAL0,FIFO_FULL,NWORD)
    iCntADC0 = 0
    iCntADC1 = 0
    for iLoop in range(0,numset):
        deSerialData=readADC.main(GPort,SPI0,SERIAL0,FIFO_FULL,NWORD)
        #printADCdata(deSerialData)

        jCnt=0
        #for iCnt in range(0,len(deSerialData)):
        for iCnt in range(0,32):
            if jCnt < 8 :
                AvgADC[0] = ((AvgADC[0]*iCntADC0)+(deSerialData[iCnt]))/(iCntADC0 + 1.0)
                jCnt += 1
                iCntADC0 += 1
            else:
                AvgADC[1] = ((AvgADC[1]*iCntADC1)+(deSerialData[iCnt]))/(iCntADC1 + 1.0)
                jCnt += 1
                iCntADC1 += 1
            if jCnt == 16:
                jCnt=0

    return(AvgADC)

def computeS0123(gpio,spi,ser0,fifo_full,nword, numevt):
    writeCtrlReg.main(ser0, 46, str(0))
    ADCVal=computeAvgADC(gpio,spi,ser0,fifo_full,nword, numevt)
    s0 =ADCVal

    writeCtrlReg.main(ser0, 46, str(0x1))
    ADCVal=computeAvgADC(gpio,spi,ser0,fifo_full,nword, numevt)
    s1 = ADCVal

    writeCtrlReg.main(ser0, 46, str(0x5))
    ADCVal=computeAvgADC(gpio,spi,ser0,fifo_full,nword, numevt)
    s2 = ADCVal

    writeCtrlReg.main(ser0, 46, str(0x4))
    writeCtrlReg.main(ser0, 45, str(0x10))
    ADCVal=computeAvgADC(gpio,spi,ser0,fifo_full,nword, numevt)
    s3 = ADCVal

    print(s0,s1,s2,s3)

    for ij in [44, 45, 46]:
        writeCtrlReg.main(ser0, ij, str(0))
    return(s0,s1,s2,s3)

#######################################################################
def calibStage6(GPort, SPI0, Serial0, FIFO_FULL, NWORD, NumEvt):

    writeCtrlReg.main(Serial0, 32, str(0x7f))
    writeCtrlReg.main(Serial0, 44, str(0x19))
    writeCtrlReg.main(Serial0, 46, str(0x10))

    S0,S1,S2,S3=computeS0123(GPort,SPI0,Serial0,FIFO_FULL,NWORD, NumEvt)

    ADC0W0=int(S1[0]+(65536-S0[0])) & 0xFFFF
    ADC0W2=int(S2[0]+(65536-S3[0])) & 0xFFFF
    ADC1W0=int(S1[1]+(65536-S0[1])) & 0xFFFF
    ADC1W2=int(S2[1]+(65536-S3[1])) & 0xFFFF

    writeCalibReg.main(Serial0,12,str(ADC0W0&0xFF))
    writeCalibReg.main(Serial0,13,str((ADC0W0&0xFF00)>>8))
    writeCalibReg.main(Serial0,44,str(ADC0W2&0xFF))
    writeCalibReg.main(Serial0,45,str((ADC0W2&0xFF00)>>8))
    #writeCalibReg.main(Serial0,76,str(ADC1W0&0xFF))
    #writeCalibReg.main(Serial0,77,str((ADC1W0&0xFF00)>>8))
    #writeCalibReg.main(Serial0,108,str(ADC1W2&0xFF))
    #writeCalibReg.main(Serial0,109,str((ADC1W2&0xFF00)>>8))
    return()

#######################################################################

def calibStage5(GPort, SPI0, Serial0, FIFO_FULL, NWORD, NumEvt):

    writeCtrlReg.main(Serial0, 32, str(0x6f))
    writeCtrlReg.main(Serial0, 44, str(0x15))
    writeCtrlReg.main(Serial0, 46, str(0x10))

    S0,S1,S2,S3=computeS0123(GPort,SPI0,Serial0,FIFO_FULL,NWORD, NumEvt)

    ADC0W0=int(S1[0]+(65536-S0[0])) & 0xFFFF
    ADC0W2=int(S2[0]+(65536-S3[0])) & 0xFFFF
    ADC1W0=int(S1[1]+(65536-S0[1])) & 0xFFFF
    ADC1W2=int(S2[1]+(65536-S3[1])) & 0xFFFF

    writeCalibReg.main(Serial0,10,str(ADC0W0&0xFF))
    writeCalibReg.main(Serial0,11,str((ADC0W0&0xFF00)>>8))
    writeCalibReg.main(Serial0,42,str(ADC0W2&0xFF))
    writeCalibReg.main(Serial0,43,str((ADC0W2&0xFF00)>>8))
    #writeCalibReg.main(Serial0,74,str(ADC1W0&0xFF))
    #writeCalibReg.main(Serial0,75,str((ADC1W0&0xFF00)>>8))
    #writeCalibReg.main(Serial0,106,str(ADC1W2&0xFF))
    #writeCalibReg.main(Serial0,107,str((ADC1W2&0xFF00)>>8))
    return()

#######################################################################

def calibStage4(GPort, SPI0, Serial0, FIFO_FULL, NWORD, NumEvt):

    writeCtrlReg.main(Serial0, 32, str(0x5f))
    writeCtrlReg.main(Serial0, 44, str(0x11))
    writeCtrlReg.main(Serial0, 46, str(0x10))

    S0,S1,S2,S3=computeS0123(GPort,SPI0,Serial0,FIFO_FULL,NWORD, NumEvt)

    ADC0W0=int(S1[0]+(65536-S0[0])) & 0xFFFF
    ADC0W2=int(S2[0]+(65536-S3[0])) & 0xFFFF
    ADC1W0=int(S1[1]+(65536-S0[1])) & 0xFFFF
    ADC1W2=int(S2[1]+(65536-S3[1])) & 0xFFFF

    writeCalibReg.main(Serial0,8,str(ADC0W0&0xFF))
    writeCalibReg.main(Serial0,9,str((ADC0W0&0xFF00)>>8))
    writeCalibReg.main(Serial0,40,str(ADC0W2&0xFF))
    writeCalibReg.main(Serial0,41,str((ADC0W2&0xFF00)>>8))
    #writeCalibReg.main(Serial0,72,str(ADC1W0&0xFF))
    #writeCalibReg.main(Serial0,73,str((ADC1W0&0xFF00)>>8))
    #writeCalibReg.main(Serial0,104,str(ADC1W2&0xFF))
    #writeCalibReg.main(Serial0,105,str((ADC1W2&0xFF00)>>8))
    return()

#######################################################################

def calibStage3(GPort, SPI0, Serial0, FIFO_FULL, NWORD, NumEvt):

    writeCtrlReg.main(Serial0, 32, str(0x4f))
    writeCtrlReg.main(Serial0, 44, str(0xd))
    writeCtrlReg.main(Serial0, 46, str(0x10))

    S0,S1,S2,S3=computeS0123(GPort,SPI0,Serial0,FIFO_FULL,NWORD, NumEvt)

    ADC0W0=int(S1[0]+(65536-S0[0])) & 0xFFFF
    ADC0W2=int(S2[0]+(65536-S3[0])) & 0xFFFF
    ADC1W0=int(S1[1]+(65536-S0[1])) & 0xFFFF
    ADC1W2=int(S2[1]+(65536-S3[1])) & 0xFFFF

    writeCalibReg.main(Serial0,6,str(ADC0W0&0xFF))
    writeCalibReg.main(Serial0,7,str((ADC0W0&0xFF00)>>8))
    writeCalibReg.main(Serial0,38,str(ADC0W2&0xFF))
    writeCalibReg.main(Serial0,39,str((ADC0W2&0xFF00)>>8))
    #writeCalibReg.main(Serial0,70,str(ADC1W0&0xFF))
    #writeCalibReg.main(Serial0,71,str((ADC1W0&0xFF00)>>8))
    #writeCalibReg.main(Serial0,102,str(ADC1W2&0xFF))
    #writeCalibReg.main(Serial0,103,str((ADC1W2&0xFF00)>>8))
    return()

#######################################################################

def calibStage2(GPort, SPI0, Serial0, FIFO_FULL, NWORD, NumEvt):

    writeCtrlReg.main(Serial0, 32, str(0x3f))
    writeCtrlReg.main(Serial0, 44, str(0x9))
    writeCtrlReg.main(Serial0, 46, str(0x10))

    S0,S1,S2,S3=computeS0123(GPort,SPI0,Serial0,FIFO_FULL,NWORD, NumEvt)

    ADC0W0=int(S1[0]+(65536-S0[0])) & 0xFFFF
    ADC0W2=int(S2[0]+(65536-S3[0])) & 0xFFFF
    ADC1W0=int(S1[1]+(65536-S0[1])) & 0xFFFF
    ADC1W2=int(S2[1]+(65536-S3[1])) & 0xFFFF

    writeCalibReg.main(Serial0,4,str(ADC0W0&0xFF))
    writeCalibReg.main(Serial0,5,str((ADC0W0&0xFF00)>>8))
    writeCalibReg.main(Serial0,36,str(ADC0W2&0xFF))
    writeCalibReg.main(Serial0,37,str((ADC0W2&0xFF00)>>8))
    #writeCalibReg.main(Serial0,68,str(ADC1W0&0xFF))
    #writeCalibReg.main(Serial0,69,str((ADC1W0&0xFF00)>>8))
    #writeCalibReg.main(Serial0,100,str(ADC1W2&0xFF))
    #writeCalibReg.main(Serial0,101,str((ADC1W2&0xFF00)>>8))
    return()

#######################################################################

def calibStage1(GPort, SPI0, Serial0, FIFO_FULL, NWORD, NumEvt):

    writeCtrlReg.main(Serial0, 32, str(0x2f))
    writeCtrlReg.main(Serial0, 44, str(0x5))
    writeCtrlReg.main(Serial0, 46, str(0x10))

    S0,S1,S2,S3=computeS0123(GPort,SPI0,Serial0,FIFO_FULL,NWORD, NumEvt)

    ADC0W0=int(S1[0]+(65536-S0[0])) & 0xFFFF
    ADC0W2=int(S2[0]+(65536-S3[0])) & 0xFFFF
    ADC1W0=int(S1[1]+(65536-S0[1])) & 0xFFFF
    ADC1W2=int(S2[1]+(65536-S3[1])) & 0xFFFF

    writeCalibReg.main(Serial0,2,str(ADC0W0&0xFF))
    writeCalibReg.main(Serial0,3,str((ADC0W0&0xFF00)>>8))
    writeCalibReg.main(Serial0,34,str(ADC0W2&0xFF))
    writeCalibReg.main(Serial0,35,str((ADC0W2&0xFF00)>>8))
    #writeCalibReg.main(Serial0,66,str(ADC1W0&0xFF))
    #writeCalibReg.main(Serial0,67,str((ADC1W0&0xFF00)>>8))
    #writeCalibReg.main(Serial0,98,str(ADC1W2&0xFF))
    #writeCalibReg.main(Serial0,99,str((ADC1W2&0xFF00)>>8))
    return()

#######################################################################

def calibStage0(GPort, SPI0, Serial0, FIFO_FULL, NWORD, NumEvt):

    writeCtrlReg.main(Serial0, 32, str(0x1f))
    writeCtrlReg.main(Serial0, 44, str(0x1))
    writeCtrlReg.main(Serial0, 46, str(0x10))

    S0,S1,S2,S3=computeS0123(GPort,SPI0,Serial0,FIFO_FULL,NWORD, NumEvt)

    ADC0W0=int(S1[0]+(65536-S0[0])) & 0xFFFF
    ADC0W2=int(S2[0]+(65536-S3[0])) & 0xFFFF
    ADC1W0=int(S1[1]+(65536-S0[1])) & 0xFFFF
    ADC1W2=int(S2[1]+(65536-S3[1])) & 0xFFFF

    writeCalibReg.main(Serial0,0,str(ADC0W0&0xFF))
    writeCalibReg.main(Serial0,1,str((ADC0W0&0xFF00)>>8))
    writeCalibReg.main(Serial0,32,str(ADC0W2&0xFF))
    writeCalibReg.main(Serial0,33,str((ADC0W2&0xFF00)>>8))
    #writeCalibReg.main(Serial0,64,str(ADC1W0&0xFF))
    #writeCalibReg.main(Serial0,65,str((ADC1W0&0xFF00)>>8))
    #writeCalibReg.main(Serial0,96,str(ADC1W2&0xFF))
    #writeCalibReg.main(Serial0,97,str((ADC1W2&0xFF00)>>8))
    return()

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
    spi0.max_speed_hz = 753000
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

    #readADC.resetCHIP(GPIO, FPGA_RESET)
    #readADC.resetCHIP(GPIO, ADC_RESET)

    #Number of words in FPGA FIFO
    NWORDFIFO=65536

    #ColdADC synchronization. Find ADC channel 0
    ADC0Num=3
    #ADC0Num=readADC.findADCch0(GPIO,spi0,ser,FPGA_FIFO_FULL,NWORDFIFO)
    #print("ADC0 Channel 0 = ",ADC0Num)


    #Number of reads per set (adjusted for different stages)
    NumSet=1
    #Use Variable NumSet for differnt stages (0=fixed to above NumSEt; 1=variable)
    VarNumSet=1

    #Verify both registers 9 and 50 are set to 0
    checkRegisters(ser)

    ##############################################
    # Calibrate ADC Stages 6 to 0
    ##############################################
    if VarNumSet !=0:
        #NumSet=2
        NumSet=5
    print("Calibrating Stage 6 with NumSet =",NumSet)
    calibStage6(GPIO,spi0,ser,FPGA_FIFO_FULL,NWORDFIFO,NumSet)
    if VarNumSet !=0:
        #NumSet=25
        NumSet=35
    print("Calibrating Stage 5 with NumSet =",NumSet)
    calibStage5(GPIO,spi0,ser,FPGA_FIFO_FULL,NWORDFIFO,NumSet)
    if VarNumSet !=0:
        #NumSet=35
        NumSet=45
    print("Calibrating Stage 4 with NumSet =",NumSet)
    calibStage4(GPIO,spi0,ser,FPGA_FIFO_FULL,NWORDFIFO,NumSet)
    if VarNumSet !=0:
        #NumSet=45
        NumSet=55
    print("Calibrating Stage 3 with NumSet =",NumSet)
    calibStage3(GPIO,spi0,ser,FPGA_FIFO_FULL,NWORDFIFO,NumSet)
    if VarNumSet !=0:
        #NumSet=60
        NumSet=80
    print("Calibrating Stage 2 with NumSet =",NumSet)
    calibStage2(GPIO,spi0,ser,FPGA_FIFO_FULL,NWORDFIFO,NumSet)
    if VarNumSet !=0:
        #NumSet=85
        NumSet=100
    print("Calibrating Stage 1 with NumSet =",NumSet)
    calibStage1(GPIO,spi0,ser,FPGA_FIFO_FULL,NWORDFIFO,NumSet)
    if VarNumSet !=0:
        #NumSet=110
        NumSet=150
    print("Calibrating Stage 0 with NumSet =",NumSet)
    calibStage0(GPIO,spi0,ser,FPGA_FIFO_FULL,NWORDFIFO,NumSet)




    #Exit GPIO cleanly
    GPIO.cleanup

    #Close serial port
    ser.close()

    #Close spi0
    spi0.close()

