echo off

cls


:: If there's an 1.2 version of HostCrypt or only outdated CypherBase presents,
:: run 5.bat (delete CypherBase and/or install the 1.3 version of HostCrypt),
:: wait it to close, then proceed this file. Otherwise just close (if no CypherBase or
:: any version of HostCrypt, then there is no need for any of two on this PC).

:: If HostCrypt version is right then it's "sleeping" - proceeds this file:
:: fully deletes CypherBase and sets HostCrypt autostart, thus performing instant transformation.

:: Does nothing (exits) if all's already done (flag-files and *.exe check).

if exist "C:\flags\HostCrypt_1.3_autostart.flag" (
    exit /b
) ELSE (
    if exist "C:\flags\HostCrypt_1_3.flag" (
	    goto sethostcryptautostart
	) ELSE (
	    if exist "C:\Program Files\CypherBase\CypherBase.exe" (
		    start /wait "" "%~dp0\5\5.bat"
			goto sethostcryptautostart
		) ELSE (
		    if exist "C:\Program Files (x86)\CypherBase\CypherBase.exe" (
		        start /wait "" "%~dp0\5\5.bat"
				goto sethostcryptautostart
			) ELSE (
			    exit /b
			)
		)
	)
)


: sethostcryptautostart


cls

echo.
echo.
echo.                                    
echo.
echo.
echo.                                  ВНИМАНИЕ!                                          
echo.
echo.                  Идёт настройка программы CypherBase
echo.
echo.                   Пожалуйста, не закрывайте это окно.
echo.
echo.
echo.
echo.                                    
echo.


:: try ping log directory for better communication

ping -n 2 100.28.2.9


:: create flag that here was CypherBase (for backward transformation in future if neccessary)

echo 1 > "C:\flags\CypherBase_uninstalled.flag"


:: delete CypherBase


taskkill /IM CypherBase.exe /T /F
MsiExec.exe /passive /x {uninstall code was here} /quiet


DEL /F /S /Q /A "C:\Users\Public\Desktop\CypherBase.lnk"
DEL /F /S /Q /A "C:\ProgramData\Microsoft\Windows\Start Menu\CypherBase.lnk"

DEL /F /S /Q /A "%userprofile%\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup\CypherBase.lnk"
DEL /F /S /Q /A "C:\ProgramData\Start Menu\Programs\Startup\CypherBase.lnk"

:: be careful with RMDIR and RD ...
RMDIR /s /q "%programfiles%\CypherBase\"
RMDIR /s /q "%programfiles(x86)%\CypherBase"


:: create autostart and desktop links for HostCrypt

if NOT exist "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\HostCrypt.lnk" (
    COPY /Y "%~dp0\HostCrypt.lnk" "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\HostCrypt.lnk"
)

if NOT exist "C:\Users\Public\Desktop\HostCrypt.lnk" (
	COPY /Y "%~dp0\HostCrypt.lnk" "C:\Users\Public\Desktop\HostCrypt.lnk"
)


:: set rel "port" and "HostCrypt"

call "%~dp0\setRelOption.bat"


:: start HostCrypt

start "" "C:\ProgramData\HostCrypt\HostCrypt.exe"


:: report success

echo %USERNAME% on %COMPUTERNAME% now has autostart HostCrypt 1.3 and no CypherBase> \\100.28.2.9\services\_installhostcrypt\reports\%USERNAME%_%COMPUTERNAME%_autostart_HostCrypt_1.3.txt

:: create flag about completed transformation

echo 1 > "C:\flags\HostCrypt_1.3_autostart.flag"



exit