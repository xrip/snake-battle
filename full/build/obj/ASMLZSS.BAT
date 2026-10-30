@echo off
path d:\bin
tasm /ml LZSS.ASM,LZSS.OBJ,LZSS.LST > ASMLZSS.LOG
if errorlevel 1 goto failed
echo OK > ASMOK.TXT
exit
:failed
echo FAILED > ASMOK.TXT
exit
