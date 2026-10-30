@echo off
path d:\bin
set INCLUDE=d:\include
set LIB=d:\lib
cl /c /AS /G2 /Gs /Oe /Ot /Zp1 ADLIB.C > ADLIB.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
