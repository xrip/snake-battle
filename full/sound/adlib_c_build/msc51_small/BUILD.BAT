@echo off
path d:\bin
set INCLUDE=d:\include
set LIB=d:\lib
cl /c /AS /G2 /Gs /Zp /Oi /Os SMALL.C > SMALL.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
