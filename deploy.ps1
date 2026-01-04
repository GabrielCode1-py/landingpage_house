# ====================================
# DEPLOY AUTOMATIZADO - HOUSE Alimentos v6.1.0
# ====================================

Write-Host "🚀 Iniciando Deploy Automatizado..." -ForegroundColor Cyan
Write-Host ""

# Verificar se estamos na branch correta
$currentBranch = git rev-parse --abbrev-ref HEAD
Write-Host "📍 Branch atual: $currentBranch" -ForegroundColor Yellow

if ($currentBranch -ne "master") {
    Write-Host "⚠️  Você não está na branch master!" -ForegroundColor Red
    $response = Read-Host "Deseja continuar mesmo assim? (s/n)"
    if ($response -ne "s") {
        Write-Host "❌ Deploy cancelado." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "📦 Verificando dependências..." -ForegroundColor Cyan

# Verificar se o ambiente virtual está ativo
if ($null -eq $env:VIRTUAL_ENV) {
    Write-Host "⚡ Ativando ambiente virtual..." -ForegroundColor Yellow
    & ".\.venv\Scripts\Activate.ps1"
}

# Atualizar dependências
Write-Host "📥 Instalando/Atualizando dependências..." -ForegroundColor Cyan
& ".\.venv\Scripts\python.exe" -m pip install --upgrade pip
& ".\.venv\Scripts\python.exe" -m pip install -r requirements.txt

Write-Host "✅ Dependências instaladas!" -ForegroundColor Green
Write-Host ""

# Verificar variáveis de ambiente
Write-Host "🔐 Verificando configurações de segurança..." -ForegroundColor Cyan

if (-not (Test-Path ".env")) {
    Write-Host "⚠️  Arquivo .env não encontrado!" -ForegroundColor Red
    Write-Host "📝 Criando .env a partir do exemplo..." -ForegroundColor Yellow
    Copy-Item ".env.example" ".env"
    Write-Host "⚠️  IMPORTANTE: Edite o arquivo .env com suas configurações!" -ForegroundColor Red
    Write-Host "   - SECRET_KEY: Gere uma chave única" -ForegroundColor Yellow
    Write-Host "   - MAIL_PASSWORD: Configure a senha do email" -ForegroundColor Yellow
    
    $continue = Read-Host "Pressione ENTER após configurar o .env ou 'n' para cancelar"
    if ($continue -eq "n") {
        Write-Host "❌ Deploy cancelado." -ForegroundColor Red
        exit 1
    }
}

# Verificar pasta de uploads
Write-Host "📁 Verificando diretórios..." -ForegroundColor Cyan
if (-not (Test-Path "uploads")) {
    New-Item -ItemType Directory -Path "uploads" | Out-Null
    Write-Host "✅ Pasta uploads criada!" -ForegroundColor Green
} else {
    Write-Host "✅ Pasta uploads OK!" -ForegroundColor Green
}

Write-Host ""
Write-Host "🧪 Executando testes básicos..." -ForegroundColor Cyan

# Teste de sintaxe Python
$testResult = & ".\.venv\Scripts\python.exe" -c "import app; print('OK')" 2>&1
if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Sintaxe Python OK!" -ForegroundColor Green
} else {
    Write-Host "❌ Erro na sintaxe Python!" -ForegroundColor Red
    Write-Host $testResult -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "📊 Informações da Versão:" -ForegroundColor Cyan
Write-Host "   Versão: v6.1.0" -ForegroundColor White
Write-Host "   Data: $(Get-Date -Format 'dd/MM/yyyy HH:mm:ss')" -ForegroundColor White
Write-Host "   Commit: $(git rev-parse --short HEAD)" -ForegroundColor White
Write-Host "   Branch: $currentBranch" -ForegroundColor White

Write-Host ""
Write-Host "🎯 Escolha o tipo de deploy:" -ForegroundColor Cyan
Write-Host "   1 - Desenvolvimento (localhost:5000)" -ForegroundColor Yellow
Write-Host "   2 - Produção Local (0.0.0.0:8000 com Gunicorn)" -ForegroundColor Yellow
Write-Host "   3 - PythonAnywhere (Instruções)" -ForegroundColor Yellow
Write-Host "   4 - Render/Heroku (Instruções)" -ForegroundColor Yellow

$deployType = Read-Host "Digite o número da opção"

switch ($deployType) {
    "1" {
        Write-Host ""
        Write-Host "🚀 Iniciando servidor de desenvolvimento..." -ForegroundColor Green
        Write-Host ""
        Write-Host "📍 Servidor rodando em:" -ForegroundColor Cyan
        Write-Host "   Local: http://127.0.0.1:5000" -ForegroundColor White
        Write-Host "   Rede: http://$(Get-NetIPAddress -AddressFamily IPv4 -InterfaceAlias 'Wi-Fi*','Ethernet*' | Select-Object -First 1 -ExpandProperty IPAddress):5000" -ForegroundColor White
        Write-Host ""
        Write-Host "Pressione CTRL+C para parar o servidor" -ForegroundColor Yellow
        Write-Host ""
        & ".\.venv\Scripts\python.exe" app.py
    }
    
    "2" {
        Write-Host ""
        Write-Host "🚀 Iniciando servidor de produção com Gunicorn..." -ForegroundColor Green
        Write-Host ""
        
        # Verificar se Gunicorn está instalado (funciona apenas no Linux/Mac)
        if ($IsLinux -or $IsMacOS) {
            & ".\.venv\Scripts\pip" show gunicorn | Out-Null
            if ($LASTEXITCODE -ne 0) {
                Write-Host "📥 Instalando Gunicorn..." -ForegroundColor Yellow
                & ".\.venv\Scripts\pip" install gunicorn
            }
            
            Write-Host "📍 Servidor rodando em:" -ForegroundColor Cyan
            Write-Host "   http://0.0.0.0:8000" -ForegroundColor White
            Write-Host ""
            Write-Host "Pressione CTRL+C para parar o servidor" -ForegroundColor Yellow
            Write-Host ""
            & ".\.venv\bin/gunicorn" -w 4 -b 0.0.0.0:8000 app:app
        } else {
            Write-Host "⚠️  Gunicorn não é suportado no Windows!" -ForegroundColor Red
            Write-Host "💡 Use a opção 1 (Desenvolvimento) ou deploy em servidor Linux" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "Alternativa para Windows: Waitress" -ForegroundColor Cyan
            Write-Host "pip install waitress" -ForegroundColor White
            Write-Host "waitress-serve --listen=*:8000 app:app" -ForegroundColor White
        }
    }
    
    "3" {
        Write-Host ""
        Write-Host "📘 DEPLOY NO PYTHONANYWHERE" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "1️⃣  Acesse: https://www.pythonanywhere.com" -ForegroundColor White
        Write-Host "2️⃣  Faça login na sua conta" -ForegroundColor White
        Write-Host "3️⃣  Vá em 'Web' → 'Add a new web app'" -ForegroundColor White
        Write-Host "4️⃣  Escolha Flask e Python 3.10+" -ForegroundColor White
        Write-Host ""
        Write-Host "5️⃣  No Console Bash, execute:" -ForegroundColor Yellow
        Write-Host "    cd ~" -ForegroundColor White
        Write-Host "    git clone https://github.com/GabrielCode1-py/landingpage_house.git" -ForegroundColor White
        Write-Host "    cd landingpage_house" -ForegroundColor White
        Write-Host "    git checkout v6.1.0" -ForegroundColor White
        Write-Host "    mkvirtualenv --python=/usr/bin/python3.10 house-env" -ForegroundColor White
        Write-Host "    pip install -r requirements.txt" -ForegroundColor White
        Write-Host ""
        Write-Host "6️⃣  Configure o arquivo WSGI:" -ForegroundColor Yellow
        Write-Host "    - Aponte para: /home/SEUUSER/landingpage_house/wsgi_pythonanywhere.py" -ForegroundColor White
        Write-Host "    - Configure virtualenv: /home/SEUUSER/.virtualenvs/house-env" -ForegroundColor White
        Write-Host ""
        Write-Host "7️⃣  Adicione variáveis de ambiente no .env:" -ForegroundColor Yellow
        Write-Host "    nano ~/landingpage_house/.env" -ForegroundColor White
        Write-Host ""
        Write-Host "8️⃣  Clique em 'Reload' no web app" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "✅ Seu site estará em: SEUUSER.pythonanywhere.com" -ForegroundColor Green
        Write-Host ""
        Write-Host "📖 Documentação completa: DEPLOY_PYTHONANYWHERE.md" -ForegroundColor Cyan
    }
    
    "4" {
        Write-Host ""
        Write-Host "📘 DEPLOY NO RENDER/HEROKU" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "RENDER.COM:" -ForegroundColor Yellow
        Write-Host "1️⃣  Acesse: https://render.com" -ForegroundColor White
        Write-Host "2️⃣  Conecte seu repositório GitHub" -ForegroundColor White
        Write-Host "3️⃣  Crie um novo 'Web Service'" -ForegroundColor White
        Write-Host "4️⃣  Configure:" -ForegroundColor White
        Write-Host "    - Build Command: pip install -r requirements.txt" -ForegroundColor White
        Write-Host "    - Start Command: gunicorn -w 4 -b 0.0.0.0:8000 app:app" -ForegroundColor White
        Write-Host "5️⃣  Adicione variáveis de ambiente (SECRET_KEY, etc)" -ForegroundColor White
        Write-Host ""
        Write-Host "HEROKU:" -ForegroundColor Yellow
        Write-Host "1️⃣  Instale Heroku CLI: https://devcenter.heroku.com/articles/heroku-cli" -ForegroundColor White
        Write-Host "2️⃣  Execute:" -ForegroundColor White
        Write-Host "    heroku login" -ForegroundColor White
        Write-Host "    heroku create house-alimentos" -ForegroundColor White
        Write-Host "    git push heroku master" -ForegroundColor White
        Write-Host "    heroku config:set SECRET_KEY=sua-chave-aqui" -ForegroundColor White
        Write-Host "    heroku config:set MAIL_PASSWORD=sua-senha-aqui" -ForegroundColor White
        Write-Host ""
        Write-Host "✅ Deploy automático via GitHub!" -ForegroundColor Green
    }
    
    default {
        Write-Host "❌ Opção inválida!" -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "✅ Deploy concluído com sucesso! 🎉" -ForegroundColor Green
Write-Host ""
