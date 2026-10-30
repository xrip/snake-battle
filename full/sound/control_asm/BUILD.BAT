@echo off
path d:\bin
tasm /ml SNDIRQ.ASM,SNDIRQ.OBJ,SNDIRQ.LST > SNDIRQ.LOG
if errorlevel 1 goto failed
tasm /ml SNDWAIT.ASM,SNDWAIT.OBJ,SNDWAIT.LST > SNDWAIT.LOG
if errorlevel 1 goto failed
tasm /ml SNDMEM.ASM,SNDMEM.OBJ,SNDMEM.LST > SNDMEM.LOG
if errorlevel 1 goto failed
tasm /ml SNDTAIL.ASM,SNDTAIL.OBJ,SNDTAIL.LST > SNDTAIL.LOG
if errorlevel 1 goto failed
echo OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
