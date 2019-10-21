#!/usr/bin/env python

import time
import serial
import sys

ser=serial.Serial(
    port='/dev/ttyUSB0',
    baudrate=9600,
    parity=serial.PARITY_NONE,
    stopbits=serial.STOPBITS_TWO,
    bytesize=serial.EIGHTBITS,
    timeout=1
    )

newVoltage="OFFS"+sys.argv[1]+"\n"
ser.write(newVoltage)
infoLine="Setting offset voltage to "+sys.argv[1]+" V"
print(infoLine)

    
