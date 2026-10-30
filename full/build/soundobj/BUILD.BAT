@echo off
path d:\bin
tasm /ml /m3 SNDSRC.ASM,SNDSRC.OBJ,SNDSRC.LST > SNDSRC.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
