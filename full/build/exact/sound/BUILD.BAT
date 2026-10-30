@echo off
path d:\bin
tasm /ml /m3 /l SNDSRC.ASM > SNDSRC.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
