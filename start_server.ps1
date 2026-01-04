# Script para iniciar Flask + ngrok juntos

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HOUSE Alimentos - Iniciando Servidor" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Parar processos anteriores
Write-Host "[1/3] Limpando processos anteriores..." -ForegroundColor Yellow
taskkill /F /IM python.exe /T 2>$null | Out-Null
taskkill /F /IM ngrok.exe /T 2>$null | Out-Null
Start-Sleep -Seconds 2

# Iniciar Flask
Write-Host "[2/3] Iniciando Flask na porta 5000..." -ForegroundColor Yellow
$flaskJob = Start-Job -ScriptBlock {
    Set-Location "C:\Users\Gabriel Batista\OneDrive\Desktop\landingpage_house"
    & ".\.venv\Scripts\python.exe" "app.py"
}

# Aguardar Flask inicializar
Start-Sleep -Seconds 4

# Testar Flask
try {
    $response = Invoke-WebRequest -Uri "http://localhost:5000" -UseBasicParsing -TimeoutSec 3
    Write-Host "✅ Flask rodando!" -ForegroundColor Green
} catch {
    Write-Host "❌ Flask não respondeu!" -ForegroundColor Red
    Stop-Job -Job $flaskJob -ErrorAction SilentlyContinue
    Remove-Job -Job $flaskJob -ErrorAction SilentlyContinue
    exit 1
}

# Iniciar ngrok
Write-Host "[3/3] Iniciando ngrok..." -ForegroundColor Yellow
Write-Host ""

Start-Process ngrok -ArgumentList "http","5000" -WindowStyle Minimized

Start-Sleep -Seconds 5

# Obter URL do ngrok
try {
    $tunnels = Invoke-RestMethod -Uri "http://127.0.0.1:4040/api/tunnels"
    $publicUrl = $tunnels.tunnels[0].public_url
    
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "  ✅ SERVIDOR ONLINE!" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "🌐 URL Pública:" -ForegroundColor White
    Write-Host "   $publicUrl" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "📊 Dashboard ngrok:" -ForegroundColor White
    Write-Host "   http://127.0.0.1:4040" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "Para parar: Pressione Ctrl+C" -ForegroundColor Yellow
    Write-Host ""
    
    # Copiar URL para clipboard
    Set-Clipboard -Value $publicUrl
    Write-Host "✅ URL copiada para área de transferência!" -ForegroundColor Green
    Write-Host ""
    
} catch {
    Write-Host "⚠️ Ngrok iniciando... Aguarde 10 segundos" -ForegroundColor Yellow
    Start-Sleep -Seconds 10
    try {
        $tunnels = Invoke-RestMethod -Uri "http://127.0.0.1:4040/api/tunnels"
        $publicUrl = $tunnels.tunnels[0].public_url
        Write-Host "✅ URL: $publicUrl" -ForegroundColor Green
        Set-Clipboard -Value $publicUrl
    } catch {
        Write-Host "❌ Erro ao obter URL do ngrok" -ForegroundColor Red
    }
}

# Manter script rodando
Write-Host "Pressione Ctrl+C para parar os servidores" -ForegroundColor Yellow
try {
    while ($true) {
        Start-Sleep -Seconds 5
        # Verificar se Flask ainda está rodando
        try {
            Invoke-WebRequest -Uri "http://localhost:5000" -UseBasicParsing -TimeoutSec 2 | Out-Null
        } catch {
            Write-Host "❌ Flask parou de responder!" -ForegroundColor Red
            break
        }
    }
} finally {
    Write-Host ""
    Write-Host "Parando servidores..." -ForegroundColor Yellow
    Stop-Job -Job $flaskJob -ErrorAction SilentlyContinue
    Remove-Job -Job $flaskJob -ErrorAction SilentlyContinue
    taskkill /F /IM ngrok.exe /T 2>$null | Out-Null
    Write-Host "✅ Servidores parados" -ForegroundColor Green
}
