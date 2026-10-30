@echo off
path d:\bin
tasm /ml ADLIB.ASM,ADLIB.OBJ,ADLIB.LST > ADLIB.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
