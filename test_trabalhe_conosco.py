"""Teste do formulário Trabalhe Conosco"""
from flask import Flask
from flask_mail import Mail, Message
from dotenv import load_dotenv
import os

load_dotenv()

app = Flask(__name__)
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'housealimentoss@gmail.com'
app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD', '')
app.config['MAIL_DEFAULT_SENDER'] = 'housealimentoss@gmail.com'
app.config['UPLOAD_FOLDER'] = 'uploads'

mail = Mail(app)

# Criar PDF de teste
test_pdf_path = os.path.join('uploads', 'teste_curriculo.pdf')
os.makedirs('uploads', exist_ok=True)
with open(test_pdf_path, 'wb') as f:
    f.write(
        b'%PDF-1.4\n%Test PDF\n1 0 obj\n<< /Type /Catalog /Pages 2 0 R >>\nendobj\n2 0 obj\n<< /Type /Pages /Kids [3 0 R] /Count 1 >>\nendobj\n3 0 obj\n<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] >>\nendobj\nxref\n0 4\n0000000000 65535 f\n0000000009 00000 n\n0000000056 00000 n\n0000000115 00000 n\ntrailer\n<< /Size 4 /Root 1 0 R >>\nstartxref\n190\n%%EOF')

print("PDF de teste criado!")

with app.app_context():
    try:
        nome = "João Silva"
        email = "joao@teste.com"
        telefone = "11999887766"
        resumo = "Profissional com 5 anos de experiência na área de panificação"

        msg = Message(
            subject=f"Candidatos vagas - {nome}",
            recipients=['housealimentoss@gmail.com'],
            reply_to=email,
            body=f"""
Nova candidatura recebida:

Nome: {nome}
Email: {email}
Telefone: {telefone}

Resumo/Apresentação:
{resumo}

---
Currículo anexado: teste_curriculo.pdf
Enviado via formulário Trabalhe Conosco do site HOUSE Alimentos
Data/Hora: 03/01/2026 às 18:45
"""
        )

        # Anexar PDF
        with open(test_pdf_path, 'rb') as f:
            msg.attach('teste_curriculo.pdf', 'application/pdf', f.read())

        print("Enviando email com anexo...")
        mail.send(msg)
        print("✅ Email com anexo enviado com sucesso!")

    except Exception as e:
        print(f"❌ Erro ao enviar email: {str(e)}")
        import traceback
        traceback.print_exc()
