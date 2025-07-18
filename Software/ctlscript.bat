@echo off
rem START or STOP Services
rem ----------------------------------
rem Check if argument is STOP or START

if not ""%1"" == ""START"" goto stop

if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\hypersonic\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\server\hsql-sample-database\scripts\ctl.bat START)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\ingres\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\ingres\scripts\ctl.bat START)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\mysql\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\mysql\scripts\ctl.bat START)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\postgresql\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\postgresql\scripts\ctl.bat START)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\apache\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\apache\scripts\ctl.bat START)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\openoffice\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\openoffice\scripts\ctl.bat START)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\apache-tomcat\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\apache-tomcat\scripts\ctl.bat START)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\resin\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\resin\scripts\ctl.bat START)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\jetty\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\jetty\scripts\ctl.bat START)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\subversion\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\subversion\scripts\ctl.bat START)
rem RUBY_APPLICATION_START
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\lucene\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\lucene\scripts\ctl.bat START)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\third_application\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\third_application\scripts\ctl.bat START)
goto end

:stop
echo "Stopping services ..."
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\third_application\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\third_application\scripts\ctl.bat STOP)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\lucene\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\lucene\scripts\ctl.bat STOP)
rem RUBY_APPLICATION_STOP
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\subversion\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\subversion\scripts\ctl.bat STOP)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\jetty\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\jetty\scripts\ctl.bat STOP)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\hypersonic\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\server\hsql-sample-database\scripts\ctl.bat STOP)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\resin\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\resin\scripts\ctl.bat STOP)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\apache-tomcat\scripts\ctl.bat (start /MIN /B /WAIT C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\apache-tomcat\scripts\ctl.bat STOP)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\openoffice\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\openoffice\scripts\ctl.bat STOP)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\apache\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\apache\scripts\ctl.bat STOP)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\ingres\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\ingres\scripts\ctl.bat STOP)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\mysql\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\mysql\scripts\ctl.bat STOP)
if exist C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\postgresql\scripts\ctl.bat (start /MIN /B C:\Users\godwi\OneDrive\Desktop\sysfiles\Software\postgresql\scripts\ctl.bat STOP)

:end

