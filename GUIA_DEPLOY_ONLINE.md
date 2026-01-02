# 🌐 Guia Completo: Colocar Site Online

## 📋 Opções de Deploy

### **Opção 1: Ngrok (Rápido - 5 minutos) 🚀**
✅ Ideal para testes e demonstrações  
✅ HTTPS automático  
❌ URL muda a cada reinício (versão gratuita)  
💰 Grátis com limitações

### **Opção 2: PythonAnywhere (Hospedagem Gratuita) 🆓**
✅ Domínio permanente (.pythonanywhere.com)  
✅ Sempre online (24/7)  
✅ Banco de dados incluído  
💰 Grátis até 500MB e 100k requisições/dia

### **Opção 3: Hostinger (Profissional) 💼**
✅ Domínio personalizado (.com.br)  
✅ Alta performance  
✅ Suporte técnico  
💰 A partir de R$ 9,99/mês

---

## 🚀 OPÇÃO 1: NGROK (Começar Agora)

### **Passo 1: Criar Conta no Ngrok**

1. Acesse: https://dashboard.ngrok.com/signup
2. Cadastre-se (gratuito)
3. Vá em: **Your Authtoken** (após login)
4. Copie o token (exemplo: `2aB3cD4eF5gH6iJ7kL8mN9oP0qR`)

### **Passo 2: Configurar Authtoken**

```powershell
# Instalar ngrok (se ainda não tiver)
choco install ngrok
# OU baixar de: https://ngrok.com/download

# Configurar o token
ngrok config add-authtoken SEU_TOKEN_AQUI
```

### **Passo 3: Testar Localmente**

```powershell
# Ativar ambiente
.\.venv\Scripts\Activate.ps1

# Iniciar servidor Flask
python app.py
```

Acesse: http://localhost:5000 para confirmar que está funcionando

### **Passo 4: Expor para Internet**

**Terminal 1 (Flask):**
```powershell
.\.venv\Scripts\Activate.ps1
python app.py
```

**Terminal 2 (Ngrok):**
```powershell
ngrok http 5000 --region=sa
```

🎉 **Seu site estará online!** Copie a URL que aparece (ex: `https://abc123.ngrok-free.app`)

### **Passo 5: Script Automatizado**

Use o script pronto:
```powershell
.\start_production.ps1
# Escolha: Opção 2 (Flask + Ngrok)
```

---

## 🆓 OPÇÃO 2: PYTHONANYWHERE (Domínio Permanente)

### **Passo 1: Criar Conta**
1. Acesse: https://www.pythonanywhere.com/registration/register/beginner/
2. Escolha um nome de usuário (será seu domínio: `seuusuario.pythonanywhere.com`)
3. Cadastre-se gratuitamente

### **Passo 2: Fazer Upload dos Arquivos**

**Via Git (Recomendado):**
```bash
# No PythonAnywhere Console
cd ~
git clone https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git
```

**Via Upload Manual:**
1. Vá em: **Files** > **Upload a file**
2. Faça upload dos arquivos: `app.py`, `templates/`, `static/`, `requirements.txt`, `.env`

### **Passo 3: Configurar Web App**

1. Vá em: **Web** > **Add a new web app**
2. Escolha: **Flask**
3. Python version: **3.11**
4. Virtual environment: `/home/seuusuario/.virtualenvs/myvenv`

### **Passo 4: Instalar Dependências**

No **Bash console**:
```bash
cd /home/seuusuario/landingpage_house
pip install -r requirements.txt
```

### **Passo 5: Configurar WSGI**

Edite o arquivo WSGI (em **Web** > **WSGI configuration file**):

```python
import sys
import os

# Adicionar diretório do projeto ao PATH
path = '/home/seuusuario/landingpage_house'
if path not in sys.path:
    sys.path.insert(0, path)

# Carregar variáveis de ambiente
from dotenv import load_dotenv
load_dotenv(os.path.join(path, '.env'))

# Importar aplicação
from app import app as application
```

