# 🚀 GUIA RÁPIDO: Domínio Próprio + Google

## 📋 OPÇÃO 1: Sem comprar domínio (Subdomínio Grátis)

### Use um subdomínio grátis:
- **FreeDNS** → https://freedns.afraid.org/
- **No-IP** → https://www.noip.com/
- **DuckDNS** → https://www.duckdns.org/

Exemplo: `house-alimentos.freedns.com`

---

## 💰 OPÇÃO 2: Comprar domínio próprio

### 1️⃣ Registre um domínio (R$ 40/ano)
```
Recomendados no Brasil:
- Registro.br → https://registro.br/ (R$ 40/ano .com.br)
- HostGator → https://www.hostgator.com.br/
- GoDaddy → https://www.godaddy.com/pt-br
```

### 2️⃣ Adicione domínio ao Cloudflare (GRÁTIS)
1. Acesse: https://dash.cloudflare.com/sign-up
2. Clique em "Add a Site"
3. Digite seu domínio: `housealimentos.com.br`
4. Escolha plano "Free" → Continue
5. Copie os nameservers que aparecerem (ex: `eva.ns.cloudflare.com`)

### 3️⃣ Altere DNS no registrador
No painel do Registro.br (ou onde comprou):
```
Substitua os nameservers por:
→ eva.ns.cloudflare.com
→ leo.ns.cloudflare.com
```
⏱️ Aguarde 2-48h para propagar

### 4️⃣ Configure Cloudflare Tunnel com domínio

Execute no PowerShell:

```powershell
# 1. Faça login no Cloudflare
$cloudflaredPath = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Cloudflare.cloudflared*\cloudflared.exe" | Select-Object -First 1 -ExpandProperty FullName
& $cloudflaredPath tunnel login

# 2. Crie tunnel nomeado
& $cloudflaredPath tunnel create house-alimentos

# 3. Configure DNS (SUBSTITUA SEU DOMÍNIO)
& $cloudflaredPath tunnel route dns house-alimentos house-alimentos.com.br
& $cloudflaredPath tunnel route dns house-alimentos www.house-alimentos.com.br

# 4. Crie arquivo de configuração
```

### 5️⃣ Crie arquivo config.yml

Salve em: `C:\Users\Gabriel Batista\.cloudflared\config.yml`

```yaml
tunnel: house-alimentos
credentials-file: C:\Users\Gabriel Batista\.cloudflared\<TUNNEL-ID>.json

ingress:
  - hostname: house-alimentos.com.br
    service: http://localhost:5000
  - hostname: www.house-alimentos.com.br
    service: http://localhost:5000
  - service: http_status:404
```

### 6️⃣ Execute tunnel permanente
```powershell
& $cloudflaredPath tunnel run house-alimentos
```

---

## 🔍 APARECER NO GOOGLE (comandos diretos)

### 1️⃣ Registre no Google Search Console
```
1. Acesse: https://search.google.com/search-console/
2. Clique "Adicionar propriedade"
3. Digite: https://www.seu-dominio.com.br
4. Verifique propriedade (método HTML tag ou DNS)
5. Envie sitemap: https://www.seu-dominio.com.br/sitemap.xml
```

### 2️⃣ Registre no Google Business (SEO Local)
```
https://www.google.com/business/
→ Adicione seu endereço: Fazenda Rio Grande, PR
→ Categoria: Padaria / Panificadora
→ Adicione fotos dos produtos
```

### 3️�️ Atualize sitemap.xml (já criei!)

Edite o arquivo: `static/sitemap.xml`
Substitua `seu-dominio.com.br` pelo seu domínio real

### 4️⃣ Indexe no Google instantaneamente
```powershell
# Ping para Google indexar
Invoke-WebRequest "https://www.google.com/ping?sitemap=https://www.seu-dominio.com.br/sitemap.xml"

# Bing também
Invoke-WebRequest "https://www.bing.com/ping?sitemap=https://www.seu-dominio.com.br/sitemap.xml"
```

### 5️⃣ Verifique indexação
```
Pesquise no Google:
site:seu-dominio.com.br
```

---

## ⚡ SCRIPT AUTOMATIZADO (Após configurar domínio)

Salve como `start_dominio.ps1`:

```powershell
# Inicia Flask
Start-Job -ScriptBlock {
    Set-Location "C:\Users\Gabriel Batista\OneDrive\Desktop\landingpage_house"
    & ".\.venv\Scripts\python.exe" app.py
}

Start-Sleep -Seconds 3

# Inicia Cloudflare Tunnel com domínio
$cloudflaredPath = Get-ChildItem "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\Cloudflare.cloudflared*\cloudflared.exe" | Select-Object -First 1 -ExpandProperty FullName
& $cloudflaredPath tunnel run house-alimentos
```

---

## 🎯 CHECKLIST FINAL

- [ ] Domínio registrado (ou subdomínio grátis configurado)
- [ ] DNS apontando para Cloudflare
- [ ] Tunnel nomeado criado
- [ ] config.yml configurado
- [ ] sitemap.xml atualizado com domínio real
- [ ] Registrado no Google Search Console
- [ ] Sitemap enviado ao Google
- [ ] Google Business Profile criado
- [ ] Testado: https://www.seu-dominio.com.br

---

## 🚨 ATALHO RÁPIDO (Recomendado)

**Use FreeDNS por enquanto (grátis):**

1. Cadastre em: https://freedns.afraid.org/
2. Crie subdomínio: `house-alimentos.mooo.com` (ou similar)
3. Configure Cloudflare Tunnel:
```powershell
cloudflared tunnel route dns house-alimentos house-alimentos.mooo.com
```
4. Pronto! Use esse domínio enquanto decide se compra .com.br

---

**Qual opção prefere?**
1. Subdomínio grátis (FreeDNS) - RÁPIDO
2. Comprar domínio .com.br - PROFISSIONAL
