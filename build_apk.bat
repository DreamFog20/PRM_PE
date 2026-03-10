@echo off
echo ========================================
echo    BUILD APK - Quan ly San pham
echo ========================================
echo.

echo [1/4] Cleaning previous builds...
call flutter clean
echo.

echo [2/4] Getting dependencies...
call flutter pub get
echo.

echo [3/4] Building APK Release (Split per ABI)...
echo This may take 3-5 minutes...
call flutter build apk --release --split-per-abi
echo.

echo [4/4] Build completed!
echo.
echo ========================================
echo APK files location:
echo ========================================
echo.
dir /B build\app\outputs\flutter-apk\*.apk
echo.
echo Full path: %CD%\build\app\outputs\flutter-apk\
echo.
echo ========================================
echo Recommended file for most phones:
echo app-arm64-v8a-release.apk
echo ========================================
echo.
pause
