# 🐍 GUIA PASSO A PASSO: PythonAnywhere

## ✅ Vantagens da sua escolha:
- **Domínio permanente grátis** (.pythonanywhere.com)
- **Sempre online 24/7** (não precisa deixar PC ligado)
- **SSL/HTTPS automático**
- **Fácil de configurar**
- **500MB de espaço** (plano gratuito)

---

## 📝 PASSO 1: Criar Conta no PythonAnywhere

### 1.1 Cadastro
1. Acesse: **https://www.pythonanywhere.com/registration/register/beginner/**
2. Preencha:
   - **Username**: `housealimentos` (ou outro de sua escolha)
     - ⚠️ Este será seu domínio: `housealimentos.pythonanywhere.com`
   - **Email**: seu email
   - **Senha**: crie uma senha forte

3. Clique em **Register**
4. Confirme o email (verifique sua caixa de entrada)

### 1.2 Login
- Acesse: **https://www.pythonanywhere.com/login/**
- Faça login com suas credenciais

---

## 📦 PASSO 2: Preparar Arquivos para Upload

### 2.1 Criar arquivo de requisitos simplificado

Execute no terminal do VS Code:

```powershell
# Criar requirements.txt otimizado para PythonAnywhere
@'
Flask==3.0.0
Werkzeug==3.0.1
Flask-WTF==1.2.1
Flask-Talisman==1.1.0
Flask-Limiter==3.5.0
python-dotenv==1.0.0
WTForms==3.1.1
email-validator==2.1.0
Pillow==10.1.0
'@ | Out-File -FilePath requirements_pythonanywhere.txt -Encoding utf8
```

### 2.2 Criar arquivo .env para produção

```powershell
# Gerar nova SECRET_KEY para produção
python -c "import secrets; print('SECRET_KEY=' + secrets.token_urlsafe(32))" | Out-File -FilePath .env.production -Encoding utf8
```

---

## 🌐 PASSO 3: Configurar no PythonAnywhere

### 3.1 Criar Web App

1. No Dashboard do PythonAnywhere, vá em: **Web**
2. Clique em: **Add a new web app**
3. Escolha: **Next** (para domínio gratuito)
4. Selecione: **Flask**
5. Selecione: **Python 3.10** (ou 3.11 se disponível)
6. Caminho do projeto: `/home/SEU_USERNAME/mysite` (use o padrão)
7. Clique em: **Next** até finalizar

### 3.2 Upload dos Arquivos

**Opção A: Via Navegador (Mais Fácil)**

1. Vá em: **Files** (no menu superior)
2. Navegue até: `/home/SEU_USERNAME/mysite/`
3. Clique em: **Upload a file**
4. Faça upload dos seguintes arquivos:
   - `app.py`
   - `requirements_pythonanywhere.txt` (renomeie para `requirements.txt`)
   - `.env.production` (renomeie para `.env`)

5. Crie as pastas manualmente:
   - Clique em **New directory**: `templates`
   - Clique em **New directory**: `static`
   - Clique em **New directory**: `uploads`

6. Navegue para cada pasta e faça upload:
   - Em `templates/`: upload de `index.html` e `privacidade.html`
   - Em `static/`: upload das pastas `css/`, `js/`, `images/`

**Opção B: Via Git (Mais Rápido)**

1. No Dashboard, clique em: **Consoles** > **Bash**
2. Execute:

```bash
cd ~
git clone https://SEU_REPOSITORIO_GIT.git mysite
cd mysite
```

### 3.3 Instalar Dependências

No **Bash Console** do PythonAnywhere:

```bash
# Ir para o diretório do projeto
cd ~/mysite

# Criar ambiente virtual
mkvirtualenv --python=/usr/bin/python3.10 housealimentos

# Instalar dependências
pip install -r requirements.txt

# Verificar instalação
python -c "from flask import Flask; from PIL import Image; print('✅ OK')"
```

---

## ⚙️ PASSO 4: Configurar WSGI

### 4.1 Editar arquivo WSGI

1. Vá em: **Web** (menu superior)
2. Na seção **Code**, clique no link do **WSGI configuration file**
   - Exemplo: `/var/www/housealimentos_pythonanywhere_com_wsgi.py`

3. **Apague todo o conteúdo** e substitua por:

```python
# ===========================
# WSGI Configuration File
# HOUSE Alimentos - PythonAnywhere
# ===========================

import sys
import os
from dotenv import load_dotenv

# Adicionar diretório do projeto ao PATH
project_home = '/home/SEU_USERNAME/mysite'  # ⚠️ ALTERE SEU_USERNAME
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Carregar variáveis de ambiente
load_dotenv(os.path.join(project_home, '.env'))

# Importar aplicação Flask
from app import app as application

# Configuração para PythonAnywhere
application.config['DEBUG'] = False
application.config['TESTING'] = False

# Log de inicialização
print(f"✅ Aplicação carregada de: {project_home}")
```

