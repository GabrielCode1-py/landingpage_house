# 🌐 GUIA: Ter www.housealimentos.com.br

## 💰 CUSTOS

**Opção 1: Domínio Próprio**
- `.com.br` = R$ 40/ano
- `.com` = R$ 60/ano  
- Cloudflare = GRÁTIS

**Opção 2: Subdomínio Grátis**
- `housealimentos.mooo.com` = R$ 0
- `housealimentos.duckdns.org` = R$ 0

---

## 🚀 PROCESSO COMPLETO

### **1️⃣ COMPRAR DOMÍNIO**

**Registro.br (recomendado para .com.br):**
```
https://registro.br/busca/?fqdn=housealimentos.com.br
```
- Crie conta com CPF
- Pague R$ 40/ano
- Anote suas credenciais

**Alternativas:**
- HostGator: https://www.hostgator.com.br/
- GoDaddy: https://www.godaddy.com/pt-br
- Namecheap: https://www.namecheap.com/

---

### **2️⃣ CONFIGURAR (Execute depois da compra)**

```powershell
.\config_dominio.ps1
```

**O script vai fazer:**
1. ✅ Criar conta Cloudflare (grátis)
2. ✅ Baixar certificado
3. ✅ Criar tunnel nomeado
4. ✅ Configurar DNS automático
5. ✅ Gerar script de inicialização

**Você só precisa:**
- Seguir as instruções na tela
- Alterar nameservers no Registro.br
- Aguardar propagação DNS (2-48h)

---

### **3️⃣ INICIAR SITE**

```powershell
.\start_dominio.ps1
```

**Seu site estará em:**
- https://housealimentos.com.br
- https://www.housealimentos.com.br

---

## ⚡ ALTERNATIVA RÁPIDA (Subdomínio Grátis)

**1. FreeDNS (mais fácil):**
```
1. Acesse: https://freedns.afraid.org/signup/
2. Crie conta grátis
3. Subdomain → Create
4. Type: A
5. Subdomain: housealimentos
6. Domain: escolha um (mooo.com, zapto.org, etc)
7. Destination: 1.1.1.1 (temporário)
```

**2. Configure Cloudflare:**
```powershell
# Edite config_dominio.ps1 e substitua
$MEU_DOMINIO = "housealimentos.mooo.com"

# Execute
.\config_dominio.ps1
```

---

## 📋 CHECKLIST

- [ ] Domínio registrado ou subdomínio criado
- [ ] Conta Cloudflare criada (grátis)
- [ ] Nameservers alterados
- [ ] DNS propagado (teste: `nslookup housealimentos.com.br`)
- [ ] cert.pem baixado
- [ ] Script config_dominio.ps1 executado
- [ ] Site iniciado com start_dominio.ps1
- [ ] Testado: https://www.housealimentos.com.br

---

## ❓ PERGUNTAS FREQUENTES

**Q: Preciso pagar hospedagem?**
A: NÃO! Só o domínio (R$ 40/ano). Cloudflare é grátis.

**Q: Quanto tempo para ficar no ar?**
A: Após configurar: 2-48h (tempo de DNS propagar)

**Q: Posso usar domínio grátis?**
A: SIM! Use FreeDNS, DuckDNS ou No-IP

**Q: Preciso deixar PC ligado?**
A: SIM. Para hospedar permanentemente, considere VPS (R$ 20/mês)

**Q: Como testar se DNS propagou?**
```powershell
nslookup housealimentos.com.br
```

---

## 🎯 RESUMO RÁPIDO

**Para ter www.housealimentos.com.br:**

1. **Compre o domínio**: https://registro.br/ (R$ 40/ano)
2. **Execute**: `.\config_dominio.ps1`
3. **Altere nameservers** no painel do Registro.br
4. **Aguarde** 2-48h
5. **Inicie**: `.\start_dominio.ps1`

**OU use subdomínio grátis se não quiser gastar agora!**
