# ==========================
# Windows Setup - Menu Interativo
# ==========================
# Uso: irm https://raw.githubusercontent.com/Arthur-Baranoski/windows-setup/main/install.ps1 | iex

function Show-MainMenu {
    Clear-Host
    Write-Host "" 
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║   WINDOWS SETUP - Menu Principal       ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "1 = Ativar Windows (Windows Activator)" -ForegroundColor Yellow
    Write-Host "2 = Instalar Programas" -ForegroundColor Yellow
    Write-Host "0 = Sair" -ForegroundColor Gray
    Write-Host ""
}

function Show-AppsMenu {
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Green
    Write-Host "║   Selecione os Programas              ║" -ForegroundColor Green
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Green
    Write-Host ""
    Write-Host "1 = Google Chrome" -ForegroundColor White
    Write-Host "2 = AnyDesk" -ForegroundColor White
    Write-Host "3 = Lightshot" -ForegroundColor White
    Write-Host "4 = 7-Zip" -ForegroundColor White
    Write-Host "5 = VLC Media Player" -ForegroundColor White
    Write-Host "6 = Notepad++" -ForegroundColor White
    Write-Host "0 = Voltar" -ForegroundColor Gray
    Write-Host ""
}

function Test-AdminPrivilege {
    if (-not ([Security.Principal.WindowsPrincipal] `
        [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)) {
        Write-Host ""
        Write-Host "[ERRO] Este script requer permissoes de Administrador!" -ForegroundColor Red
        Write-Host "Execute o PowerShell como Administrador e tente novamente." -ForegroundColor Yellow
        Write-Host ""
        pause
        exit 1
    }
}

function Test-Winget {
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host ""
        Write-Host "[ERRO] Winget nao encontrado!" -ForegroundColor Red
        Write-Host "Atualize o Windows Store ou instale o App Installer." -ForegroundColor Yellow
        Write-Host ""
        pause
        exit 1
    }
}

function Invoke-WindowsActivation {
    Write-Host ""
    Write-Host "[INFO] Executando Windows Activator..." -ForegroundColor Cyan
    Write-Host ""
    irm https://get.activated.win | iex
}

function Install-SelectedApps([array]$selections) {
    Clear-Host
    Write-Host ""
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║   Instalando Programas Selecionados    ║" -ForegroundColor Magenta
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host ""

    $apps = @{
        "1" = @{ Name = "Google Chrome"; Id = "Google.Chrome" }
        "2" = @{ Name = "AnyDesk"; Id = "AnyDeskSoftwareGmbH.Anydesk" }
        "3" = @{ Name = "Lightshot"; Id = "Skillbrains.Lightshot" }
        "4" = @{ Name = "7-Zip"; Id = "7zip.7zip" }
        "5" = @{ Name = "VLC Media Player"; Id = "VideoLAN.VLC" }
        "6" = @{ Name = "Notepad++"; Id = "Notepad++.Notepad++" }
    }

    $installed = 0
    $failed = 0

    foreach ($selection in $selections) {
        if ($selection -eq "0" -or -not $apps.ContainsKey($selection)) { continue }
        
        $app = $apps[$selection]
        Write-Host "[VERIFICANDO] $($app.Name)..." -ForegroundColor Cyan
        
        $check = winget list --id $app.Id --exact 2>$null
        
        if ($LASTEXITCODE -eq 0 -and $check) {
            Write-Host "[OK] $($app.Name) ja esta instalado" -ForegroundColor DarkGreen
            continue
        }
        
        Write-Host "[INSTALANDO] $($app.Name)..." -ForegroundColor Yellow
        winget install --id $app.Id --exact --silent `
            --accept-package-agreements --accept-source-agreements 2>$null
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[+] $($app.Name) instalado com sucesso" -ForegroundColor Green
            $installed++
        } else {
            Write-Host "[-] Falha ao instalar $($app.Name)" -ForegroundColor Red
            $failed++
        }
    }
    
    Write-Host ""
    Write-Host "╔════════════════════════════════════════╗" -ForegroundColor Magenta
    Write-Host "║   Resumo da Instalacao                 ║" -ForegroundColor Magenta
    Write-Host "╚════════════════════════════════════════╝" -ForegroundColor Magenta
    Write-Host "Instalados: $installed" -ForegroundColor Green
    Write-Host "Falharam: $failed" -ForegroundColor Red
    Write-Host ""
    pause
}

# Principal
Test-AdminPrivilege
Test-Winget

do {
    Show-MainMenu
    $mainChoice = Read-Host "Escolha uma opcao"
    
    switch ($mainChoice) {
        "1" {
            Write-Host ""
            Write-Host "Ativando Windows..." -ForegroundColor Yellow
            Write-Host ""
            Start-Sleep -Seconds 2
            Invoke-WindowsActivation
        }
        "2" {
            $selectedApps = @()
            do {
                Show-AppsMenu
                $appChoice = Read-Host "Escolha um programa"
                
                if ($appChoice -eq "0") { break }
                if ($appChoice -match "^[1-6]$") {
                    if ($selectedApps -notcontains $appChoice) {
                        $selectedApps += $appChoice
                        Write-Host ""
                        Write-Host "[+] Programa $appChoice adicionado a lista" -ForegroundColor Green
                        Write-Host ""
                        Start-Sleep -Seconds 1
                    } else {
                        Write-Host ""
                        Write-Host "[!] Este programa ja foi selecionado" -ForegroundColor Yellow
                        Write-Host ""
                        Start-Sleep -Seconds 1
                    }
                } else {
                    Write-Host ""
                    Write-Host "[ERRO] Opcao invalida!" -ForegroundColor Red
                    Write-Host ""
                    Start-Sleep -Seconds 1
                }
            } while ($true)
            
            if ($selectedApps.Count -gt 0) {
                Install-SelectedApps $selectedApps
            } else {
                Write-Host "[INFO] Nenhum programa foi selecionado." -ForegroundColor Yellow
                pause
            }
        }
        "0" {
            Write-Host ""
            Write-Host "[BYE] Encerrando..." -ForegroundColor Cyan
            Write-Host ""
            exit 0
        }
        default {
            Write-Host ""
            Write-Host "[ERRO] Opcao invalida!" -ForegroundColor Red
            Write-Host ""
            Start-Sleep -Seconds 2
        }
    }
} while ($true)
