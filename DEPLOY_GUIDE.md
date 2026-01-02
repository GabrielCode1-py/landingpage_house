# 🚀 Guia de Deploy para Produção

## 📋 Checklist Pré-Deploy

### 1. Configurações de Segurança

#### 1.1 Desabilitar Debug Mode
```python
# app.py
if __name__ == '__main__':
    app.run(debug=False, host='0.0.0.0', port=5000)
```

#### 1.2 Configurar Variáveis de Ambiente
Crie arquivo `.env` (NÃO commitar no git):
```env
SECRET_KEY=sua_chave_secreta_super_longa_e_aleatoria_aqui
FLASK_ENV=production
MAX_CONTENT_LENGTH=5242880
UPLOAD_FOLDER=uploads
```

Atualizar `app.py`:
```python
import os
from dotenv import load_dotenv

load_dotenv()

app.secret_key = os.environ.get('SECRET_KEY')
app.config['UPLOAD_FOLDER'] = os.environ.get('UPLOAD_FOLDER', 'uploads')
```

#### 1.3 Instalar Dependências de Produção
```bash
pip install python-dotenv gunicorn flask-limiter flask-talisman
```

#### 1.4 Atualizar requirements.txt
```bash
pip freeze > requirements.txt
```

---

## 🔧 Configuração do Servidor

### Opção 1: Gunicorn (Recomendado)

#### Instalar Gunicorn
```bash
pip install gunicorn
```

#### Executar Aplicação
```bash
gunicorn -w 4 -b 0.0.0.0:5000 app:app
```

#### Criar Serviço Systemd
Arquivo: `/etc/systemd/system/landinghouse.service`
```ini
[Unit]
Description=Landing House Flask App
After=network.target

[Service]
User=www-data
Group=www-data
WorkingDirectory=/var/www/landinghouse
Environment="PATH=/var/www/landinghouse/venv/bin"
ExecStart=/var/www/landinghouse/venv/bin/gunicorn -w 4 -b 127.0.0.1:5000 app:app

[Install]
WantedBy=multi-user.target
```

Habilitar e iniciar:
```bash
sudo systemctl enable landinghouse
sudo systemctl start landinghouse
sudo systemctl status landinghouse
```

---

### Opção 2: Nginx como Reverse Proxy

#### Instalar Nginx
```bash
sudo apt update
sudo apt install nginx
```

#### Configurar Nginx
Arquivo: `/etc/nginx/sites-available/landinghouse`
```nginx
server {
    listen 80;
    server_name seu-dominio.com.br www.seu-dominio.com.br;

    # Redirecionar HTTP para HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name seu-dominio.com.br www.seu-dominio.com.br;

    # Certificados SSL
    ssl_certificate /etc/letsencrypt/live/seu-dominio.com.br/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/seu-dominio.com.br/privkey.pem;
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    # Tamanho máximo de upload
    client_max_body_size 5M;

    # Logs
    access_log /var/log/nginx/landinghouse_access.log;
    error_log /var/log/nginx/landinghouse_error.log;

    # Arquivos estáticos
    location /static {
        alias /var/www/landinghouse/static;
        expires 30d;
        add_header Cache-Control "public, immutable";
    }

    location /uploads {
        deny all;
        return 403;
    }

    # Proxy para Flask
    location / {
        proxy_pass http://127.0.0.1:5000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_redirect off;
    }

    # Headers de segurança
    add_header X-Frame-Options "DENY" always;
    add_header X-Content-Type-Options "nosniff" always;
    add_header X-XSS-Protection "1; mode=block" always;
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
}
```

Habilitar site:
```bash
sudo ln -s /etc/nginx/sites-available/landinghouse /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

---

## 🔐 Configurar HTTPS com Let's Encrypt

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx

# Obter certificado
sudo certbot --nginx -d seu-dominio.com.br -d www.seu-dominio.com.br

# Renovação automática (já configurada)
sudo certbot renew --dry-run
```

---

## 🛡️ Hardening de Segurança

### 1. Firewall (UFW)
```bash
sudo ufw allow 22/tcp    # SSH
sudo ufw allow 80/tcp    # HTTP
sudo ufw allow 443/tcp   # HTTPS
sudo ufw enable
sudo ufw status
```

### 2. Fail2Ban (Proteção contra Brute Force)
```bash
sudo apt install fail2ban
sudo systemctl enable fail2ban
sudo systemctl start fail2ban
```

Configurar Fail2Ban para Nginx:
Arquivo: `/etc/fail2ban/jail.local`
```ini
[nginx-http-auth]
enabled = true
port = http,https
logpath = /var/log/nginx/error.log

[nginx-limit-req]
enabled = true
port = http,https
logpath = /var/log/nginx/error.log
```

### 3. Permissões de Arquivos
```bash
# Propriedade
sudo chown -R www-data:www-data /var/www/landinghouse

# Permissões
sudo chmod -R 755 /var/www/landinghouse
sudo chmod -R 700 /var/www/landinghouse/uploads
sudo chmod 600 /var/www/landinghouse/.env
```

---

## 📊 Monitoramento e Logs

### 1. Configurar Logrotate
Arquivo: `/etc/logrotate.d/landinghouse`
```
/var/www/landinghouse/*.log {
    daily
    rotate 14
    compress
    delaycompress
    notifempty
    missingok
    create 640 www-data www-data
}
```

### 2. Monitoramento com Supervisor (Alternativa)
```bash
sudo apt install supervisor
```

Arquivo: `/etc/supervisor/conf.d/landinghouse.conf`
```ini
[program:landinghouse]
command=/var/www/landinghouse/venv/bin/gunicorn -w 4 -b 127.0.0.1:5000 app:app
directory=/var/www/landinghouse
user=www-data
autostart=true
autorestart=true
stderr_logfile=/var/log/landinghouse/err.log
stdout_logfile=/var/log/landinghouse/out.log
```

