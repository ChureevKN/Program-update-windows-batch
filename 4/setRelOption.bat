@echo off

:: Locates the file with important settings for third-party application and modifies it:
:: setting proper values for "CryptoApp" and "CryptoPort"

set "file=%userprofile%\AppData\Local\Relocator\rel.settings"

for /f "delims=" %%i in ('"type "%file%" & del "%file%""') do (
    for /f "delims==" %%j in ("%%i") do ((
        for /f "delims=" %%k in ('"(if %%j==CryptoApp (echo CryptoApp=HostCrypt) ELSE (if %%j==CryptoPort echo CryptoPort=1234))"') do echo %%k
    ) || echo.%%i) >> "%file%"
)
exit /b