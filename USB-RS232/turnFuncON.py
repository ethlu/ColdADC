#!/usr/bin/env python

import time
import serial

ser=serial.Serial(
    port='/dev/ttyUSB0',
    baudrate=9600,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_TWO,
    bytesize=serial.EIGHTBITS,
    timeout=1
    )


#ser.write('KEYS?\n')
ser.write('OUTE1\n')
time.sleep(0.5)
ser.write('OUTE?\n')
time.sleep(0.5)
x=ser.readline()
print "Freq On/Off State = ",x

    
