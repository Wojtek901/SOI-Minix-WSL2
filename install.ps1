$ErrorActionPreference = "Stop"
$TargetDir = "C:\SOI-Minix"

Write-Host "=== Instalator srodowiska SOI-Minix dla WSL2 ===" -ForegroundColor Cyan

# 1. Wykrywanie dostepnych archiwow dystrybucji w katalogu skryptu
$Archives = @(Get-ChildItem -Path $PSScriptRoot -Filter "*.tar*")

if ($Archives.Count -eq 0) {
    Write-Host "[BLAD] Nie znaleziono pliku obrazu (.tar lub .tar.gz) w folderze instalatora!" -ForegroundColor Red
    exit 1
} elseif ($Archives.Count -eq 1) {
    $SelectedArchive = $Archives[0]
    Write-Host "[INFO] Wykryto obraz: $($SelectedArchive.Name)" -ForegroundColor Yellow
} else {
    Write-Host "Wykryto wiecej niz jeden wariant srodowiska. Wybierz wersje do instalacji:" -ForegroundColor Yellow
    for ($i = 0; $i -lt $Archives.Count; $i++) {
        $SizeMB = [math]::Round($Archives[$i].Length / 1MB, 1)
        Write-Host "  [$($i + 1)] $($Archives[$i].Name) ($SizeMB MB)"
    }
    $Choice = Read-Host "Podaj numer wybranej wersji (1-$($Archives.Count))"
    $SelectedArchive = $Archives[[int]$Choice - 1]
}

# Ustalenie nazwy dystrybucji na podstawie wybranego pliku
if ($SelectedArchive.Name -match "debian") {
    $DistroName = "SOI-Minix-Debian"
} else {
    $DistroName = "SOI-Minix-Ubuntu"
}

# 2. Kopiowanie jadra bzImage
New-Item -ItemType Directory -Force -Path "$TargetDir\$DistroName" | Out-Null
Copy-Item -Path "$PSScriptRoot\bzImage" -Destination "$TargetDir\bzImage" -Force
Write-Host "[1/4] Skopiowano jadro Linuksa z obsluga systemu plikow Minix." -ForegroundColor Green

# 3. Konfiguracja pliku .wslconfig
$WslConfigPath = "$env:USERPROFILE\.wslconfig"
if (Test-Path $WslConfigPath) {
    Copy-Item -Path $WslConfigPath -Destination "$WslConfigPath.bak" -Force
    Write-Host "[INFO] Utworzono kopie zapasowa istniejacego pliku .wslconfig.bak" -ForegroundColor Yellow
}
"[wsl2]`r`nkernel=C:\\SOI-Minix\\bzImage" | Set-Content -Path $WslConfigPath -Encoding ASCII
Write-Host "[2/4] Zaktualizowano plik $WslConfigPath." -ForegroundColor Green

# 4. Import wybranej pseudodystrybucji
wsl --shutdown
Write-Host "[3/4] Importowanie $DistroName z pliku $($SelectedArchive.Name)..." -ForegroundColor Cyan
wsl --import $DistroName "$TargetDir\$DistroName" $SelectedArchive.FullName --version 2

Write-Host "[4/4] Instalacja zakonczona pomyslnie!" -ForegroundColor Green
Write-Host "Aby uruchomic srodowisko, wpisz w terminalu: wsl -d $DistroName" -ForegroundColor Yellow