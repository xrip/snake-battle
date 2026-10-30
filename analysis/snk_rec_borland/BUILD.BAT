@echo off
rem Run with current directory containing snkrtest.c, snkrec.c, snkrec.h.
rem D:\BORLANDC contains the original Borland C++ 3.1 toolchain.
path d:\borlandc\bin
bcc -ml -a- -k -M -O -r- -Z -G- -Id:\borlandc\include -Ld:\borlandc\lib -ev6.exe snkrtest.c snkrec.c > v6.log
