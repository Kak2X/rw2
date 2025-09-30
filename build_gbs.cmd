@echo off
call _build config_gbs gbs -nofix

if %ERRORLEVEL% neq 0 goto end

echo Generating GBS...
rem 16240 -> 3F70, 112 -> 70 see player\gbs.asm
rgbds\dd bs=112 if=gbs.gb of=tmp_a.bin count=1
rgbds\dd bs=16240 if=gbs.gb of=tmp_b.bin skip=1
copy /b tmp_a.bin + tmp_b.bin rw2.gbs
del tmp_a.bin
del tmp_b.bin
del gbs.gb
del gbs.map
del gbs.o
del gbs.sym

:end
pause