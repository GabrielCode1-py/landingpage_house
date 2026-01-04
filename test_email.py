"""Teste de envio de email"""
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

print(
    f"MAIL_PASSWORD está configurada: {'Sim' if os.getenv('MAIL_PASSWORD') else 'Não'}")
print(f"Tamanho da senha: {len(os.getenv('MAIL_PASSWORD', ''))}")

mail = Mail(app)

with app.app_context():
    try:
        msg = Message(
            subject="Teste - HOUSE Alimentos",
            recipients=['housealimentoss@gmail.com'],
            body="Este é um email de teste do sistema.\n\nSe você recebeu esta mensagem, o sistema está funcionando!"
        )
        mail.send(msg)
        print("✅ Email enviado com sucesso!")
    except Exception as e:
        print(f"❌ Erro ao enviar email: {str(e)}")
        import traceback
        traceback.print_exc()
