# Script para iniciar HOUSE Alimentos no ar
Write-Host "🚀 Iniciando HOUSE Alimentos..." -ForegroundColor Green
Write-Host ""

# Limpar processos antigos
Write-Host "🧹 Limpando processos antigos..." -ForegroundColor Yellow
Get-Job | Where-Object {$_.Name -like "*Flask*"} | Remove-Job -Force -ErrorAction SilentlyContinue
Get-Process python -ErrorAction SilentlyContinue | Where-Object {$_.MainWindowTitle -eq ""} | Stop-Process -Force -ErrorAction SilentlyContinue
Get-Process cloudflared -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2
Write-Host "✅ Processos limpos" -ForegroundColor Green
Write-Host ""

# 1. Iniciar Flask em segundo plano
Write-Host "📦 Iniciando Flask..." -ForegroundColor Cyan
$flaskJob = Start-Job -Name "FlaskHouseAlimentos" -ScriptBlock {
    Set-Location "C:\Users\Gabriel Batista\OneDrive\Desktop\landingpage_house"
    & ".\.venv\Scripts\python.exe" "app.py"
}

Start-Sleep -Seconds 5

# Verificar se Flask iniciou
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000" -UseBasicParsing -TimeoutSec 3
    Write-Host "✅ Flask rodando na porta 5000 (HTTP $($response.StatusCode))" -ForegroundColor Green
} catch {
    Write-Host "❌ Flask não iniciou corretamente!" -ForegroundColor Red
    Write-Host "Erro: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Logs do Flask:" -ForegroundColor Yellow
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
Write-Host "🌐 Seu site estará disponível em: https://housealimentoss.com.br" -ForegroundColor Green
Write-Host ""

Set-Location "C:\Users\Gabriel Batista\OneDrive\Desktop\landingpage_house"
.\cloudflared.exe tunnel run house-alimentos
