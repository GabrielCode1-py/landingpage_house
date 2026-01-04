# 🚀 Configuração Final - housealimentoss.com.br
# Execute DEPOIS de alterar os nameservers no Registro.br

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  CLOUDFLARE TUNNEL - housealimentoss.com.br" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$DOMINIO = "housealimentoss.com.br"
$cloudflaredPath = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Cloudflare.cloudflared*\cloudflared.exe" | Select-Object -First 1 -ExpandProperty FullName

# PASSO 1: Login Cloudflare
Write-Host "[PASSO 1/4] Fazer login no Cloudflare..." -ForegroundColor Yellow
Write-Host ""
Write-Host "Uma página do navegador vai abrir" -ForegroundColor White
Write-Host "Faça login e autorize o cloudflared" -ForegroundColor Cyan
Write-Host ""
Read-Host "Pressione ENTER para continuar"

& $cloudflaredPath tunnel login

$certPath = "$env:USERPROFILE\.cloudflared\cert.pem"
if (-not (Test-Path $certPath)) {
    Write-Host ""
    Write-Host "⚠️  Se o navegador baixou 'cert.pem', mova para:" -ForegroundColor Yellow
    Write-Host "$certPath" -ForegroundColor Cyan
    Write-Host ""
    Read-Host "Pressione ENTER após mover o arquivo (ou se já está lá)"
}

Write-Host ""
Write-Host "✅ Login concluído!" -ForegroundColor Green

# PASSO 2: Criar Tunnel
Write-Host ""
Write-Host "[PASSO 2/4] Criar tunnel..." -ForegroundColor Yellow
Write-Host ""

& $cloudflaredPath tunnel create house-alimentos

Write-Host ""
Write-Host "✅ Tunnel criado!" -ForegroundColor Green

# PASSO 3: Configurar DNS
Write-Host ""
Write-Host "[PASSO 3/4] Configurar DNS..." -ForegroundColor Yellow
Write-Host ""

Write-Host "Criando registro para $DOMINIO..." -ForegroundColor White
& $cloudflaredPath tunnel route dns house-alimentos $DOMINIO

Write-Host ""
Write-Host "Criando registro para www.$DOMINIO..." -ForegroundColor White
& $cloudflaredPath tunnel route dns house-alimentos "www.$DOMINIO"

Write-Host ""
Write-Host "✅ DNS configurado!" -ForegroundColor Green

# PASSO 4: Arquivo de configuração
Write-Host ""
Write-Host "[PASSO 4/4] Criando configuração..." -ForegroundColor Yellow
Write-Host ""

$tunnelId = (Get-ChildItem "$env:USERPROFILE\.cloudflared\*.json" -ErrorAction SilentlyContinue | Where-Object { $_.Name -ne "config.json" -and $_.Name -ne "cert.json" } | Select-Object -First 1).BaseName

if ($tunnelId) {
    $configContent = @"
tunnel: $tunnelId
credentials-file: $env:USERPROFILE\.cloudflared\$tunnelId.json

ingress:
  - hostname: $DOMINIO
    service: http://localhost:5000
  - hostname: www.$DOMINIO
    service: http://localhost:5000
  - service: http_status:404
"@

    $configPath = "$env:USERPROFILE\.cloudflared\config.yml"
    $configContent | Out-File -FilePath $configPath -Encoding UTF8
    Write-Host "✅ Configuração salva!" -ForegroundColor Green
}

# Script de inicialização
$startScript = @"
# Inicia HOUSE Alimentos - housealimentoss.com.br

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HOUSE Alimentos - Iniciando" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Para processos anteriores
Get-Process python -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Inicia Flask
Write-Host "[1/2] Iniciando Flask..." -ForegroundColor Yellow
`$flaskProcess = Start-Process -FilePath ".\.venv\Scripts\python.exe" -ArgumentList "app.py" -PassThru -WindowStyle Hidden
Start-Sleep -Seconds 3

# Inicia Cloudflare Tunnel
Write-Host "[2/2] Conectando tunnel..." -ForegroundColor Yellow
Write-Host ""

`$cloudflaredPath = Get-ChildItem "`$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Cloudflare.cloudflared*\cloudflared.exe" | Select-Object -First 1 -ExpandProperty FullName

Write-Host "========================================" -ForegroundColor Green
Write-Host "  ✅ SITE NO AR!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Seu site:" -ForegroundColor White
Write-Host "  https://housealimentoss.com.br" -ForegroundColor Cyan
Write-Host "  https://www.housealimentoss.com.br" -ForegroundColor Cyan
Write-Host ""
Write-Host "Pressione Ctrl+C para parar" -ForegroundColor Yellow
Write-Host ""

# Salva PID
`$flaskProcess.Id | Out-File -FilePath ".flask_pid.txt"

# Executa tunnel
& `$cloudflaredPath tunnel run house-alimentos

# Cleanup
if (Test-Path ".flask_pid.txt") {
    `$pid = Get-Content ".flask_pid.txt"
    Stop-Process -Id `$pid -Force -ErrorAction SilentlyContinue
    Remove-Item ".flask_pid.txt" -Force
}
"@

$startScript | Out-File -FilePath "iniciar_site.ps1" -Encoding UTF8

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  🎉 TUDO PRONTO!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Nameservers alterados:" -ForegroundColor White
Write-Host "  ✅ kayleigh.ns.cloudflare.com" -ForegroundColor Green
Write-Host "  ✅ piers.ns.cloudflare.com" -ForegroundColor Green
Write-Host ""
Write-Host "Aguarde 2-24h para DNS propagar" -ForegroundColor Yellow
Write-Host ""
Write-Host "Para iniciar o site:" -ForegroundColor White
Write-Host "  .\iniciar_site.ps1" -ForegroundColor Cyan
Write-Host ""
Write-Host "Para testar se está ativo:" -ForegroundColor White
Write-Host "  nslookup housealimentoss.com.br" -ForegroundColor Cyan
Write-Host ""
