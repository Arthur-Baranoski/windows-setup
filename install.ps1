# ==========================
# Windows Setup Installation Script
# ==========================
# Usage: irm https://raw.githubusercontent.com/Arthur-Baranoski/windows-setup/main/install.ps1 | iex

# Verifica se esta como administrador
if (-not ([Security.Principal.WindowsPrincipal] `
    [Security.Principal.WindowsIdentity]::GetCurrent()
).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
    Write-Host "Execute o PowerShell como Administrador e rode o comando novamente." -ForegroundColor Yellow
    exit 1
}

# Garante que o winget existe
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Winget nao encontrado. Atualize o Windows/loja antes de usar este script." -ForegroundColor Red
    exit 1
}

Write-Host "=== Windows Setup - Instalador de Programas ===" -ForegroundColor Cyan
Write-Host ""

# Lista de programas (IDs do winget)
$apps = @(
    @{ Name = "Google Chrome"; Id = "Google.Chrome" },
    @{ Name = "AnyDesk"; Id = "AnyDeskSoftwareGmbH.Anydesk" },
    @{ Name = "7-Zip"; Id = "7zip.7zip" },
    @{ Name = "VLC Media Player"; Id = "VideoLAN.VLC" },
    @{ Name = "Notepad++"; Id = "Notepad++.Notepad++" }
)

$installed = 0
$failed = 0

foreach ($app in $apps) {
    Write-Host "Verificando $($app.Name)..." -ForegroundColor Cyan
    $check = winget list --id $app.Id --exact 2>$null

    if ($LASTEXITCODE -eq 0 -and $check) {
        Write-Host "[OK] Ja instalado: $($app.Name)" -ForegroundColor DarkGray
        continue
    }

    Write-Host "  -> Instalando: $($app.Name)..." -ForegroundColor Green
    winget install --id $app.Id `
        --exact `
        --silent `
        --accept-package-agreements `
        --accept-source-agreements 2>$null

    if ($LASTEXITCODE -eq 0) {
        Write-Host "  [+] Instalado com sucesso: $($app.Name)" -ForegroundColor Green
        $installed++
    } else {
        Write-Host "  [-] Falha ao instalar $($app.Name)" -ForegroundColor Red
        $failed++
    }
}

Write-Host ""
Write-Host "=== Resumo ===" -ForegroundColor Magenta
Write-Host "Instalados com sucesso: $installed" -ForegroundColor Green
Write-Host "Falharam: $failed" -ForegroundColor Red
Write-Host "Rotina finalizada." -ForegroundColor Magenta
Write-Host ""
