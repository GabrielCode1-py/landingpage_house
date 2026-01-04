# 🚀 GUIA RÁPIDO - Colocar Site no Ar

## ⚡ Método Atual (Mais Simples)

### Iniciar o site:
```powershell
.\start_site.ps1
```

**Isso vai:**
1. Iniciar o Flask
2. Criar tunnel público do Cloudflare
3. Mostrar sua URL no formato: `https://xxxx-xxxx.trycloudflare.com`

**Para parar:** `Ctrl+C` no terminal

---

## 🌐 Para Domínio Próprio (www.seu-dominio.com)

### Opção A: Comprar domínio (.com.br = R$ 40/ano)

1. **Compre em:** https://registro.br/
2. **Adicione ao Cloudflare (grátis):** https://dash.cloudflare.com/sign-up
3. **Execute:**
```powershell
# Login no Cloudflare
cloudflared tunnel login

# Crie tunnel nomeado
cloudflared tunnel create house-alimentos

# Configure DNS (substitua pelo seu domínio)
cloudflared tunnel route dns house-alimentos housealimentos.com.br
cloudflared tunnel route dns house-alimentos www.housealimentos.com.br

# Crie config.yml em C:\Users\Gabriel Batista\.cloudflared\config.yml
```

**Conteúdo do config.yml:**
```yaml
tunnel: SEU-TUNNEL-ID-AQUI
credentials-file: C:\Users\Gabriel Batista\.cloudflared\SEU-TUNNEL-ID.json

ingress:
  - hostname: housealimentos.com.br
    service: http://localhost:5000
  - hostname: www.housealimentos.com.br
    service: http://localhost:5000
  - service: http_status:404
```

### Opção B: Subdomínio Grátis

**Sites que oferecem subdomínios grátis:**
- FreeDNS: https://freedns.afraid.org/ (ex: house-alimentos.mooo.com)
- DuckDNS: https://www.duckdns.org/ (ex: house-alimentos.duckdns.org)
- No-IP: https://www.noip.com/ (ex: house-alimentos.ddns.net)

Depois de criar, siga os mesmos passos da Opção A.

---

## 📊 Monitorar Site

### Ver logs em tempo real:
- Flask mostra todas as requisições no terminal
- Cloudflare mostra conexões estabelecidas

### Testar se está no ar:
```powershell
curl https://sua-url-aqui
```

---

## 🔍 SEO - Aparecer no Google

### 1. Google Search Console
```
https://search.google.com/search-console/
→ Adicionar propriedade: https://seu-dominio.com
→ Verificar propriedade
→ Enviar sitemap: https://seu-dominio.com/sitemap.xml
```

### 2. Google Business Profile (Local SEO)
```
https://www.google.com/business/
→ Adicionar: HOUSE Alimentos
→ Endereço: Fazenda Rio Grande, PR
→ Categoria: Padaria/Panificadora
```

### 3. Atualizar URLs nos arquivos

**Edite esses arquivos com seu domínio real:**
- `static/sitemap.xml` (linha 4, 9)
- `static/robots.txt` (linha 7)
- `templates/index.html` (linhas 14, 21, 23)

---

## ❓ Problemas Comuns

### "Port 5000 already in use"
```powershell
Get-Process python | Stop-Process -Force
```

### Cloudflare não conecta
```powershell
# Reinstale
winget install Cloudflare.cloudflared --force
```

### Flask não inicia
```powershell
# Reative ambiente virtual
.\.venv\Scripts\Activate.ps1
python app.py
```

---

## 📝 Status Atual

✅ Flask configurado
✅ Cloudflare Tunnel instalado  
✅ SEO otimizado (sitemap.xml, robots.txt, meta tags)
✅ Script de inicialização pronto

**Para colocar no ar agora:**
```powershell
.\start_site.ps1
```
