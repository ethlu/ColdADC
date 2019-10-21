# Values set for LN2 temperature

# Enable CMOS reference and single-ended-to differential
./coldADC_writeCtrlReg.py 0 0b01100010

# Disable BJT and enable CMOS
./coldADC_writeCtrlReg.py 19 0b100

# Setting VREFP, VREFN, VCMO, VCMI voltages
## FOR VDDA=2.35V; VREFP/N clamped by +/- 100mV
## Keysight front panel reading is 2.38V
./coldADC_writeCtrlReg.py 24 0xbe
./coldADC_writeCtrlReg.py 25 0x30
./coldADC_writeCtrlReg.py 26 0x77
./coldADC_writeCtrlReg.py 27 0x62



# Nominal CMOS refernce bias current adjust for LN2
./coldADC_writeCtrlReg.py 23 0x20

# Using CMOS with internal R
# Trim setting 101 --> ~50uA of current
./coldADC_writeCtrlReg.py 28 0b10101

# Setting ADC bias current to ~50uA
./coldADC_writeCtrlReg.py 8 0b1011

# Reset FPGA
./coldADC_resetFPGA.py


