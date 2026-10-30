@echo off
path d:\bin
set INCLUDE=d:\include
set LIB=d:\lib
bcc -c -ml -a- -k- -O -r- -Z -G- -Id:\include SNDATA.C > SNDATA.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
