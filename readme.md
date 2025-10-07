# rw2
Complete disassembly of the Japanese version of Mega Man II (Rockman World 2 / ロックマンワールド２ ) for the Game Boy.

## Building
This will build a bit-perfect ROM of the game, you can verify this by providing a ROM of the original game as "*original.gb*". `sha1: 088AA57BD14DCC5541DA81420D304C4419D1D186`.

To assemble, run one of the included batch scripts:
- **build-orig.cmd** for the unmodified version.
- **build-nojunk.cmd** for a version of the game without padding areas. Currently, it builds a version with cheats enabled.

## Special thanks to...
- lazigamer for the debug emulator I've used for every disassembly so far to generate the initial CDL
- Sun Rays, Forple and Pegmode for their work in [reverse engineering the "Rabbit GB" sound driver](https://github.com/SuperDisk/mm2conv).\
The songs in this disassembly reuse the same macros from theirs for compatibility.