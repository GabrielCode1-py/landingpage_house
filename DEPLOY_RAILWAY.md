# 🚀 Deploy no Railway.app

## 📋 Pré-requisitos

- Conta no GitHub (já tem ✅)
- Repositório no GitHub atualizado (já tem ✅)
- Conta no Railway.app (criar agora)

## 🎯 Passo a Passo

### 1️⃣ Criar Conta no Railway

1. Acesse: https://railway.app
2. Clique em **"Start a New Project"**
3. Faça login com **GitHub** (recomendado)
4. Autorize o Railway a acessar seus repositórios

### 2️⃣ Criar Novo Projeto

1. No dashboard do Railway, clique em **"New Project"**
2. Selecione **"Deploy from GitHub repo"**
3. Escolha o repositório: **landingpage_house**
4. Railway detectará automaticamente que é um projeto Flask

### 3️⃣ Configurar Variáveis de Ambiente

No Railway, vá em **"Variables"** e adicione:

```
SECRET_KEY=coloque-uma-secret-key-super-segura-aqui-minimo-32-caracteres
MAIL_PASSWORD=lzpvlgrhpiexgyne
FLASK_ENV=production
```

**Gerar SECRET_KEY segura:**
```python
python -c "import secrets; print(secrets.token_urlsafe(32))"
```

### 4️⃣ Deploy Automático

1. Railway fará o deploy automaticamente
2. Aguarde 2-3 minutos
3. Você verá logs do build e deploy
4. Quando terminar, verá: **"Deployment Successful"**

### 5️⃣ Obter URL do Site

1. No painel do Railway, clique em **"Settings"**
2. Role até **"Domains"**
3. Clique em **"Generate Domain"**
4. Você receberá uma URL tipo: `https://seu-app.up.railway.app`

### 6️⃣ Configurar Domínio Customizado

Para usar **housealimentoss.com.br**:

1. No Railway, vá em **Settings > Domains**
2. Clique em **"Custom Domain"**
3. Digite: **housealimentoss.com.br**
4. Railway mostrará os registros DNS necessários

5. No **Cloudflare DNS**:
   - Remova os registros CNAME atuais
   - Adicione novo CNAME:
     ```
     Type: CNAME
     Name: @ (ou deixe em branco)
     Target: <url-fornecida-pelo-railway>
     Proxy: Desativado (DNS only)
     ```

6. Aguarde propagação DNS (2-10 minutos)

### 7️⃣ Verificação Final

1. Acesse: https://housealimentoss.com.br
2. Teste TODOS os elementos:
   - ✅ Menu hamburger
   - ✅ Carrosséis
   - ✅ Formulário de contato
   - ✅ Formulário Trabalhe Conosco
   - ✅ WhatsApp links
   - ✅ Google Maps

## 🎉 Vantagens do Railway

✅ **Sempre online** - Não precisa do PC ligado
✅ **Deploy automático** - Push no GitHub = deploy automático
✅ **Free tier** - $5/mês de crédito grátis
✅ **SSL automático** - HTTPS grátis
✅ **Logs em tempo real** - Debug fácil
✅ **Escala automática** - Aguenta picos de tráfego

## 💰 Custos

**Free Tier:**
- $5 de crédito por mês (grátis)
- Suficiente para sites pequenos/médios
- ~500.000 requisições/mês

**Se ultrapassar:**
- Paga apenas o que usar
- ~$0.000463/GB-hora
- Site pequeno: ~$3-5/mês

## 🔧 Manutenção

### Atualizar o Site:
```bash
git add .
git commit -m "Atualização"
git push
```
Railway fará deploy automático!

### Ver Logs:
1. Abra projeto no Railway
2. Clique na aba **"Deployments"**
3. Veja logs em tempo real

### Rollback:
1. Vá em **"Deployments"**
2. Encontre deploy anterior funcionando
3. Clique em **"Redeploy"**

## ⚠️ Importante

- **SECRET_KEY**: NUNCA commite no Git!
- **MAIL_PASSWORD**: Use variável de ambiente
- **Uploads**: Railway tem storage efêmero (arquivos somem no redeploy)
  - Para produção séria, use S3/Cloudinary

## 🆘 Troubleshooting

**Build falhou?**
- Verifique logs no Railway
- Confirme que `requirements.txt` está correto
- Python 3.10.14 especificado em `runtime.txt`

**Site não abre?**
- Verifique variáveis de ambiente
- Confirme que `gunicorn` está em `requirements.txt`
- Veja logs de deploy

**Erro 502?**
- App pode estar crashando
- Verifique logs para ver erro Python
- Confirme porta: Railway usa variável `$PORT`

## 📞 Suporte

- Documentação: https://docs.railway.app
- Discord: https://discord.gg/railway
- GitHub Issues: Problema no código
