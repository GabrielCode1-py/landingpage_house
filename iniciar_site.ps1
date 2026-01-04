# Inicia HOUSE Alimentos - housealimentoss.com.br

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  HOUSE Alimentos - Iniciando" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Para processos anteriores
Get-Process python -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue

# Inicia Flask
Write-Host "[1/2] Iniciando Flask..." -ForegroundColor Yellow
$flaskProcess = Start-Process -FilePath ".\.venv\Scripts\python.exe" -ArgumentList "app.py" -PassThru -WindowStyle Hidden
Start-Sleep -Seconds 3

# Inicia Cloudflare Tunnel
Write-Host "[2/2] Conectando tunnel..." -ForegroundColor Yellow
Write-Host ""

$cloudflaredPath = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Cloudflare.cloudflared*\cloudflared.exe" | Select-Object -First 1 -ExpandProperty FullName

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
$flaskProcess.Id | Out-File -FilePath ".flask_pid.txt"

# Executa tunnel
& $cloudflaredPath tunnel run house-alimentos

# Cleanup
if (Test-Path ".flask_pid.txt") {
    $pid = Get-Content ".flask_pid.txt"
    Stop-Process -Id $pid -Force -ErrorAction SilentlyContinue
    Remove-Item ".flask_pid.txt" -Force
}
