# Quick Build Script for PRM PT2 App

Write-Host "========================================"  -ForegroundColor Cyan
Write-Host "   BUILD APK - Quan ly San pham" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Write-Host "[1/3] Cleaning..." -ForegroundColor Yellow
flutter clean | Out-Null
Write-Host "Done!" -ForegroundColor Green
Write-Host ""

Write-Host "[2/3] Getting dependencies..." -ForegroundColor Yellow
flutter pub get
Write-Host ""

Write-Host "[3/3] Building APK..." -ForegroundColor Yellow
Write-Host "This may take 3-5 minutes on first build..." -ForegroundColor Gray
flutter build apk --release

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "   BUILD SUCCESSFUL!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "APK Location:" -ForegroundColor Cyan
    Write-Host "build\app\outputs\flutter-apk\app-release.apk" -ForegroundColor White
    Write-Host ""
    Write-Host "File size:" -ForegroundColor Cyan
    $apk = Get-Item "build\app\outputs\flutter-apk\app-release.apk" -ErrorAction SilentlyContinue
    if ($apk) {
        $sizeMB = [math]::Round($apk.Length / 1MB, 2)
        Write-Host "$sizeMB MB" -ForegroundColor White
    }
} else {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "   BUILD FAILED!" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
}

Write-Host ""
Write-Host "Press any key to exit..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
