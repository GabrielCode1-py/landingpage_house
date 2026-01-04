# Script para iniciar HOUSE Alimentos no ar
Write-Host "🚀 Iniciando HOUSE Alimentos..." -ForegroundColor Green

# 1. Iniciar Flask em segundo plano
Write-Host "`n📦 Iniciando Flask..." -ForegroundColor Cyan
$flaskJob = Start-Job -ScriptBlock {
    Set-Location "C:\Users\Gabriel Batista\OneDrive\Desktop\landingpage_house"
    & ".\.venv\Scripts\python.exe" "app.py"
}

Start-Sleep -Seconds 3

# 2. Iniciar Cloudflare Tunnel
Write-Host "☁️  Conectando Cloudflare Tunnel..." -ForegroundColor Cyan
Set-Location "C:\Users\Gabriel Batista\OneDrive\Desktop\landingpage_house"
.\cloudflared.exe tunnel run house-alimentos
