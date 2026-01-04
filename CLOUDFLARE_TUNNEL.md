# 🌐 Guia: Cloudflare Tunnel - HOUSE Alimentos

## ⚡ Início Rápido (1 comando)

```powershell
.\start_cloudflare.ps1
```

Sua URL pública aparecerá no formato: `https://xxxx-xx-xx-xxx-xxx.trycloudflare.com`

---

## 📋 O que é Cloudflare Tunnel?

- ✅ **100% Gratuito** - sem limites de tempo ou tráfego
- ✅ **HTTPS Automático** - certificado SSL incluído
- ✅ **Zero Configuração** - não precisa criar conta (modo quick)
- ✅ **URL Pública** - acessível de qualquer lugar
- ✅ **Sem Porta Exposta** - mais seguro que port forwarding

---

## 🚀 Método 1: Script Automatizado (RECOMENDADO)

### Passo 1: Execute o script
```powershell
.\start_cloudflare.ps1
```

### Passo 2: Copie a URL
Procure por uma linha como:
```
+--------------------------------------------------------------------------------------------+
|  Your quick Tunnel has been created! Visit it at (it may take some time to be reachable):  |
|  https://xxxx-xxxx.trycloudflare.com                                                      |
+--------------------------------------------------------------------------------------------+
```

### Passo 3: Compartilhe
Envie essa URL para qualquer pessoa - ela poderá acessar seu site!

### Para Parar:
Pressione `Ctrl+C` no terminal

---

## 🔧 Método 2: Manual (Controle Total)

### Terminal 1 - Flask:
```powershell
.\.venv\Scripts\Activate.ps1
python app.py
```

### Terminal 2 - Cloudflare:
```powershell
cloudflared tunnel --url http://localhost:5000
```

---

## 🎯 Modo Permanente (URL Fixa)

Se quiser uma URL fixa (ex: `house-alimentos.example.com`):

### 1. Crie conta no Cloudflare (grátis)
https://dash.cloudflare.com/sign-up

### 2. Faça login via CLI
```powershell
cloudflared tunnel login
```

### 3. Crie tunnel nomeado
```powershell
cloudflared tunnel create house-alimentos
```

### 4. Configure domínio
```powershell
cloudflared tunnel route dns house-alimentos house-alimentos.your-domain.com
```

### 5. Execute com config
```powershell
cloudflared tunnel run house-alimentos
```

---

## 📊 Monitoramento

### Ver logs em tempo real:
O terminal do Cloudflare mostra:
- ✅ Requisições recebidas
- ✅ Status de conexão
- ✅ Erros (se houver)

### Dashboard do Cloudflare:
https://dash.cloudflare.com/ (se criou conta)

---

## ❓ Problemas Comuns

### Erro: "cloudflared not found"
```powershell
# Reinstale
winget install Cloudflare.cloudflared

# Ou baixe manualmente
# https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/install-and-setup/installation/
```

### Porta 5000 em uso:
```powershell
# Verifique se Flask já está rodando
Get-Process -Name python
```

### URL não funciona:
- Aguarde 10-30 segundos após a URL aparecer
- A primeira conexão pode demorar um pouco
- Verifique se Flask está rodando (terminal 1)

---

## 🔒 Segurança

### O Cloudflare Tunnel é seguro?
✅ **SIM!** Funciona via túnel criptografado outbound
- Não expõe sua porta 5000 diretamente
- Todo tráfego passa por CDN da Cloudflare
- HTTPS automático com certificado válido
- Proteção DDoS incluída

### Logs de Acesso:
Flask mostra todos os acessos no terminal 1

---

## 💡 Dicas

1. **Mantenha ambos terminais abertos** enquanto quiser que o site fique no ar
2. **URL muda a cada execução** (modo quick) - anote a URL quando aparecer
3. **Modo permanente** requer conta grátis mas tem URL fixa
4. **Compartilhe apenas com confiança** - qualquer um com a URL pode acessar

---

## 🎉 Pronto!

Seu site agora está acessível publicamente via HTTPS sem precisar de hospedagem!

**Tempo de setup:** < 1 minuto
**Custo:** R$ 0,00
**Limite de visitantes:** Ilimitado

---

## 📞 Suporte

- Documentação oficial: https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/
- Status: https://www.cloudflarestatus.com/
