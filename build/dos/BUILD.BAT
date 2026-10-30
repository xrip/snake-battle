@echo off
path d:\bin
bcc -ml -a- -k -O -r- -Z -G- -M -Id:\include -Ld:\lib -eGPFTEST.EXE GPFTEST.C GPFCODEC.C > GPFTEST.LOG
if errorlevel 1 goto failed
bcc -ml -a- -k -O -r- -Z -G- -M -Id:\include -Ld:\lib -eGPFBUILD.EXE GPFBUILD.C GPFCODEC.C > GPFBUILD.LOG
if errorlevel 1 goto failed
bcc -ml -a- -k -O -r- -Z -G- -M -Id:\include -Ld:\lib -eSNKRTEST.EXE SNKRTEST.C SNKREC.C > SNKRTEST.LOG
if errorlevel 1 goto failed
bcc -ml -a- -k -O -r- -Z -G- -M -Id:\include -Ld:\lib -eLOGICTST.EXE LOGICTST.C LOGIC.C > LOGICTST.LOG
if errorlevel 1 goto failed
GPFTEST INPUT\SNAKE.GPF > GPFTEST.OUT
if errorlevel 1 goto failed
GPFBUILD RES OUT\SNAKE.GPF > GPFBUILD.OUT
if errorlevel 1 goto failed
LOGICTST LOGIC.VEC > LOGICTST.OUT
if errorlevel 1 goto failed
SNKRTEST rec INPUT\ANTONY.REC OUT\ANTONY.REC >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\ANTONY.SNK OUT\ANTONY.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\CHORUS.SNK OUT\CHORUS.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST rec INPUT\HANTER.REC OUT\HANTER.REC >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\HANTER.SNK OUT\HANTER.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\IGOR_I.SNK OUT\IGOR_I.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST rec INPUT\JOKER.REC OUT\JOKER.REC >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\JOKER.SNK OUT\JOKER.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\OLEG.SNK OUT\OLEG.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\PAU1.SNK OUT\PAU1.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\PAU2.SNK OUT\PAU2.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\PAU3.SNK OUT\PAU3.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\PAU4.SNK OUT\PAU4.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST rec INPUT\REMBO.REC OUT\REMBO.REC >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\REMBO.SNK OUT\REMBO.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\SS-20.SNK OUT\SS-20.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST rec INPUT\SS.REC OUT\SS.REC >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\SUCKER.SNK OUT\SUCKER.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\TEST.SNK OUT\TEST.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
SNKRTEST snk INPUT\TRENTY.SNK OUT\TRENTY.SNK >> SNKREC.OUT
if errorlevel 1 goto failed
echo ALL_OK > RESULT.TXT
exit
:failed
echo FAILED > RESULT.TXT
exit