---

## 💾 Backup Automatizado

### Script de Backup
Criar arquivo: `/usr/local/bin/backup_landinghouse.sh`
```bash
#!/bin/bash

BACKUP_DIR="/backup/landinghouse"
DATE=$(date +%Y%m%d_%H%M%S)
APP_DIR="/var/www/landinghouse"

# Criar diretório de backup
mkdir -p $BACKUP_DIR

# Backup de uploads
tar -czf $BACKUP_DIR/uploads_$DATE.tar.gz $APP_DIR/uploads/

# Backup de logs
tar -czf $BACKUP_DIR/logs_$DATE.tar.gz $APP_DIR/*.log

# Remover backups com mais de 30 dias
find $BACKUP_DIR -name "*.tar.gz" -mtime +30 -delete

echo "Backup concluído: $DATE"
```

Tornar executável:
```bash
sudo chmod +x /usr/local/bin/backup_landinghouse.sh
```

Agendar com Cron (diário às 2h):
```bash
sudo crontab -e
```

Adicionar:
```
0 2 * * * /usr/local/bin/backup_landinghouse.sh >> /var/log/backup_landinghouse.log 2>&1
```

---

## 🗄️ Banco de Dados (Opcional - Recomendado)

### Migrar de Logs para PostgreSQL

#### Instalar PostgreSQL
```bash
sudo apt install postgresql postgresql-contrib
```

#### Criar Banco de Dados
```bash
sudo -u postgres psql
```

```sql
CREATE DATABASE landinghouse;
CREATE USER landinghouse_user WITH PASSWORD 'senha_segura_aqui';
GRANT ALL PRIVILEGES ON DATABASE landinghouse TO landinghouse_user;
\q
```

#### Atualizar requirements.txt
```
psycopg2-binary
Flask-SQLAlchemy
```

#### Configurar SQLAlchemy (app.py)
```python
from flask_sqlalchemy import SQLAlchemy

app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL')
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)
```

---

## 🔍 Testes Pré-Deploy

### 1. Testes de Segurança
```bash
# Instalar OWASP ZAP
wget https://github.com/zaproxy/zaproxy/releases/download/latest/ZAP_LINUX.tar.gz
tar -xvf ZAP_LINUX.tar.gz

# Executar scan
./ZAP/zap.sh -cmd -quickurl https://seu-dominio.com.br
```

### 2. Testes de Performance
```bash
# Instalar Apache Bench
sudo apt install apache2-utils

# Teste de carga
ab -n 1000 -c 10 https://seu-dominio.com.br/
```

### 3. Verificar SSL
```bash
# SSL Labs
curl -X POST https://api.ssllabs.com/api/v3/analyze?host=seu-dominio.com.br
```

---

## 📱 Configuração de E-mail (Notificações)

### Usando Gmail SMTP (Desenvolvimento)
```python
import smtplib
from email.mime.text import MIMEText

def send_email(to_email, subject, body):
    smtp_server = "smtp.gmail.com"
    smtp_port = 587
    sender_email = os.environ.get('EMAIL_USER')
    sender_password = os.environ.get('EMAIL_PASSWORD')
    
    msg = MIMEText(body)
    msg['Subject'] = subject
    msg['From'] = sender_email
    msg['To'] = to_email
    
    with smtplib.SMTP(smtp_server, smtp_port) as server:
        server.starttls()
        server.login(sender_email, sender_password)
        server.send_message(msg)
```

---

## 🌐 CDN e Cache (Opcional)

### Cloudflare
1. Criar conta no Cloudflare
2. Adicionar seu domínio
3. Atualizar nameservers no registro.br
4. Ativar:
   - SSL/TLS Full (strict)
   - Always Use HTTPS
   - WAF (Web Application Firewall)
   - Rate Limiting
   - Bot Fight Mode

---

## ✅ Checklist Final

- [ ] Debug mode desabilitado
- [ ] Variáveis de ambiente configuradas
- [ ] HTTPS configurado com certificado válido
- [ ] Firewall configurado (UFW)
- [ ] Fail2Ban instalado e configurado
- [ ] Gunicorn rodando com systemd
- [ ] Nginx como reverse proxy
- [ ] Permissões de arquivos corretas
- [ ] Backup automatizado configurado
- [ ] Logs rotacionados (logrotate)
- [ ] Monitoramento ativo
- [ ] Testes de segurança realizados
- [ ] Testes de performance realizados
- [ ] SSL verificado (A+ no SSL Labs)
- [ ] LGPD compliance verificado
- [ ] DPO e canais de contato atualizados
- [ ] Documentação atualizada

---

## 🆘 Troubleshooting

### Aplicação não inicia
```bash
# Verificar logs
sudo journalctl -u landinghouse -n 50
sudo tail -f /var/log/nginx/error.log
```

### Erro 502 Bad Gateway
```bash
# Verificar se Gunicorn está rodando
sudo systemctl status landinghouse

# Reiniciar serviços
sudo systemctl restart landinghouse
sudo systemctl restart nginx
```

### Upload não funciona
```bash
# Verificar permissões
ls -la /var/www/landinghouse/uploads/
sudo chown -R www-data:www-data /var/www/landinghouse/uploads/
```

---

## 📞 Suporte

Para dúvidas ou problemas no deploy:
- Documentação Flask: https://flask.palletsprojects.com/
- Gunicorn Docs: https://docs.gunicorn.org/
- Nginx Docs: https://nginx.org/en/docs/

---

**Data**: Janeiro 2026  
**Versão**: 1.0
