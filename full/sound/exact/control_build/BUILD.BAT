@echo off
path d:\bin
tasm /ml CONTROL.ASM,CONTROL.OBJ,CONTROL.LST > CONTROL.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
