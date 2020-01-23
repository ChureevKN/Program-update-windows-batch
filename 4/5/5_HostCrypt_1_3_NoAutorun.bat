echo off

cls


:: Check whether HostCrypt 1.3 version is already installed.
:: Detailed information can be seen in commentary at 4_HostCryptAutorun.bat and README.txt.

if exist "C:\flags\hostcrypt_1_3.flag" (
    if exist "C:\ProgramData\HostCrypt\HostCrypt.exe" (
        if NOT exist "\\100.28.2.9\services\_installhostcrypt\reports\%USERNAME%_%COMPUTERNAME%_1.3_withAllCertsAndConfig.txt" (
		    echo %USERNAME% on %COMPUTERNAME% now has HostCrypt 1.3 with all certs, with proper user settings > \\100.28.2.9\services^
\_installhostcrypt\reports\%USERNAME%_%COMPUTERNAME%_1.3_withAllCertsAndSettings.txt
		)
		exit /b
    ) ELSE (
        goto oldVersionOrNotInstalled
    )
) ELSE (
    goto oldVersionOrNotInstalled
)

: oldVersionOrNotInstalled



:::::::::::: check CypherBase, continue if exists

if exist "C:\Program Files\CypherBase\CypherBase.exe" (
    goto proceedinstall
) ELSE (
    if exist "C:\Program Files (x86)\CypherBase\CypherBase.exe" (
        goto proceedinstall
    ) ELSE (
        if exist "C:\ProgramData\HostCrypt\HostCrypt.exe" (
            goto proceedinstall
        ) ELSE (
            echo CypherBase or HostCrypt are not installed at %COMPUTERNAME%, user is %USERNAME% > \\100.28.2.9^
\services\_installhostcrypt\reports\%USERNAME%_%COMPUTERNAME%_thereisnoCypherBaseOrHostCrypt.txt
            exit /b
        )
    )
)

: proceedinstall



echo.
echo.
echo.                                    
echo.
echo.
echo.                                  ВНИМАНИЕ!                                          
echo.
echo.                  Идёт обновление программы CypherBase
echo.
echo.      Пожалуйста, не закрывайте это окно. Это займет несколько минут ...
echo.
echo.
echo.
echo.                                    
echo.


:: try ping log directory for better communication

ping -n 2 100.28.2.9



:::::::::::: close process, silent install HostCrypt 1.2, wait

taskkill /IM HostCrypt.exe /F

call "%~dp0\HostCryptSetup_1_2.exe" /S



:: remove autostart and desktop links for HostCrypt

DEL /F /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\HostCrypt.lnk"

DEL /F /S /Q "C:\Users\Public\Desktop\HostCrypt.lnk"



:: install certificates

certutil -addstore CA "%~dp0\toCA.cer"
certutil -addstore Root "%~dp0\toTrustedRoot.cer"

certutil -addstore CA "%~dp0\CRL1.crl"
certutil -addstore CA "%~dp0\CRL2.crl"

certutil -addstore Root "%~dp0\toRoot2-1.cer"
certutil -addstore Root "%~dp0\toRoot2-2.cer"
certutil -addstore Root "%~dp0\toRoot2-3.cer"
certutil -addstore Root "%~dp0\toRoot2-4.cer"

certutil -addstore CA "%~dp0\toCA2-1.cer"


:: remove old usersettings, so the 1.3 will read new usersettings file properly (be careful with RMDIR and RM)

RMDIR /S /Q "%USERPROFILE%\AppData\Local\CryptoDeveloper"



:::::::::::: silent install hostcrypt 1.3, wait

call "%~dp0\HostCryptSetup_1_3.exe" /S


:: remove autostart and desktop links for HostCrypt again

DEL /F /S /Q "C:\ProgramData\Microsoft\Windows\Start Menu\Programs\Startup\HostCrypt.lnk"

DEL /F /S /Q "C:\Users\Public\Desktop\HostCrypt.lnk"


:: fix the 1.3 usersettings.txt (step-by-step locate directory and create next, then copy usersettings)

CHDIR "%USERPROFILE%\AppData\Local"
MKDIR "CryptoDeveloper"
CHDIR "CryptoDeveloper"
MKDIR "HostCrypt"
CHDIR "HostCrypt"
MKDIR "1.3.0"

COPY /Y "%~dp0\usersettings.txt" "%USERPROFILE%\AppData\Local\CryptoDeveloper\HostCrypt\1.3.0\usersettings.txt"



:::::::::::: report success

echo %USERNAME% on %COMPUTERNAME% now has HostCrypt 1.3 with all certs, with proper user settings > \\100.28.2.9^
\services\_installhostcrypt\reports\%USERNAME%_%COMPUTERNAME%_1.3_withAllCertsAndSettings.txt


:: create flag about installed 1.3 version

echo 1 > "C:\flags\hostcrypt_1_3.flag"



exit