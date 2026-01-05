# 🎯 GUIA RÁPIDO: Deploy no Railway em 5 Minutos

## 📱 PASSO A PASSO VISUAL

### 1️⃣ Criar Conta (30 segundos)

```
1. Abra: https://railway.app
2. Clique no botão roxo "Login"
3. Escolha "Login with GitHub"
4. Autorize Railway
```

### 2️⃣ Criar Projeto (1 minuto)

```
1. Clique em "+ New Project"
2. Selecione "Deploy from GitHub repo"
3. Escolha: GabrielCode1-py/landingpage_house
4. Clique no repositório
```

Railway vai detectar automaticamente que é Flask! ✅

### 3️⃣ Adicionar Variáveis (2 minutos)

Na tela do projeto, clique em **"Variables"** e adicione:

```env
SECRET_KEY=gNkyLOHmnXYIWXF0imXXCAIwf7dr_hUt13KwwU0QA-M
MAIL_PASSWORD=lzpvlgrhpiexgyne
FLASK_ENV=production
```

**Como adicionar:**
1. Clique em **"+ New Variable"**
2. Cole o nome (ex: `SECRET_KEY`)
3. Cole o valor
4. Clique em "Add"
5. Repita para as 3 variáveis

### 4️⃣ Aguardar Deploy (2 minutos)

Railway vai:
- ✅ Detectar Python
- ✅ Instalar dependências
- ✅ Rodar `gunicorn`
- ✅ Disponibilizar site

**Status:**
- 🔵 Building... (instalando)
- 🟢 Success! (pronto!)

### 5️⃣ Obter URL (30 segundos)

```
1. Clique em "Settings"
2. Encontre "Domains"
3. Clique em "Generate Domain"
4. Copie a URL: https://seu-site.up.railway.app
```

**TESTE A URL!** ✅

---

## 🌐 Configurar Domínio Customizado (OPCIONAL)

### No Railway:

```
1. Settings > Domains
2. Custom Domain
3. Digite: housealimentoss.com.br
4. Copie o valor CNAME fornecido
```

### No Cloudflare:

```
1. Acesse Cloudflare Dashboard
2. Selecione housealimentoss.com.br
3. Vá em "DNS"
4. Delete registros antigos do Cloudflare Tunnel
5. Adicione novo registro:
   
   Type: CNAME
   Name: @ 
   Target: <cole-url-do-railway-sem-https>
   Proxy: 🔴 DNS only (desligado)
   TTL: Auto
   
6. Clique "Save"
```

Aguarde 5-10 minutos para DNS propagar.

---

## ✅ Verificação Final

Teste TUDO:
- [ ] Site abre sem erros
- [ ] Menu hamburger funciona
- [ ] Carrosséis funcionam  
- [ ] Formulário de contato envia
- [ ] Formulário Trabalhe Conosco envia
- [ ] Links do WhatsApp funcionam
- [ ] Site funciona no celular

---

## 🎉 PRONTO!

Seu site agora está:
- ✅ **Na nuvem** - Não precisa do PC ligado
- ✅ **HTTPS grátis** - SSL automático
- ✅ **Deploy automático** - Push = deploy
- ✅ **Sempre online** - 99.9% uptime

---

## 🔧 Comandos Úteis

### Atualizar site:
```bash
git add .
git commit -m "Atualização"
git push
```
Railway faz deploy automático!

### Ver logs:
```
Railway Dashboard > Deployments > View Logs
```

### Rollback:
```
Railway Dashboard > Deployments > [deploy anterior] > Redeploy
```

---

## 💰 Custos

**Grátis:**
- $5/mês de crédito (suficiente para 99% dos casos)
- ~500.000 requisições/mês

**Se ultrapassar:**
- Paga apenas excedente
- Site pequeno: ~$2-5/mês

---

## ⚠️ IMPORTANTE

1. **Nunca commite** a SECRET_KEY no Git
2. **Use variáveis de ambiente** no Railway
3. **Uploads são efêmeros** - somem no redeploy
   - Para produção séria, use AWS S3 ou Cloudinary

---

## 🆘 Problemas?

**Build falhou?**
- Veja logs no Railway
- Verifique se adicionou as 3 variáveis
- Confirme que repositório está atualizado

**Site não abre?**
- Aguarde 2-3 minutos após primeiro deploy
- Verifique logs para ver erros
- Confirme variáveis de ambiente

**Erro 502?**
- App está crashando
- Veja logs: procure erro Python
- Verifique SECRET_KEY e MAIL_PASSWORD

---

## 📞 Suporte

- Railway Docs: https://docs.railway.app
- Discord Railway: https://discord.gg/railway
- Meu WhatsApp: 5541984967095

---

**Tempo total: ~5 minutos** ⏱️

🚀 **BOA SORTE!**
