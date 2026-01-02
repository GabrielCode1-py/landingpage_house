# ====================================
# GUIA DE DEPLOY - HOUSE Alimentos
# Landing Page com Alta Segurança
# ====================================

## 1. INSTALAÇÃO DAS DEPENDÊNCIAS

```powershell
# Ativar ambiente virtual
.\.venv\Scripts\Activate.ps1

# Instalar dependências
pip install -r requirements.txt
```

## 2. CONFIGURAÇÃO DO AMBIENTE

### 2.1. Variáveis de Ambiente (.env)
- Copie `.env.example` para `.env`
- **IMPORTANTE:** Altere a SECRET_KEY para um valor único e seguro
- Configure outras variáveis conforme necessário

```powershell
# Gerar SECRET_KEY segura
python -c "import secrets; print(secrets.token_hex(32))"
```

### 2.2. Criar Diretórios
```powershell
mkdir uploads  # Já é criado automaticamente
```

## 3. NGROK - EXPOSIÇÃO PÚBLICA

### 3.1. Instalação
```powershell
# Via Chocolatey
choco install ngrok

# Ou baixe de: https://ngrok.com/download
```

### 3.2. Autenticação
```powershell
# Configure seu authtoken (obtenha em https://dashboard.ngrok.com)
ngrok config add-authtoken SEU_TOKEN_AQUI
```

### 3.3. Domínio Reservado (Opcional mas Recomendado)
1. Acesse https://dashboard.ngrok.com/domains
2. Reserve um domínio gratuito (ex: seu-dominio.ngrok-free.app)
3. Adicione ao arquivo `ngrok.yml`

### 3.4. Domínio Próprio (Opcional - Plano Pago)
1. No painel do ngrok, adicione seu domínio
2. Configure CNAME no seu provedor DNS:
   ```
   CNAME @ seu-dominio.ngrok-free.app
   ```
3. Atualize `ngrok.yml` com seu domínio

## 4. EXECUÇÃO

### 4.1. Servidor Flask (Terminal 1)
```powershell
# Desenvolvimento
python app.py

# Produção (recomendado)
$env:FLASK_ENV="production"
python app.py
```

### 4.2. Ngrok (Terminal 2)
```powershell
# Usando arquivo de configuração
ngrok start --config=ngrok.yml house-alimentos

# Ou comando simples
ngrok http 5000 --region=sa
```

### 4.3. Script Único (Opcional)
```powershell
# Execute tudo de uma vez
.\start_production.ps1
```

## 5. VERIFICAÇÕES DE SEGURANÇA

### 5.1. Checklist Antes de Publicar
- [ ] SECRET_KEY alterada no .env
- [ ] FLASK_ENV=production definida
- [ ] debug=False no app.py
- [ ] Logs configurados e funcionando
- [ ] Rate limiting testado
- [ ] Upload de PDF testado e limitado
- [ ] CSRF tokens ativos nos formulários
- [ ] HTTPS ativo via ngrok
- [ ] Headers de segurança presentes

### 5.2. Teste de Segurança
```powershell
# Verifique headers de segurança
curl -I https://seu-dominio.ngrok-free.app

# Deve mostrar:
# - X-Content-Type-Options: nosniff
# - X-Frame-Options: DENY
# - X-XSS-Protection: 1; mode=block
```

### 5.3. Logs
```powershell
# Monitore logs em tempo real
Get-Content app.log -Wait -Tail 50
```

## 6. MONITORAMENTO

### 6.1. Ngrok Dashboard
- Acesse: http://localhost:4040
- Monitore requisições em tempo real
- Inspecione headers e payloads

### 6.2. Flask Logs
- Arquivo: `app.log`
- Contém: requisições, erros, uploads

## 7. TROUBLESHOOTING

### Problema: "SECRET_KEY muito curta"
**Solução:** Gere nova chave com pelo menos 32 caracteres
```powershell
python -c "import secrets; print(secrets.token_hex(32))"
```

### Problema: "Rate limit não funciona"
**Solução:** Limpar cache de memória reiniciando app

### Problema: "Upload de PDF falha"
**Solução:** 
1. Verifique tamanho < 5MB
2. Confirme extensão .pdf
3. Veja logs em app.log

### Problema: "CSRF token inválido"
**Solução:**
1. Limpe cookies do navegador
2. Verifique se csrf_token está nos formulários
3. Confirme que Flask-WTF está instalado

### Problema: "Ngrok desconecta"
**Solução:**
1. Conta gratuita tem limite de tempo
2. Use domínio reservado
3. Considere plano pago para produção

## 8. MIGRAÇÃO PARA VPS (FUTURO)

### Quando migrar do ngrok para VPS:
1. Contrate VPS (DigitalOcean, AWS, Azure, etc)
2. Configure servidor web (Nginx ou Apache)
3. Use Gunicorn como WSGI server
4. Configure SSL com Let's Encrypt
5. Setup domínio próprio com DNS

### Comando Gunicorn (VPS):
```bash
gunicorn -w 4 -b 0.0.0.0:5000 --access-logfile - --error-logfile - app:app
```

## 9. BOAS PRÁTICAS

### 9.1. Nunca Expor
- SECRET_KEY
- Tokens de autenticação
- Senhas de email
- Credenciais de banco

### 9.2. Sempre Fazer
- Backup regular dos uploads
- Monitorar logs diariamente
- Atualizar dependências mensalmente
- Testar formulários semanalmente

### 9.3. Segurança Adicional (Futuro)
- Implementar reCAPTCHA nos formulários
- Adicionar autenticação 2FA para admin
- Configurar firewall no VPS
- Usar CDN (Cloudflare) para proteção DDoS
- Implementar backup automatizado

## 10. SUPORTE

### Logs
- Flask: `app.log`
- Ngrok: Dashboard em http://localhost:4040

### Documentação
- Flask: https://flask.palletsprojects.com/
- Flask-WTF: https://flask-wtf.readthedocs.io/
- Ngrok: https://ngrok.com/docs
- Flask-Limiter: https://flask-limiter.readthedocs.io/

---

**Desenvolvido para HOUSE Alimentos**
**Segurança em Múltiplas Camadas**
**Pronto para Produção**
