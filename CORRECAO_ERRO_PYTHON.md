# 🔧 CORREÇÃO DE ERRO - Python 3.13 Incompatibilidade
## Solução para erro de instalação no PythonAnywhere

---

## ❌ PROBLEMA IDENTIFICADO

Você está usando **Python 3.13** (muito novo!) e alguns pacotes não são compatíveis ainda.

**Erro:** `KeyError: '__version__'` durante build de wheel

---

## ✅ SOLUÇÃO CORRETA (Recomendada)

### **Recriar ambiente virtual com Python 3.10**

Cole estes comandos no Console Bash do PythonAnywhere:

```bash
# 1. Desativar ambiente atual (se estiver ativo)
deactivate

# 2. Remover ambiente antigo
rmvirtualenv house-env

# 3. Criar novo ambiente com Python 3.10
mkvirtualenv --python=/usr/bin/python3.10 house-env

# 4. Ir para o projeto
cd ~/landingpage_house

# 5. Atualizar pip
pip install --upgrade pip

# 6. Instalar dependências (uma por vez para identificar problemas)
pip install Flask==3.0.0
pip install Werkzeug==3.0.1
pip install Flask-WTF==1.2.1
pip install Flask-Talisman==1.1.0
pip install Flask-Limiter==3.5.0
pip install python-dotenv==1.0.0
pip install Flask-Mail==0.9.1
pip install WTForms==3.1.1
pip install email-validator==2.1.0
pip install Pillow==10.1.0

# 7. Verificar instalação
pip list
```

---

## 🚀 DEPOIS DE INSTALAR

```bash
# 1. Verificar que tudo está OK
python -c "import flask; print(flask.__version__)"

# 2. Testar o app
python -c "import app; print('App OK!')"
```

---

## 🔄 RECONFIGURAR WEB APP

**IMPORTANTE:** Depois de recriar o ambiente, você precisa atualizar o path no Web App:

1. Dashboard → Aba **"Web"**
2. Scroll até **"Virtualenv"**
3. Confirme que está: `/home/SEUUSERNAME/.virtualenvs/house-env`
4. Se não estiver, clique e adicione esse path
5. Clique em **"Reload"**

---

## 🎯 SCRIPT COMPLETO (Cole tudo de uma vez)

```bash
#!/bin/bash
echo "🔧 Recriando ambiente virtual com Python 3.10..."

# Desativar e remover ambiente antigo
deactivate 2>/dev/null || true
rmvirtualenv house-env 2>/dev/null || true

# Criar novo ambiente
mkvirtualenv --python=/usr/bin/python3.10 house-env

# Ir para projeto
cd ~/landingpage_house

# Atualizar pip
pip install --upgrade pip

# Instalar dependências
echo "📦 Instalando Flask..."
pip install Flask==3.0.0 Werkzeug==3.0.1

echo "📦 Instalando extensões Flask..."
pip install Flask-WTF==1.2.1 Flask-Talisman==1.1.0 Flask-Limiter==3.5.0

echo "📦 Instalando utilitários..."
pip install python-dotenv==1.0.0 Flask-Mail==0.9.1

echo "📦 Instalando validadores..."
pip install WTForms==3.1.1 email-validator==2.1.0

echo "📦 Instalando Pillow..."
pip install Pillow==10.1.0

echo ""
echo "✅ Instalação concluída!"
echo ""
echo "🧪 Testando instalação..."
python -c "import flask; print('Flask:', flask.__version__)"
python -c "from app import app; print('App: OK!')"

echo ""
echo "✅ Tudo pronto!"
echo ""
echo "📝 Próximo passo:"
echo "   1. Dashboard → Web → Reload"
echo "   2. Testar seu site"
```

---

## 🆘 SE AINDA HOUVER ERRO

### **Opção 1: Instalar sem versões específicas**

```bash
cd ~/landingpage_house
workon house-env

pip install Flask Werkzeug Flask-WTF Flask-Talisman Flask-Limiter \
            python-dotenv Flask-Mail WTForms email-validator Pillow
```

### **Opção 2: Usar requirements-minimal.txt**

Crie um arquivo temporário com versões mais flexíveis:

```bash
cd ~/landingpage_house
cat > requirements-minimal.txt << 'EOF'
Flask>=3.0
Werkzeug>=3.0
Flask-WTF>=1.2
Flask-Talisman>=1.1
Flask-Limiter>=3.5
python-dotenv>=1.0
Flask-Mail>=0.9
WTForms>=3.1
email-validator>=2.1
Pillow>=10.0
EOF

pip install -r requirements-minimal.txt
```

---

## 🔍 VERIFICAR PYTHON DISPONÍVEL

Para ver quais versões de Python estão disponíveis:

```bash
ls -la /usr/bin/python*
```

**Recomendado:**
- ✅ Python 3.10 - `--python=/usr/bin/python3.10`
- ✅ Python 3.9 - `--python=/usr/bin/python3.9`
- ⚠️ Python 3.13 - Muito novo, pode ter problemas

---

## 📋 CHECKLIST PÓS-INSTALAÇÃO

Depois de instalar tudo:

```bash
# 1. Verificar ambiente
workon house-env
which python
python --version  # Deve ser 3.10.x

# 2. Verificar pacotes instalados
pip list | grep -i flask

# 3. Testar importações
python << 'EOF'
try:
    from flask import Flask
    from flask_wtf import FlaskForm
    from flask_mail import Mail
    print("✅ Todas importações OK!")
except ImportError as e:
    print(f"❌ Erro: {e}")
EOF

# 4. Testar app
cd ~/landingpage_house
python -c "from app import app; print('✅ App carregado com sucesso!')"
```

---

## 🎯 VERSÕES COMPATÍVEIS TESTADAS

```
Python: 3.10.x
Flask: 3.0.0
Werkzeug: 3.0.1
Flask-WTF: 1.2.1
Flask-Talisman: 1.1.0
Flask-Limiter: 3.5.0
python-dotenv: 1.0.0
Flask-Mail: 0.9.1
WTForms: 3.1.1
email-validator: 2.1.0
Pillow: 10.1.0
```

---

## 💡 DICA PRO

**Sempre use Python 3.10 no PythonAnywhere para projetos Flask!**

Python 3.13 é muito recente (dezembro 2024) e muitos pacotes ainda não são totalmente compatíveis.

---

## 🔄 RESUMO DA CORREÇÃO

1. ❌ Problema: Python 3.13 incompatível
2. ✅ Solução: Recriar env com Python 3.10
3. 📦 Instalar: Pacotes um por um
4. 🔄 Reconfigurar: Virtualenv path no Web App
5. 🚀 Reload: Dashboard → Web → Reload

---

## ✅ APÓS CORREÇÃO

Seu site estará rodando perfeitamente com Python 3.10!

**Tempo estimado:** 5-10 minutos

---

**Versão:** v6.1.0  
**Data:** 03/01/2026  
**Python recomendado:** 3.10.x
