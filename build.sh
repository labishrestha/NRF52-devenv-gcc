#!/bin/bash

pkill openocd

if [[ "$1" == "debug" ]]; then
    make -C $MAKEPATH clean && make -C $MAKEPATH $TARGET flash \
    && (openocd -f $OPENOCD_INTERFACE -c "transport select swd" \
        -f $OPENOCD_TARGET > /dev/null 2>&1 &) \
    && arm-none-eabi-gdb -tui $OUTPATH/$TARGET.out
elif [[ "$1" == "debug-notui" ]]; then
    make -C $MAKEPATH clean && make -C $MAKEPATH $TARGET flash \
    && (openocd -f $OPENOCD_INTERFACE -c "transport select swd" \
        -f $OPENOCD_TARGET > /dev/null 2>&1 &) \
    && arm-none-eabi-gdb $OUTPATH/$TARGET.out
elif [[ "$1" == "openocd" ]]; then
		make -C $MAKEPATH clean && make -C $MAKEPATH $TARGET flash \
		&& (openocd -f $OPENOCD_INTERFACE -c "transport select swd" \
				-f $OPENOCD_TARGET > /dev/null 2>&1)
elif [[ "$1" == "flash" || "$1" == "f" ]]; then
    make -C $MAKEPATH clean && make -C $MAKEPATH $TARGET flash
		make -C $MAKEPATH clean
elif [[ "$1" == "boot" ]]; then
		if [ ! -d "$OUTPATH" ]; then
			# Control will enter here if $DIRECTORY doesn't exist.
			mkdir $OUTPATH
		fi
    make -C $BTLDR clean && make -C $BTLDR
    nrfjprog -e -f nrf52
		nrfjprog --program $SDHEX -f nrf52 --sectorerase
		nrfjprog --program $BOOTOUTFILE -f nrf52 --sectorerase
		nrfjprog --reset -f nrf52
elif [[ "$1" == "clean" ]]; then
	  make -C $MAKEPATH clean
		[ -e $DFU_FILE ] && rm $DFU_FILE
elif [[ "$1" == 'erase' ]]; then
    nrfjprog -e -f nrf52
else
    make -C $MAKEPATH clean && make -C $MAKEPATH $TARGET
fi
