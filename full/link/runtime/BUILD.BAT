@echo off
path d:\bin
bcc -ml -a- -k -O -r- -Z -G- -c -Id:\include PROBE.C > COMPILE.LOG
if errorlevel 1 goto failed
tlink /m /s @PROBE.RSP > LINK.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
