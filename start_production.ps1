# Script de Inicialização Segura - HOUSE Alimentos
# PowerShell Script para iniciar aplicação em modo produção

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "   HOUSE Alimentos - Landing Page" -ForegroundColor Cyan
Write-Host "   Inicializando Ambiente de Produção" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 1. Verificar se .env existe
if (-Not (Test-Path ".env")) {
    Write-Host "[ERRO] Arquivo .env não encontrado!" -ForegroundColor Red
    Write-Host "Copie .env.example para .env e configure as variáveis" -ForegroundColor Yellow
    exit 1
}

# 2. Verificar ambiente virtual
if (-Not (Test-Path ".venv")) {
    Write-Host "[AVISO] Ambiente virtual não encontrado. Criando..." -ForegroundColor Yellow
    python -m venv .venv
}

# 3. Ativar ambiente virtual
Write-Host "[INFO] Ativando ambiente virtual..." -ForegroundColor Green
& .\.venv\Scripts\Activate.ps1

# 4. Instalar/Atualizar dependências
Write-Host "[INFO] Verificando dependências..." -ForegroundColor Green
pip install -r requirements.txt --quiet

# 5. Verificar estrutura de diretórios
if (-Not (Test-Path "uploads")) {
    Write-Host "[INFO] Criando diretório uploads..." -ForegroundColor Green
    New-Item -ItemType Directory -Path "uploads" | Out-Null
}

# 6. Definir variável de ambiente de produção
$env:FLASK_ENV = "production"
Write-Host "[INFO] FLASK_ENV=production" -ForegroundColor Green

# 7. Limpar logs antigos (opcional)
if (Test-Path "app.log") {
    $logSize = (Get-Item "app.log").Length / 1MB
    if ($logSize -gt 10) {
        Write-Host "[INFO] Log maior que 10MB. Fazendo backup..." -ForegroundColor Yellow
        $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
        Move-Item "app.log" "app_$timestamp.log"
    }
}

# 8. Verificar porta 5000
$port = Get-NetTCPConnection -LocalPort 5000 -ErrorAction SilentlyContinue
if ($port) {
    Write-Host "[AVISO] Porta 5000 já está em uso!" -ForegroundColor Yellow
    Write-Host "Deseja encerrar o processo? (S/N)" -ForegroundColor Yellow
    $response = Read-Host
    if ($response -eq "S") {
        Stop-Process -Id $port.OwningProcess -Force
        Start-Sleep -Seconds 2
    } else {
        Write-Host "[ERRO] Não é possível iniciar com a porta ocupada" -ForegroundColor Red
        exit 1
    }
}

# 9. Verificar ngrok
$ngrokInstalled = Get-Command ngrok -ErrorAction SilentlyContinue
if (-Not $ngrokInstalled) {
    Write-Host "[AVISO] Ngrok não encontrado!" -ForegroundColor Yellow
    Write-Host "Instale com: choco install ngrok" -ForegroundColor Yellow
    Write-Host "Ou baixe de: https://ngrok.com/download`n" -ForegroundColor Yellow
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "   PRONTO PARA INICIAR!" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

Write-Host "1. Iniciar apenas Flask (servidor local)" -ForegroundColor White
Write-Host "2. Iniciar Flask + Ngrok (exposição pública)" -ForegroundColor White
Write-Host "3. Cancelar`n" -ForegroundColor White

$choice = Read-Host "Escolha uma opção"

switch ($choice) {
    "1" {
        Write-Host "`n[INFO] Iniciando servidor Flask..." -ForegroundColor Green
        Write-Host "[INFO] Servidor rodará em: http://localhost:5000" -ForegroundColor Cyan
        Write-Host "[INFO] Pressione Ctrl+C para parar`n" -ForegroundColor Yellow
        python app.py
    }
    "2" {
        if (-Not $ngrokInstalled) {
            Write-Host "`n[ERRO] Ngrok não está instalado!" -ForegroundColor Red
            exit 1
        }
        
        Write-Host "`n[INFO] Iniciando servidor Flask em background..." -ForegroundColor Green
        $flaskJob = Start-Job -ScriptBlock {
            Set-Location $using:PWD
            & .\.venv\Scripts\Activate.ps1
            $env:FLASK_ENV = "production"
            python app.py
        }
        
        Start-Sleep -Seconds 3
        
        Write-Host "[INFO] Iniciando túnel Ngrok..." -ForegroundColor Green
        
        if (Test-Path "ngrok.yml") {
            Write-Host "[INFO] Usando configuração ngrok.yml" -ForegroundColor Cyan
            ngrok start --config=ngrok.yml house-alimentos
        } else {
            Write-Host "[INFO] Usando configuração padrão" -ForegroundColor Cyan
            ngrok http 5000 --region=sa
        }
        
        # Quando ngrok é fechado, para o Flask também
        Write-Host "`n[INFO] Encerrando servidor Flask..." -ForegroundColor Yellow
        Stop-Job -Job $flaskJob
        Remove-Job -Job $flaskJob
    }
    default {
        Write-Host "`n[INFO] Operação cancelada" -ForegroundColor Yellow
        exit 0
    }
}

Write-Host "`n[INFO] Aplicação encerrada" -ForegroundColor Green
