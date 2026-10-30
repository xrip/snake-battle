@echo off
d:\bin\tlink /m /s @LINK.RSP > LINK.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