4. **IMPORTANTE**: Substitua `SEU_USERNAME` pelo seu nome de usuário do PythonAnywhere
5. Clique em: **Save** (canto superior direito)

---

## 🔧 PASSO 5: Ajustes de Configuração

### 5.1 Configurar Virtual Environment

1. Ainda na página **Web**
2. Na seção **Virtualenv**:
   - Clique em: **Enter path to a virtualenv**
   - Digite: `/home/SEU_USERNAME/.virtualenvs/housealimentos`
   - Clique em ✓ (check)

### 5.2 Configurar arquivos estáticos

1. Na seção **Static files**:
2. Clique em: **Enter URL** e **Enter path**:

| URL | Path |
|-----|------|
| `/static/` | `/home/SEU_USERNAME/mysite/static` |
| `/uploads/` | `/home/SEU_USERNAME/mysite/uploads` |

3. Clique em ✓ para cada um

---

## 🚀 PASSO 6: Iniciar o Site

### 6.1 Recarregar Aplicação

1. Vá para o topo da página **Web**
2. Clique no grande botão verde: **Reload housealimentos.pythonanywhere.com**
3. Aguarde alguns segundos

### 6.2 Acessar seu Site

1. Clique no link: **https://housealimentos.pythonanywhere.com**
2. Seu site deve estar online! 🎉

---

## 🐛 PASSO 7: Solução de Problemas

### 7.1 Verificar Logs de Erro

Se o site não carregar:

1. Vá em: **Web** > **Log files**
2. Clique em: **Error log**
3. Procure por mensagens de erro em vermelho

### 7.2 Problemas Comuns

**Erro: "ImportError: No module named flask"**
```bash
# No Bash Console:
workon housealimentos
pip install -r requirements.txt
```

**Erro: "Internal Server Error"**
```bash
# Verificar se o .env existe e tem SECRET_KEY
cd ~/mysite
cat .env
# Se não tiver SECRET_KEY, crie:
echo "SECRET_KEY=$(python -c 'import secrets; print(secrets.token_urlsafe(32))')" > .env
```

**Erro: "CSRF token missing"**
- Certifique-se que o arquivo `.env` está no diretório correto
- Verifique se a SECRET_KEY está configurada
- Recarregue a aplicação no botão verde **Reload**

**Erro 404 em imagens/CSS**
- Verifique se configurou os **Static files** corretamente
- Confirme que os arquivos estão na pasta `static/`

### 7.3 Testar no Console

No **Bash Console**:
```bash
cd ~/mysite
workon housealimentos
python -c "from app import app; print('✅ App carrega corretamente')"
```

---

## 📊 PASSO 8: Monitoramento e Manutenção

### 8.1 Ver Logs em Tempo Real

No **Bash Console**:
```bash
tail -f /var/log/housealimentos.pythonanywhere.com.error.log
```

### 8.2 Atualizar o Site

Quando fizer mudanças:
1. Faça upload dos arquivos modificados (via **Files**)
2. Clique em: **Reload** (botão verde na página **Web**)

### 8.3 Limites do Plano Gratuito

- **CPU**: 100 segundos/dia
- **Tráfego**: Ilimitado (mas com throttling em picos)
- **Espaço**: 512MB
- **Banco de dados**: 1 MySQL (até 100MB)

---

## 🎯 CHECKLIST FINAL

Antes de considerar concluído, verifique:

- [ ] Conta criada no PythonAnywhere
- [ ] Web App configurado com Python 3.10+
- [ ] Todos os arquivos uploaded (app.py, templates/, static/)
- [ ] requirements.txt instalado no virtualenv
- [ ] Arquivo .env com SECRET_KEY configurado
- [ ] WSGI file editado com caminho correto
- [ ] Virtualenv path configurado
- [ ] Static files mapeados
- [ ] Site recarregado (botão Reload)
- [ ] Site acessível via https://seunome.pythonanywhere.com
- [ ] Formulários de contato funcionando
- [ ] Imagens carregando corretamente

---

## 🆙 Upgrade para Plano Pago (Opcional)

Se precisar de mais recursos:

**Plano Hacker** - US$ 5/mês
- Domínio personalizado (housealimentos.com.br)
- Mais CPU e memória
- Suporte via email

**Upgrade**: https://www.pythonanywhere.com/pricing/

---

## 📞 Suporte

- **Documentação**: https://help.pythonanywhere.com/
- **Fórum**: https://www.pythonanywhere.com/forums/
- **Email**: support@pythonanywhere.com

---

## ✅ Próximos Passos

Digite no terminal:
- **"ok"** quando terminar cada passo
- **"erro"** se encontrar problemas (descreva o erro)
- **"logs"** para ver como verificar os logs
