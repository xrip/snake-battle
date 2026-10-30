@echo off
path d:\bin
set INCLUDE=d:\include
set LIB=d:\lib
hdpmi32 -r
cl /c /AS /G2 /Gs /Ox /Zp1 SOUND.C > SOUND.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
