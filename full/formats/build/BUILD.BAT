@echo off
path d:\bin
bcc -c -ml -a- -k- -O -r- -Z -G- -Id:\include REC.C > REC.LOG
if errorlevel 1 goto failed
bcc -c -ml -a- -k- -O -r- -Z -G- -Id:\include XOR.C > XOR.LOG
if errorlevel 1 goto failed
bcc -c -ml -a- -k- -O -r- -Z -G- -Id:\include FILES.C > FILES.LOG
if errorlevel 1 goto failed
bcc -c -ml -a- -k- -O -r- -Z -G- -Id:\include TICKS.C > TICKS.LOG
if errorlevel 1 goto failed
bcc -c -ml -a- -k- -O -r- -Z -G- -Id:\include NUMBER.C > NUMBER.LOG
if errorlevel 1 goto failed
bcc -c -ml -a- -k- -O -r- -Z -G- -Id:\include ABOUT.C > ABOUT.LOG
if errorlevel 1 goto failed
bcc -c -ml -a- -k- -O -r- -Z -G- -Id:\include CARDS.C > CARDS.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