### **Passo 6: Ativar Site**

1. Clique em: **Reload seuusuario.pythonanywhere.com**
2. Acesse: `https://seuusuario.pythonanywhere.com`

🎉 **Site online 24/7 com domínio permanente!**

---

## 💼 OPÇÃO 3: HOSTINGER (Domínio Profissional)

### **Passo 1: Contratar Hospedagem**

1. Acesse: https://www.hostinger.com.br
2. Escolha: **Hospedagem Compartilhada** ou **VPS**
3. Registre domínio: `housealimentos.com.br`
4. Adicione SSL (HTTPS) - Geralmente incluído

### **Passo 2: Configurar VPS (se escolheu VPS)**

**SSH no servidor:**
```bash
ssh root@SEU_IP

# Atualizar sistema
apt update && apt upgrade -y

# Instalar dependências
apt install python3.11 python3.11-venv nginx supervisor -y

# Criar diretório
mkdir -p /var/www/housealimentos
cd /var/www/housealimentos

# Fazer upload dos arquivos (via FTP ou Git)
git clone https://github.com/SEU_USUARIO/SEU_REPOSITORIO.git .

# Criar ambiente virtual
python3.11 -m venv venv
source venv/bin/activate

# Instalar dependências
pip install -r requirements.txt
pip install gunicorn
```

### **Passo 3: Configurar Gunicorn**

Criar `/etc/supervisor/conf.d/housealimentos.conf`:
```ini
[program:housealimentos]
command=/var/www/housealimentos/venv/bin/gunicorn --workers 3 --bind 127.0.0.1:5000 app:app
directory=/var/www/housealimentos
user=www-data
autostart=true
autorestart=true
stderr_logfile=/var/log/housealimentos.err.log
stdout_logfile=/var/log/housealimentos.out.log
environment=FLASK_ENV="production"
```

```bash
supervisorctl reread
supervisorctl update
supervisorctl start housealimentos
```

### **Passo 4: Configurar Nginx**

Criar `/etc/nginx/sites-available/housealimentos`:
```nginx
server {
    listen 80;
    server_name housealimentos.com.br www.housealimentos.com.br;

    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /static {
        alias /var/www/housealimentos/static;
        expires 30d;
    }
}
```

```bash
ln -s /etc/nginx/sites-available/housealimentos /etc/nginx/sites-enabled/
nginx -t
systemctl restart nginx
```

### **Passo 5: Configurar SSL (HTTPS)**

```bash
apt install certbot python3-certbot-nginx -y
certbot --nginx -d housealimentos.com.br -d www.housealimentos.com.br
```

🎉 **Site online com domínio profissional e HTTPS!**

---

## 📊 Comparação das Opções

| Recurso | Ngrok | PythonAnywhere | Hostinger VPS |
|---------|-------|----------------|---------------|
| **Tempo de Setup** | 5 min | 20 min | 1 hora |
| **Custo Mensal** | Grátis* | Grátis* | R$ 20-50 |
| **Domínio Personalizado** | Pago (US$ 8/mês) | Não | Sim |
| **Sempre Online** | Não** | Sim | Sim |
| **Performance** | Boa | Média | Excelente |
| **Tráfego Ilimitado** | Não | Limitado | Sim |
| **Melhor Para** | Testes/Demos | Pequenos projetos | Produção |

\* Com limitações  
\** Precisa manter o computador ligado

---

## 🎯 Recomendação

### **Para começar AGORA:**
👉 **Ngrok** (5 minutos) - Use para testar e demonstrar

### **Para ter um site 24/7 gratuito:**
👉 **PythonAnywhere** - Melhor custo-benefício

### **Para um negócio profissional:**
👉 **Hostinger VPS** com domínio personalizado

---

## ❓ Qual opção você prefere?

Digite no terminal do VS Code:
- `1` para Ngrok (rápido para testar)
- `2` para PythonAnywhere (grátis e sempre online)
- `3` para Hostinger (profissional com domínio .com.br)
