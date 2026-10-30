@echo off
path d:\bin
bcc -c -ml -a- -k- -O- -r- -Z- -G- -K -Id:\include GPF.C > GPF.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
