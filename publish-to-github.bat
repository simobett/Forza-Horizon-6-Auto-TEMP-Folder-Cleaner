@echo off
setlocal EnableExtensions

where git >NUL 2>NUL
if errorlevel 1 (
    echo Git was not found.
    echo Install Git for Windows first:
    echo https://git-scm.com/download/win
    echo.
    pause
    exit /b 1
)

set "REMOTE_URL=%~1"

if not defined REMOTE_URL (
    echo Create an empty GitHub repository first, then paste its HTTPS URL here.
    echo Example: https://github.com/YOUR_USERNAME/forza6-temp-cleaner.git
    echo.
    set /P "REMOTE_URL=GitHub repo URL: "
)

if not defined REMOTE_URL (
    echo No GitHub repo URL provided.
    pause
    exit /b 1
)

git init
git add README.md LICENSE .gitignore clean-temp-after-forza.bat start-forza6-temp-cleaner-hidden.vbs publish-to-github.bat
git commit -m "Initial Forza 6 temp cleaner"
git branch -M main
git remote remove origin >NUL 2>NUL
git remote add origin "%REMOTE_URL%"
git push -u origin main

echo.
echo Done.
pause
