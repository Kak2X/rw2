# rw2
Complete disassembly of Mega Man II / Rockman World 2 / ロックマンワールド２ for the Game Boy.

## Building
This will build bit-perfect ROMs of the game, to assemble them run one of the included batch scripts:
- **build-jp.cmd** for the Japanese version. To verify this, provide a ROM named "*Rockman World 2 (Japan).gb*" as "*original-jp.gb*". `sha1: 088AA57BD14DCC5541DA81420D304C4419D1D186`
- **build-us.cmd** for the American version. To verify this, provide a ROM named "*Mega Man II (USA).gb*" as "*original-us.gb*". `sha1: 334F1A93346D55E1BE2967F0AF952E37AA52FCA7`
- **build-eu.cmd** for the European version. To verify this, provide a ROM named "*Mega Man II (Europe).gb*" as "*original-eu.gb*". `sha1: D19993A4630E7F9450FF6469115F4095F6F29667`
- **build-nojunk.cmd** for a version of the game without padding areas. Currently, it builds the Japanese version with cheats enabled.

## Special thanks to...
- lazigamer for the debug emulator I've used for every disassembly so far to generate the initial CDL
- Sun Rays, Forple and Pegmode for their work in [reverse engineering the "Rabbit GB" sound driver](https://github.com/SuperDisk/mm2conv).\
The songs in this disassembly reuse the same macros from theirs for compatibility.