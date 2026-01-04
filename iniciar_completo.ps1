# Script para iniciar HOUSE Alimentos no ar
Write-Host "🚀 Iniciando HOUSE Alimentos..." -ForegroundColor Green

# 1. Iniciar Flask em segundo plano
Write-Host "`n📦 Iniciando Flask..." -ForegroundColor Cyan
$flaskJob = Start-Job -ScriptBlock {
    Set-Location "C:\Users\Gabriel Batista\OneDrive\Desktop\landingpage_house"
    & ".\.venv\Scripts\python.exe" "app.py"
}

Start-Sleep -Seconds 5

# Verificar se Flask iniciou
try {
    $testResponse = Invoke-WebRequest -Uri "http://localhost:5000" -UseBasicParsing -TimeoutSec 3
    Write-Host "✅ Flask rodando na porta 5000" -ForegroundColor Green
} catch {
    Write-Host "❌ Flask não iniciou corretamente!" -ForegroundColor Red
    Write-Host "Verifique os logs do job:" -ForegroundColor Yellow
    Receive-Job -Job $flaskJob
    Stop-Job -Job $flaskJob -ErrorAction SilentlyContinue
    Remove-Job -Job $flaskJob -ErrorAction SilentlyContinue
    exit 1
}

Write-Host ""

# 2. Iniciar Cloudflare Tunnel
Write-Host "☁️  Conectando Cloudflare Tunnel..." -ForegroundColor Cyan
Write-Host "⚠️  Mantenha esta janela aberta!" -ForegroundColor Yellow
Write-Host ""
Set-Location "C:\Users\Gabriel Batista\OneDrive\Desktop\landingpage_house"
.\cloudflared.exe tunnel run house-alimentos
