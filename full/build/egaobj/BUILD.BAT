@echo off
path d:\bin
tasm /ml EGA.ASM,EGA.OBJ,EGA.LST > EGA.LOG
if errorlevel 1 goto failed
echo OK > ASMOK.TXT
exit
:failed
echo FAILED > ASMOK.TXT
exit
