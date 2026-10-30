@echo off
path d:\bin
set INCLUDE=d:\include
set LIB=d:\lib
hdpmi32 -r
cl /c /AM /G2 /Gs /Ox /Zp1 /NTSOUND_TEXT /Fc MIDISND.C > MIDISND.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
