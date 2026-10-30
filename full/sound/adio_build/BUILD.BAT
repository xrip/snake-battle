@echo off
path d:\bin
tasm /ml ADIO.ASM,ADIO.OBJ,ADIO.LST > ADIO.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
