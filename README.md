# μChronos #
_The slim Firmware for the ez430 Chronos Development watch_

## Current Features: ##
+ Small / Simple LCD API
+ Utilizing Internal RTC
+ Battery sensing

## Planned features: ##
+ All the features implemented by open chronos

## To build: ##
### Requirments: ###
+ uniarc mspgcc
+ mspdebug
+ ez430 FET

### Building ###
`make clean` Remove build files.
`make all` Compile uChronos.elf
`make prog` Program using rf2500 through mspdebug

