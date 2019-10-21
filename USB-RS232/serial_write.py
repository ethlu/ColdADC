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
ser.write('FUNC0\n')
time.sleep(1)
ser.write('FREQ10000\n')
time.sleep(1)
ser.write('FREQ20000\n')
time.sleep(1)
ser.write('FREQ30000\n')
time.sleep(1)
ser.write('FREQ40000\n')
time.sleep(1)
ser.write('FREQ50000\n')
time.sleep(1)
ser.write('FREQ50000;FUNC1\n')
#    counter += 1



    
