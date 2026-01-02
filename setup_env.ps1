# Script para configurar ambiente Python 3.11
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Configuração Python 3.11" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# Matar processos Python que podem estar travando
Write-Host "[1/6] Encerrando processos Python..." -ForegroundColor Yellow
Get-Process python -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
Start-Sleep -Seconds 2

# Remover ambiente antigo
if (Test-Path ".venv") {
    Write-Host "[2/6] Removendo ambiente virtual antigo..." -ForegroundColor Yellow
    Get-ChildItem .venv -Recurse | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force .venv -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 2
}

# Criar novo ambiente com Python 3.11
Write-Host "[3/6] Criando ambiente virtual com Python 3.11..." -ForegroundColor Green
py -3.11 -m venv .venv

if (-Not (Test-Path ".venv\Scripts\python.exe")) {
    Write-Host "[ERRO] Falha ao criar ambiente virtual!" -ForegroundColor Red
    exit 1
}

# Verificar versão no ambiente
Write-Host "[4/6] Verificando versão..." -ForegroundColor Green
& .\.venv\Scripts\python.exe --version

# Atualizar pip
Write-Host "[5/6] Atualizando pip, setuptools e wheel..." -ForegroundColor Green
& .\.venv\Scripts\python.exe -m ensurepip
& .\.venv\Scripts\python.exe -m pip install --upgrade pip setuptools wheel

# Instalar dependências
Write-Host "[6/6] Instalando dependências do projeto..." -ForegroundColor Green
& .\.venv\Scripts\python.exe -m pip install Flask==3.0.0
& .\.venv\Scripts\python.exe -m pip install Werkzeug==3.0.1
& .\.venv\Scripts\python.exe -m pip install Flask-WTF==1.2.1
& .\.venv\Scripts\python.exe -m pip install Flask-Talisman==1.1.0
& .\.venv\Scripts\python.exe -m pip install Flask-Limiter==3.5.0
& .\.venv\Scripts\python.exe -m pip install python-dotenv==1.0.0
& .\.venv\Scripts\python.exe -m pip install WTForms==3.1.1
& .\.venv\Scripts\python.exe -m pip install email-validator==2.1.0
& .\.venv\Scripts\python.exe -m pip install Pillow==10.1.0

# Verificar Pillow
Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  VERIFICANDO INSTALAÇÃO" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan
& .\.venv\Scripts\python.exe -c "from PIL import Image; print('✅ Pillow instalado com sucesso')"

Write-Host "`n✅ Ambiente configurado!" -ForegroundColor Green
Write-Host "Para ativar: .\.venv\Scripts\Activate.ps1" -ForegroundColor Yellow
