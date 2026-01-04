# 🚀 GUIA COMPLETO: Deploy no PythonAnywhere
## HOUSE Alimentos - Landing Page v6.1.0

---

## 📋 ÍNDICE

1. [Criar Conta no PythonAnywhere](#1-criar-conta)
2. [Configurar Repositório](#2-configurar-repositório)
3. [Criar Ambiente Virtual](#3-criar-ambiente-virtual)
4. [Configurar Variáveis de Ambiente](#4-configurar-variáveis)
5. [Configurar Web App](#5-configurar-web-app)
6. [Configurar Arquivos Estáticos](#6-arquivos-estáticos)
7. [Testar e Validar](#7-testar-e-validar)
8. [Solução de Problemas](#8-problemas-comuns)

---

## 1️⃣ CRIAR CONTA NO PYTHONANYWHERE {#1-criar-conta}

### Passo 1.1: Criar conta gratuita

1. Acesse: **https://www.pythonanywhere.com/registration/register/beginner/**
2. Preencha:
   - **Username:** (escolha um nome único) - ex: `housealimentos`
   - **Email:** seu-email@gmail.com
   - **Password:** (senha forte)
3. Clique em **Register**
4. Confirme seu email

### Passo 1.2: Fazer Login

1. Acesse: **https://www.pythonanywhere.com/login/**
2. Faça login com suas credenciais
3. Você verá o **Dashboard**

> ✅ **CHECKPOINT:** Você está logado no PythonAnywhere

---

## 2️⃣ CONFIGURAR REPOSITÓRIO {#2-configurar-repositório}

### Passo 2.1: Abrir Console Bash

1. No Dashboard, clique em **"Consoles"**
2. Clique em **"Bash"** (ou **"$ Bash"**)
3. Uma nova aba abrirá com o terminal

### Passo 2.2: Clonar o Repositório

No console Bash, execute os comandos:

```bash
# 1. Ir para o diretório home
cd ~

# 2. Clonar o repositório do GitHub
git clone https://github.com/GabrielCode1-py/landingpage_house.git

# 3. Entrar na pasta do projeto
cd landingpage_house

# 4. Verificar a versão (deve mostrar v6.1.0)
git describe --tags

# 5. Garantir que está na versão correta
git checkout v6.1.0

# 6. Verificar os arquivos
ls -la
```

**Saída esperada:**
```
app.py
requirements.txt
static/
templates/
wsgi_pythonanywhere.py
...
```

> ✅ **CHECKPOINT:** Repositório clonado em `~/landingpage_house`

---

## 3️⃣ CRIAR AMBIENTE VIRTUAL {#3-criar-ambiente-virtual}

### Passo 3.1: Criar Virtual Environment

No console Bash:

```bash
# 1. Criar ambiente virtual com Python 3.10
mkvirtualenv --python=/usr/bin/python3.10 house-env

# 2. O ambiente será ativado automaticamente
# Você verá (house-env) no prompt

# 3. Atualizar pip
pip install --upgrade pip

# 4. Instalar dependências do projeto
cd ~/landingpage_house
pip install -r requirements.txt
```

**Instalação levará 2-5 minutos. Aguarde...**

### Passo 3.2: Verificar Instalação

```bash
# Verificar se Flask foi instalado
pip show Flask

# Listar todos os pacotes instalados
pip list
```

**Deve mostrar:**
- Flask 3.0.0
- Flask-WTF 1.2.1
- Flask-Mail 0.9.1
- E outros...

> ✅ **CHECKPOINT:** Ambiente virtual criado e dependências instaladas

---

## 4️⃣ CONFIGURAR VARIÁVEIS DE AMBIENTE {#4-configurar-variáveis}

### Passo 4.1: Criar arquivo .env

```bash
# 1. Ir para a pasta do projeto
cd ~/landingpage_house

# 2. Criar arquivo .env
nano .env
```

### Passo 4.2: Adicionar configurações

Cole este conteúdo no nano (Ctrl+Shift+V):

```env
# Flask Configuration
SECRET_KEY=COLE_AQUI_SUA_CHAVE_SECRETA_GERADA
FLASK_ENV=production

# Security
MAX_CONTENT_LENGTH=5242880
UPLOAD_FOLDER=uploads
ALLOWED_EXTENSIONS=pdf

# Rate Limiting
RATELIMIT_DEFAULT=100 per hour
RATELIMIT_STORAGE_URL=memory://

# Email Configuration (Gmail)
MAIL_SERVER=smtp.gmail.com
MAIL_PORT=587
MAIL_USE_TLS=True
MAIL_USERNAME=housealimentoss@gmail.com
MAIL_PASSWORD=COLE_AQUI_SUA_SENHA_DE_APP_DO_GMAIL
MAIL_DEFAULT_SENDER=housealimentoss@gmail.com
```

### Passo 4.3: Gerar SECRET_KEY

Abra uma **NOVA aba** do Console Bash e execute:

```bash
python3 -c "import secrets; print(secrets.token_hex(32))"
```

**Copie o resultado** (será algo como: `a1b2c3d4e5f6...`)

**Volte para a aba do nano** e cole no lugar de `COLE_AQUI_SUA_CHAVE_SECRETA_GERADA`

### Passo 4.4: Configurar senha do Gmail

Para `MAIL_PASSWORD`, você precisa de uma **Senha de App do Gmail**:

1. Acesse: https://myaccount.google.com/apppasswords
2. Faça login com `housealimentoss@gmail.com`
3. Clique em **"Criar"**
4. Digite: **"PythonAnywhere HOUSE"**
5. Copie a senha gerada (16 caracteres)
6. Cole no `.env` no lugar de `COLE_AQUI_SUA_SENHA_DE_APP_DO_GMAIL`

### Passo 4.5: Salvar e sair

1. Pressione **Ctrl + X**
2. Digite **Y** (para confirmar)
3. Pressione **Enter**

### Passo 4.6: Verificar arquivo

```bash
# Ver se o arquivo foi criado
cat .env

# Deve mostrar suas configurações (sem expor a senha completa aqui)
```

> ✅ **CHECKPOINT:** Arquivo .env criado e configurado

---

## 5️⃣ CONFIGURAR WEB APP {#5-configurar-web-app}

### Passo 5.1: Criar Web App

1. Volte para o **Dashboard** do PythonAnywhere
2. Clique na aba **"Web"**
3. Clique em **"Add a new web app"**

### Passo 5.2: Configurar domínio

1. Clique em **"Next"** (usará o domínio gratuito)
2. Seu domínio será: `seuusername.pythonanywhere.com`

### Passo 5.3: Escolher Framework

1. Selecione: **"Manual configuration"** (NÃO escolha Flask wizard!)
2. Escolha: **Python 3.10**
3. Clique em **"Next"**

### Passo 5.4: Configurar Code

Na página de configuração do Web App:

1. Role até **"Code"**
2. Em **"Source code"**, clique em **"Enter path"**
3. Digite: `/home/SEUUSERNAME/landingpage_house`
   - Substitua `SEUUSERNAME` pelo seu username!
4. Clique no ✓

### Passo 5.5: Configurar WSGI

1. Role até **"Code"**
2. Clique no link azul que diz **"WSGI configuration file"**
   - Ex: `/var/www/seuusername_pythonanywhere_com_wsgi.py`

3. **APAGUE TODO o conteúdo** do arquivo

4. **Cole este conteúdo:**

```python
import sys
import os

# Adicionar o diretório do projeto ao path
project_home = '/home/SEUUSERNAME/landingpage_house'
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Carregar variáveis de ambiente do .env
from dotenv import load_dotenv
env_path = os.path.join(project_home, '.env')
load_dotenv(env_path)

# Importar a aplicação Flask
from app import app as application
```

5. **IMPORTANTE:** Substitua `SEUUSERNAME` pelo seu username na linha `project_home`!

6. Clique em **"Save"** (canto superior direito)

### Passo 5.6: Configurar Virtualenv

1. Volte para a aba **"Web"**
2. Role até **"Virtualenv"**
3. Clique em **"Enter path to a virtualenv"**
4. Digite: `/home/SEUUSERNAME/.virtualenvs/house-env`
   - Substitua `SEUUSERNAME`!
5. Clique no ✓

> ✅ **CHECKPOINT:** Web App configurado

---

## 6️⃣ CONFIGURAR ARQUIVOS ESTÁTICOS {#6-arquivos-estáticos}

### Passo 6.1: Configurar Static Files

Na aba **"Web"**, role até **"Static files"**:

1. Clique em **"Enter URL"** na primeira linha vazia
2. Digite: `/static/`
3. Clique no ✓

4. Clique em **"Enter path"** ao lado
5. Digite: `/home/SEUUSERNAME/landingpage_house/static/`
6. Clique no ✓

### Passo 6.2: Criar pasta uploads

No Console Bash:

```bash
cd ~/landingpage_house
mkdir -p uploads
chmod 755 uploads
```

> ✅ **CHECKPOINT:** Arquivos estáticos configurados

---

## 7️⃣ TESTAR E VALIDAR {#7-testar-e-validar}

### Passo 7.1: Reload da Aplicação

1. Na aba **"Web"**
2. Role até o topo
3. Clique no botão verde **"Reload seuusername.pythonanywhere.com"**

### Passo 7.2: Acessar o site

1. Clique no link do seu site na parte superior
2. Ou acesse: `https://seuusername.pythonanywhere.com`

### Passo 7.3: Verificar se carregou

**Deve carregar:**
- ✅ Página inicial com hero carousel
- ✅ Menu lateral funcionando
- ✅ Imagens carregando
- ✅ CSS aplicado corretamente

### Passo 7.4: Testar formulários

1. Role até **"Contato"**
2. Preencha o formulário
3. Envie
4. Deve aparecer mensagem de sucesso

### Passo 7.5: Verificar logs de erro

Se algo der errado:

1. Na aba **"Web"**
2. Role até **"Log files"**
3. Clique em **"Error log"**
4. Veja os erros (se houver)

> ✅ **CHECKPOINT:** Site no ar e funcionando!

---

## 8️⃣ PROBLEMAS COMUNS {#8-problemas-comuns}

### ❌ Erro 502 Bad Gateway

**Causa:** Erro no código Python

**Solução:**
```bash
# Verificar erro no log
cd ~/landingpage_house

# Testar o app manualmente
workon house-env
python app.py
```

### ❌ ImportError: No module named 'flask'

**Causa:** Virtualenv não configurado corretamente

**Solução:**
```bash
# Recriar virtualenv
rmvirtualenv house-env
mkvirtualenv --python=/usr/bin/python3.10 house-env
cd ~/landingpage_house
pip install -r requirements.txt
```

Depois, reconfigure o Virtualenv path no Web App.

### ❌ Página sem CSS/Imagens

**Causa:** Static files não configurados

**Solução:**
1. Verifique a configuração em **Web → Static files**
2. URL: `/static/`
3. Path: `/home/SEUUSERNAME/landingpage_house/static/`

### ❌ Formulário não envia email

**Causa:** Senha de app do Gmail incorreta

**Solução:**
```bash
# Verificar .env
cd ~/landingpage_house
nano .env

# Verificar se MAIL_PASSWORD está correto
# Gere uma nova senha de app se necessário
```

### ❌ 500 Internal Server Error

**Causa:** Erro no .env ou SECRET_KEY

**Solução:**
```bash
# Verificar .env
cd ~/landingpage_house
cat .env

# Gerar nova SECRET_KEY se necessário
python3 -c "import secrets; print(secrets.token_hex(32))"

# Editar .env
nano .env
```

Depois, clique em **Reload** no Web App.

---

## 🎯 CHECKLIST FINAL

Antes de considerar o deploy completo, verifique:

- [ ] Site carrega em `seuusername.pythonanywhere.com`
- [ ] Menu lateral funciona
- [ ] Hero carousel roda automaticamente
- [ ] Todas as imagens carregam
- [ ] CSS está aplicado
- [ ] Formulário de contato funciona
- [ ] Formulário "Trabalhe Conosco" funciona
- [ ] Emails são recebidos
- [ ] Site é responsivo (mobile)
- [ ] Cookie banner aparece
- [ ] Links de redes sociais funcionam

---

## 🔄 ATUALIZAÇÕES FUTURAS

Quando fizer mudanças no código:

```bash
# 1. No Console Bash
cd ~/landingpage_house

# 2. Ativar ambiente
workon house-env

# 3. Puxar atualizações do GitHub
git pull origin master

# 4. Instalar novas dependências (se houver)
pip install -r requirements.txt

# 5. Reload no Web App
# Volte para a aba Web e clique em Reload
```

---

## 📊 LIMITES DA CONTA GRATUITA

- **CPU:** 100 segundos/dia
- **Storage:** 512 MB
- **Domains:** 1 (*.pythonanywhere.com)
- **Web Apps:** 1
- **Scheduled Tasks:** Não disponível

Para remover limites, considere upgrade para plano pago.

---

## 🆘 SUPORTE

### Documentação PythonAnywhere
- https://help.pythonanywhere.com/

### Fórum da Comunidade
- https://www.pythonanywhere.com/forums/

### Suporte do Projeto
- GitHub Issues: https://github.com/GabrielCode1-py/landingpage_house/issues
- Email: housealimentoss@gmail.com

---

## ✅ DEPLOY CONCLUÍDO!

Parabéns! Seu site está no ar! 🎉

**URL do seu site:** `https://seuusername.pythonanywhere.com`

Compartilhe com o mundo! 🌍

---

**Documentado por:** Gabriel Code  
**Versão:** v6.1.0  
**Data:** 03/01/2026
