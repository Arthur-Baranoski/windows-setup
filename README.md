# windows-setup

Script PowerShell automatizado para instalar programas em Windows via `winget`. Execute com um comando simples.

## Como usar

### Metodo 1: Comando direto (Recomendado)

Abra o **PowerShell como Administrador** e execute:

```powershell
irm bit.ly/windows-setup | iex
```

### Metodo 2: Baixar e executar

1. Baixe o arquivo `install.ps1`
2. Abra PowerShell como Administrador
3. Execute: `& 'C:\Caminho\install.ps1'`

## O que sera instalado

O script instala automaticamente:

- Google Chrome
- AnyDesk
- 7-Zip
- VLC Media Player
- Notepad++

## Como customizar

Edite o arquivo `install.ps1` e adicione/remova programas na secao `$apps`:

```powershell
$apps = @(
    @{ Name = "Nome do Programa"; Id = "ID.Do.Winget" },
    # Adicione mais linhas conforme necessario
)
```

Para encontrar o ID correto de um programa, use:

```powershell
winget search "nome do programa"
```

## Requisitos

- Windows 10 ou superior
- PowerShell 5.0+
- Winget instalado (vem padrao no Windows 11)
- Acesso de Administrador

## Recursos

- Verificacao automatica se os programas ja estao instalados
- Instalacao silenciosa e desatendida
- Resumo no final com sucesso/falhas
- Tratamento de erros

## Troubleshooting

### "Winget nao encontrado"
Atualize Windows Store ou instale o App Installer.

### "Nao tem permissao de Administrador"
Abra PowerShell como Administrador antes de executar.

### Alguns programas nao instalaram
Alguns IDs de winget podem variar. Use `winget search` para confirmar o ID correto.

## Licenca

MIT License

## Autor

[Arthur-Baranoski](https://github.com/Arthur-Baranoski)
