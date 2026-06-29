# Mekanx - Flutter SDK Setup and Project Configuration Script
# This script installs Flutter to the user profile, sets PATH, and initializes project native folders.

$ErrorActionPreference = "Stop"

$installDir = "C:\Users\Mustafa\flutter"
$binDir = "$installDir\bin"

Write-Host "1. Checking Flutter SDK installation..." -ForegroundColor Cyan

if (Test-Path $installDir) {
    Write-Host "[OK] Flutter installation already exists in $installDir." -ForegroundColor Green
} else {
    Write-Host "[INFO] Cloning Flutter SDK from GitHub (this may take a few minutes)..." -ForegroundColor Yellow
    git clone https://github.com/flutter/flutter.git -b stable $installDir --depth 1
    Write-Host "[OK] Flutter cloned successfully." -ForegroundColor Green
}

Write-Host "2. Updating PATH Environment Variable..." -ForegroundColor Cyan

$userPath = [Environment]::GetEnvironmentVariable("Path", "User")
if ($userPath -split ';' -contains $binDir) {
    Write-Host "[OK] Flutter bin path is already in PATH." -ForegroundColor Green
} else {
    $newPath = $userPath + ";$binDir"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    $env:Path = $env:Path + ";$binDir"
    Write-Host "[OK] Flutter bin path added to User PATH successfully." -ForegroundColor Green
    Write-Host "[INFO] NOTE: You may need to restart your VS Code/terminal for PATH changes to take effect." -ForegroundColor Yellow
}

Write-Host "3. Triggering initial Flutter setup and native project creation..." -ForegroundColor Cyan

& "$binDir\flutter.bat" doctor

Write-Host "[INFO] Creating native platform folders (android, ios, web)..." -ForegroundColor Yellow
& "$binDir\flutter.bat" create --overwrite .

Write-Host "[OK] Process completed! Your project is ready." -ForegroundColor Green
Write-Host "To run the app: flutter run -d chrome" -ForegroundColor Cyan
