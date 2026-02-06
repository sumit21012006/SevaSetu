@echo off
echo ========================================
echo SevaSetu - Quick Test Script
echo ========================================
echo.

echo Step 1: Cleaning project...
call flutter clean
echo.

echo Step 2: Getting dependencies...
call flutter pub get
echo.

echo Step 3: Running on Chrome...
echo Opening app in Chrome browser...
echo.
start chrome --new-window http://localhost:8080
call flutter run -d chrome

pause
