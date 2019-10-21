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

counter=0

#while 1:
ser.write('FREQ205078\n')



    
