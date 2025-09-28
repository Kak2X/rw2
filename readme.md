# rw2
Disassembly of the Japanese version of Mega Man II (Rockman World 2 / ロックマンワールド２ ) for the Game Boy.

## Building
This will build a bit-perfect ROM of the game, you can verify this by providing a ROM of the original game as "*original.gb*". `sha1: 088AA57BD14DCC5541DA81420D304C4419D1D186`.

To assemble, run one of the included batch scripts:
- **build-orig.cmd** for the unmodified version.
- **build-nojunk.cmd** for a version of the game without padding areas. Currently, it builds a version with cheats enabled.

## Todo
- The sound driver is currently not documented at all, but it shouldn't matter much given you really should replace it [with something else](https://github.com/Kak2X/opsnd) that has [actual tooling](https://github.com/Kak2X/suntool).
- Outside of the sound driver, code and data is all documented but not fully split up from the `src/bank*.asm` files yet.

