echo off

cls

:: PC with Lemongrass application installed on it needs CypherBase working with HostCrypt
:: simultainously, so 4_HostCryptAutorun_lemongrass varies from 4_HostCryptAutorun.bat in the point
:: that CypherBase isn't being deleted here.

:: Initial check replicates that in 4_HostCryptAutorun.bat to evade launching the program if it
:: already done the HostCrypt autostart some time ago.


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

ping -n 2 100.28.2.54


:: create flag that CypherBase is left here for Lemongrass

echo 1 > "C:\flags\CypherBase_for_lemongrass.flag"


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

echo %USERNAME% on %COMPUTERNAME% now has autostart HostCrypt 1.3 and CypherBase for Lemongrass> \\100.28.2.54\services\_installhostcrypt\reports\%USERNAME%_%COMPUTERNAME%_autostart_HostCrypt_1.3_and_lemongrass.txt


:: create flag about completed transformation

echo 1 > "C:\flags\HostCrypt_1.3_autostart.flag"



exit