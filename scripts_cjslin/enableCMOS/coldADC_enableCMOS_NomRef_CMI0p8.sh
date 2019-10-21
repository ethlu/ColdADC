# Values set for room temperature

# Enable CMOS reference and single-ended-to differential
./coldADC_writeCtrlReg.py 0 0b01100010

# Disable BJT and enable CMOS
./coldADC_writeCtrlReg.py 19 0b100

## FOR VDDA=2.50V ; nominal CMOS references
## Keysight front panel reading is 2.53V
# VCMO=1.20V; VCMI=0.8V
./coldADC_writeCtrlReg.py 24 0xcc
./coldADC_writeCtrlReg.py 25 0x2b
./coldADC_writeCtrlReg.py 26 0x7b
./coldADC_writeCtrlReg.py 27 0x50


# Nominal CMOS refernce bias current adjust 
./coldADC_writeCtrlReg.py 23 0x20

# Using CMOS with internal R
# Trim setting 101 --> ~50uA of current
./coldADC_writeCtrlReg.py 28 0b10101

# Setting ADC bias current to ~50uA
./coldADC_writeCtrlReg.py 8 0b1011

# Reset FPGA
#./coldADC_resetFPGA.py


