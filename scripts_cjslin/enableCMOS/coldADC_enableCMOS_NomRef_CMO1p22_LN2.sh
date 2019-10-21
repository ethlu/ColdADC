# Values set for LN2 temperature

# Enable CMOS reference and single-ended-to differential
./coldADC_writeCtrlReg.py 0 0b01100010

# Disable BJT and enable CMOS
./coldADC_writeCtrlReg.py 19 0b100

## FOR VDDA=2.35V ; nominal CMOS references
## Keysight front panel reading is 2.38V
# VCMO=1.20V
#./coldADC_writeCtrlReg.py 24 0xd5
#./coldADC_writeCtrlReg.py 25 0x30
#./coldADC_writeCtrlReg.py 26 0x82
#./coldADC_writeCtrlReg.py 27 0x62

# VCMO=1.22V
./coldADC_writeCtrlReg.py 24 0xd7
./coldADC_writeCtrlReg.py 25 0x32
./coldADC_writeCtrlReg.py 26 0x85
./coldADC_writeCtrlReg.py 27 0x62

# VCMO=1.24V
#./coldADC_writeCtrlReg.py 24 0xd9
#./coldADC_writeCtrlReg.py 25 0x34
#./coldADC_writeCtrlReg.py 26 0x87
#./coldADC_writeCtrlReg.py 27 0x62


# VCMO=1.25V
#./coldADC_writeCtrlReg.py 24 0xda
#./coldADC_writeCtrlReg.py 25 0x36
#./coldADC_writeCtrlReg.py 26 0x88
#./coldADC_writeCtrlReg.py 27 0x62


# VCMO=1.18V
#./coldADC_writeCtrlReg.py 24 0xd2
#./coldADC_writeCtrlReg.py 25 0x2e
#./coldADC_writeCtrlReg.py 26 0x80
#./coldADC_writeCtrlReg.py 27 0x62

# VCMO=1.16V
#./coldADC_writeCtrlReg.py 24 0xd0
#./coldADC_writeCtrlReg.py 25 0x2c
#./coldADC_writeCtrlReg.py 26 0x7e
#./coldADC_writeCtrlReg.py 27 0x62

# VCMO=1.15V
#./coldADC_writeCtrlReg.py 24 0xcf
#./coldADC_writeCtrlReg.py 25 0x2b
#./coldADC_writeCtrlReg.py 26 0x82
#./coldADC_writeCtrlReg.py 27 0x7d


# Nominal CMOS refernce bias current adjust for LN2
./coldADC_writeCtrlReg.py 23 0x20

# Using CMOS with internal R
# Trim setting 101 --> ~50uA of current
./coldADC_writeCtrlReg.py 28 0b10101

# Setting ADC bias current to ~50uA
./coldADC_writeCtrlReg.py 8 0b1011

# Reset FPGA
#./coldADC_resetFPGA.py


