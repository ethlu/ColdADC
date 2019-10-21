#!/usr/bin/env python

import RPi.GPIO as GPIO
import time

GPIO.setmode(GPIO.BCM)
#GPIO.setmode(GPIO.BOARD)

#LED= GPIO pin number
LED = 14
GPIO.setup(LED,GPIO.OUT)
GPIO.output(LED,False)
time.sleep(1)
GPIO.output(LED,True)
time.sleep(1)
GPIO.output(LED,False)
time.sleep(1)
GPIO.output(LED,True)
time.sleep(1)
GPIO.output(LED,False)
time.sleep(1)
GPIO.output(LED,True)
time.sleep(1)
GPIO.output(LED,False)
time.sleep(1)
GPIO.output(LED,True)

