"""Teste completo do formulário Trabalhe Conosco"""
import re
import requests
import os
from dotenv import load_dotenv

load_dotenv()

# URL do seu site (pode ser ngrok ou localhost)
BASE_URL = "http://localhost:5000"

print("========================================")
print("  TESTE: Formulário Trabalhe Conosco")
print("========================================")
print()

# Primeiro, pegar o CSRF token
print("[1/3] Obtendo página inicial...")
response = requests.get(BASE_URL)
if response.status_code != 200:
    print(f"❌ Erro ao acessar site: {response.status_code}")
    exit(1)

# Extrair CSRF token do HTML
csrf_match = re.search(r'name="csrf_token" value="([^"]+)"', response.text)
if not csrf_match:
    print("❌ CSRF token não encontrado!")
    exit(1)

csrf_token = csrf_match.group(1)
print(f"✅ CSRF token obtido: {csrf_token[:20]}...")

# Preparar dados do formulário
print()
print("[2/3] Enviando formulário...")

# Criar um arquivo PDF de teste
test_pdf = ('curriculo.pdf', b'%PDF-1.4 teste', 'application/pdf')

data = {
    'csrf_token': csrf_token,
    'nome': 'Teste Automatizado',
    'email': 'teste@example.com',
    'telefone': '(41) 99999-9999',
    'cargo': 'Padeiro',
    'resumo': 'Profissional com experiência em panificação e atendimento ao cliente.',
    'mensagem': 'Este é um teste automatizado do sistema de envio de email.'
}

files = {
    'curriculo': test_pdf
}

# Manter cookies da sessão
cookies = response.cookies

# Enviar POST
response = requests.post(
    f"{BASE_URL}/trabalhe-conosco",
    data=data,
    files=files,
    cookies=cookies,
    allow_redirects=False
)

print()
print("[3/3] Verificando resposta...")
print(f"Status Code: {response.status_code}")
print(f"Headers: {dict(response.headers)}")

if response.status_code in [200, 302]:
    if response.status_code == 302:
        print(f"✅ Redirecionamento para: {response.headers.get('Location')}")
    print()
    print("========================================")
    print("  RESULTADO DO TESTE")
    print("========================================")

    # Verificar se há mensagem de sucesso ou erro no HTML
    if 'mensagem' in response.text.lower() or 'sucesso' in response.text.lower():
        print("✅ Formulário processado com sucesso!")
    elif 'erro' in response.text.lower():
        print("⚠️ Possível erro no processamento")
    else:
        print("✅ Resposta recebida")

    print()
    print("📧 Verifique se o email foi recebido em:")
    print("   housealimentoss@gmail.com")

else:
    print(f"❌ Erro no envio: {response.status_code}")
    print(f"Resposta: {response.text[:500]}")
