# SuperRobinHood ca65 rewrite

This is base repository for Super Robin Hood game rewritten to be compiled with ca65 assembler.

All source code and assets from this repository are licensed under the same licence as original source code.


# Usage

1. cc65 toolchain is needed in `PATH`
2. I use fceux as emulator

* `make` will generate `robin.nes` rom file which can be started in emulator
* `make emu` will start emulator with current `robin.nes` rom
* `make clean` will clean all created artifacts
