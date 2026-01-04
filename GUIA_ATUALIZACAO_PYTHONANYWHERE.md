# 🔄 GUIA DE ATUALIZAÇÃO - PythonAnywhere
## HOUSE Alimentos v6.1.0 - Site Já Existente

---

## ⚡ ATUALIZAÇÃO RÁPIDA (5 minutos)

Seu site já está rodando, vamos apenas atualizar para a versão v6.1.0 com as correções de layout.

---

## 📋 PASSO A PASSO

### **1. Abrir Console Bash**

1. Acesse: https://www.pythonanywhere.com
2. Faça login
3. Vá em **"Consoles"**
4. Clique em **"Bash"** (ou abra um console existente)

---

### **2. Ir para o Diretório do Projeto**

```bash
cd ~/landingpage_house
```

---

### **3. Ativar Ambiente Virtual**

```bash
workon house-env
```

**Deve aparecer:** `(house-env)` no início da linha

---

### **4. Fazer Backup (Opcional mas Recomendado)**

```bash
# Criar backup da versão atual
cp -r ~/landingpage_house ~/landingpage_house_backup_$(date +%Y%m%d)

# Verificar backup
ls -la ~/ | grep landingpage
```

---

### **5. Puxar Atualizações do GitHub**

```bash
# Garantir que está no diretório certo
cd ~/landingpage_house

# Verificar status atual
git status

# Puxar as atualizações
git pull origin master

# Verificar a nova versão
git log --oneline -3
```

**Deve mostrar os commits recentes:**
- 📖 Docs: Guia Completo e Checklist
- 📚 Docs: Release Notes v6.1.0
- 🎨 Hotfix v6.1: Correções de Centralização

---

### **6. Instalar Novas Dependências (se houver)**

```bash
# Garantir que ambiente está ativo
workon house-env

# Atualizar dependências
pip install -r requirements.txt --upgrade
```

---

### **7. Verificar Arquivos Atualizados**

```bash
# Ver o que foi alterado
git log --stat -1

# Deve mostrar:
# static/css/style.css (alterado)
# Novos arquivos de documentação
```

---

### **8. Reload no Web App** 🚀

1. Volte para o Dashboard do PythonAnywhere
2. Clique na aba **"Web"**
3. Clique no botão verde **"Reload seuusername.pythonanywhere.com"**
4. Aguarde 10-15 segundos

---

### **9. Testar o Site**

1. Clique no link do seu site (topo da página Web)
2. Ou acesse: `https://seuusername.pythonanywhere.com`

**Verificar:**
- ✅ Carousel do portfolio centralizado
- ✅ Estatísticas alinhadas
- ✅ Formulários centralizados em mobile
- ✅ Footer alinhado
- ✅ Botões hero carousel centralizados

---

### **10. Limpar Cache do Navegador**

Para ver as mudanças, limpe o cache:

**Chrome/Edge:**
- Pressione `Ctrl + Shift + R` (hard refresh)

**Firefox:**
- Pressione `Ctrl + F5`

Ou abra em **modo anônimo** para testar.

---

## ✅ PRONTO!

Seu site está atualizado com a versão v6.1.0! 🎉

---

## 🔍 VERIFICAR LOGS (Se algo der errado)

```bash
# Ver últimas 20 linhas do error log
tail -20 /var/log/seuusername.pythonanywhere.com.error.log

# Ou acesse via Web:
# Dashboard → Web → Log files → Error log
```

---

## 🆘 RESOLVER PROBLEMAS

### ❌ Erro após pull

**Se aparecer conflitos:**

```bash
cd ~/landingpage_house

# Ver arquivos em conflito
git status

# Se for o .env, mantenha o seu
git checkout --ours .env

# Completar o merge
git add .
git commit -m "Merge atualizações v6.1.0"
```

### ❌ CSS não atualiza

**Problema:** Cache do navegador ou PythonAnywhere

```bash
# 1. Limpar cache Python
cd ~/landingpage_house
find . -type d -name "__pycache__" -exec rm -r {} +

# 2. Reload no Web App
# Dashboard → Web → Reload

# 3. Hard refresh no navegador (Ctrl + Shift + R)
```

### ❌ Site não carrega

**Verificar Error Log:**

```bash
# Via terminal
cd ~
tail -50 /var/log/*.error.log

# Ou via Dashboard:
# Web → Log files → Error log
```

**Causa comum:** Ambiente virtual não configurado
```bash
# Reconfigurar virtualenv path no Web App:
# Web → Virtualenv → /home/SEUUSERNAME/.virtualenvs/house-env
```

---

## 🔄 REVERTER SE NECESSÁRIO

Se algo der errado, você pode voltar:

```bash
cd ~/landingpage_house

# Ver versões anteriores
git log --oneline -5

# Voltar para commit anterior
git reset --hard COMMIT_HASH

# Exemplo:
# git reset --hard 776d03f

# Reload no Web App
```

---

## 📊 O QUE FOI ATUALIZADO

### Versão v6.1.0 - Correções de Layout

**Arquivos modificados:**
- `static/css/style.css` (28 linhas alteradas)

**Melhorias:**
1. ✅ Carousel portfolio - imagens centralizadas
2. ✅ Grid estatísticas - alinhamento perfeito
3. ✅ Formulário Trabalhe Conosco - centralizado
4. ✅ Seção Contato - alinhamento consistente
5. ✅ Footer - layout profissional
6. ✅ Hero Carousel Mobile - botões centralizados

**Compatibilidade:**
- Desktop: 100%
- Tablet: 100%
- Mobile: 100%

---

## 📝 COMANDOS RESUMIDOS

Para futuras atualizações, use esta sequência:

```bash
# 1. Console Bash
cd ~/landingpage_house
workon house-env

# 2. Atualizar código
git pull origin master
pip install -r requirements.txt --upgrade

# 3. Reload
# Dashboard → Web → Reload
```

---

## 🎯 PRÓXIMA ATUALIZAÇÃO

Quando houver nova versão:

```bash
cd ~/landingpage_house
workon house-env
git fetch --tags
git checkout NOVA_VERSAO  # Ex: v6.2.0
pip install -r requirements.txt --upgrade
# Reload no Web App
```

---

## 📞 SUPORTE

**PythonAnywhere:**
- Help: https://help.pythonanywhere.com/
- Forum: https://www.pythonanywhere.com/forums/

**Projeto:**
- GitHub: https://github.com/GabrielCode1-py/landingpage_house
- Issues: https://github.com/GabrielCode1-py/landingpage_house/issues

---

**Username GitHub:** GabrielCode1-py  
**Email:** gabrielbatista8850@gmail.com  
**Versão:** v6.1.0  
**Data:** 03/01/2026

🎉 **Boa Atualização!** 🎉
