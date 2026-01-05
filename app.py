"""
HOUSE Alimentos - Landing Page Institucional
Aplicação Flask com Alta Segurança para Produção

Desenvolvido para exposição pública via ngrok com domínio customizado
Inclui múltiplas camadas de segurança e boas práticas
"""

from flask import Flask, render_template, request, redirect, url_for, flash, jsonify, send_from_directory
from flask_wtf import FlaskForm, CSRFProtect
from flask_talisman import Talisman
from flask_limiter import Limiter
from flask_limiter.util import get_remote_address
from flask_mail import Mail, Message
from wtforms import StringField, TextAreaField, FileField
from wtforms.validators import DataRequired, Email, Length, ValidationError
from werkzeug.utils import secure_filename
from werkzeug.security import safe_join
from dotenv import load_dotenv
import os
import re
import logging
from datetime import datetime

# ===========================
# CONFIGURAÇÃO INICIAL
# ===========================

# Carregar variáveis de ambiente
load_dotenv()

# Configurar logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler('app.log'),
        logging.StreamHandler()
    ]
)
logger = logging.getLogger(__name__)

# ===========================
# INICIALIZAÇÃO DO APP
# ===========================

app = Flask(__name__)

# Detectar ambiente (Railway/Render/Heroku ou local)
IS_PRODUCTION = os.getenv('RAILWAY_ENVIRONMENT') or os.getenv(
    'RENDER') or os.getenv('DYNO')

# Configurações de segurança
app.config['SECRET_KEY'] = os.getenv(
    'SECRET_KEY', 'fallback-secret-key-change-in-production')
app.config['MAX_CONTENT_LENGTH'] = int(
    os.getenv('MAX_CONTENT_LENGTH', 5242880))
app.config['UPLOAD_FOLDER'] = os.getenv('UPLOAD_FOLDER', 'uploads')
app.config['ALLOWED_EXTENSIONS'] = set(
    os.getenv('ALLOWED_EXTENSIONS', 'pdf').split(','))
app.config['WTF_CSRF_TIME_LIMIT'] = None

# Cookies seguros (ativa HTTPS em produção)
app.config['SESSION_COOKIE_SECURE'] = bool(IS_PRODUCTION)
app.config['SESSION_COOKIE_HTTPONLY'] = True
app.config['SESSION_COOKIE_SAMESITE'] = 'Lax'

# Configuração de Email
app.config['MAIL_SERVER'] = 'smtp.gmail.com'
app.config['MAIL_PORT'] = 587
app.config['MAIL_USE_TLS'] = True
app.config['MAIL_USERNAME'] = 'housealimentoss@gmail.com'
app.config['MAIL_PASSWORD'] = os.getenv('MAIL_PASSWORD', '')
app.config['MAIL_DEFAULT_SENDER'] = 'housealimentoss@gmail.com'
app.config['MAIL_MAX_EMAILS'] = None
app.config['MAIL_ASCII_ATTACHMENTS'] = False

os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)

# ===========================
# EXTENSÕES DE SEGURANÇA
# ===========================

csrf = CSRFProtect(app)
mail = Mail(app)

limiter = Limiter(
    app=app,
    key_func=get_remote_address,
    default_limits=[os.getenv('RATELIMIT_DEFAULT', "100 per hour")],
    storage_uri=os.getenv('RATELIMIT_STORAGE_URL', "memory://")
)

# ===========================
# FORMULÁRIOS
# ===========================


def validate_phone_format(form, field):
    phone = re.sub(r'\D', '', field.data)
    if len(phone) not in [10, 11]:
        raise ValidationError('Telefone inválido')


def sanitize_text(text):
    if not text:
        return ''
    text = re.sub(r'<[^>]*>', '', text)
    text = re.sub(r'[\x00-\x1F\x7F]', '', text)
    return text.strip()


class ContactForm(FlaskForm):
    nome = StringField('Nome', validators=[
        DataRequired(message='Nome é obrigatório'),
        Length(min=2, max=100)
    ])
    email = StringField('Email', validators=[
        DataRequired(message='Email é obrigatório'),
        Email(message='Email inválido')
    ])
    telefone = StringField('Telefone')
    mensagem = TextAreaField('Mensagem', validators=[
        DataRequired(message='Mensagem é obrigatória'),
        Length(min=10, max=5000)
    ])


class JobApplicationForm(FlaskForm):
    nome = StringField('Nome', validators=[
        DataRequired(message='Nome é obrigatório'),
        Length(min=2, max=100)
    ])
    email = StringField('Email', validators=[
        DataRequired(message='Email é obrigatório'),
        Email(message='Email inválido')
    ])
    telefone = StringField('Telefone')
    resumo = TextAreaField('Resumo Profissional', validators=[
        DataRequired(message='Resumo é obrigatório (mínimo 20 caracteres)'),
        Length(min=20, max=5000, message='Resumo deve ter entre 20 e 5000 caracteres')
    ])
    curriculo = FileField('Currículo PDF', validators=[
        DataRequired(message='Currículo é obrigatório')
    ])

# ===========================
# FUNÇÕES AUXILIARES
# ===========================


def allowed_file(filename):
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower(
           ) in app.config['ALLOWED_EXTENSIONS']


def secure_file_upload(file):
    if not file or file.filename == '':
        return False, 'Nenhum arquivo enviado', None

    if not allowed_file(file.filename):
        return False, f'Apenas arquivos PDF são permitidos', None

    try:
        filename = secure_filename(file.filename)
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        name, ext = os.path.splitext(filename)
        filename = f"{name}_{timestamp}{ext}"
        filepath = safe_join(app.config['UPLOAD_FOLDER'], filename)
        file.save(filepath)

        if not os.path.exists(filepath) or os.path.getsize(filepath) == 0:
            return False, 'Erro ao salvar arquivo', None

        logger.info(f"Arquivo salvo: {filename}")
        return True, 'Arquivo enviado com sucesso', filename

    except Exception as e:
        logger.error(f"Erro no upload: {str(e)}")
        return False, 'Erro ao processar arquivo', None

# ===========================
# ROTAS
# ===========================


@app.route('/')
def index():
    current_year = datetime.now().year
    return render_template('index.html', current_year=current_year)


@app.route('/privacidade')
def privacidade():
    current_year = datetime.now().year
    return render_template('privacidade.html', current_year=current_year)


@app.route('/contato', methods=['POST'])
@limiter.limit("10 per hour")
def contato():
    try:
        form = ContactForm()

        if form.validate_on_submit():
            nome = sanitize_text(form.nome.data)
            email = form.email.data.strip().lower()
            telefone = re.sub(
                r'\D', '', form.telefone.data) if form.telefone.data else ''
            mensagem = sanitize_text(form.mensagem.data)

            # Enviar email
            try:
                msg = Message(
                    subject=f"Formulário de Contato - {nome}",
                    recipients=['housealimentoss@gmail.com'],
                    reply_to=email,
                    body=f"""
Nova mensagem de contato recebida:

Nome: {nome}
Email: {email}
Telefone: {telefone if telefone else 'Não informado'}

Mensagem:
{mensagem}

---
Enviado via formulário de contato do site HOUSE Alimentos
Data/Hora: {datetime.now().strftime('%d/%m/%Y às %H:%M')}
"""
                )
                mail.send(msg)
                logger.info(f"Email enviado - Contato de {nome} ({email})")
            except Exception as email_error:
                logger.error(f"Erro ao enviar email: {str(email_error)}")
                # Continua mesmo se o email falhar

            return jsonify({
                'success': True,
                'message': 'Mensagem enviada com sucesso!'
            }), 200
        else:
            errors = []
            for field, field_errors in form.errors.items():
                errors.extend(field_errors)

            return jsonify({
                'success': False,
                'message': 'Erro na validação',
                'errors': errors
            }), 400

    except Exception as e:
        logger.error(f"Erro contato: {str(e)}")
        return jsonify({
            'success': False,
            'message': 'Erro ao processar solicitação'
        }), 500


@app.route('/trabalhe-conosco', methods=['POST'])
@limiter.limit("5 per hour")
def trabalhe_conosco():
    try:
        form = JobApplicationForm()

        if form.validate_on_submit():
            nome = sanitize_text(form.nome.data)
            email = form.email.data.strip().lower()
            telefone = re.sub(
                r'\D', '', form.telefone.data) if form.telefone.data else ''
            resumo = sanitize_text(form.resumo.data)

            file = request.files.get('curriculo')
            success, message, filename = secure_file_upload(file)

            if not success:
                logger.error(f"Erro upload: {message}")
                return jsonify({
                    'success': False,
                    'message': message
                }), 400

            # Enviar email com anexo
            try:
                msg = Message(
                    subject=f"Candidatos vagas - {nome}",
                    recipients=['housealimentoss@gmail.com'],
                    reply_to=email,
                    body=f"""
Nova candidatura recebida:

Nome: {nome}
Email: {email}
Telefone: {telefone if telefone else 'Não informado'}

Resumo/Apresentação:
{resumo}

---
Currículo anexado: {filename}
Enviado via formulário Trabalhe Conosco do site HOUSE Alimentos
Data/Hora: {datetime.now().strftime('%d/%m/%Y às %H:%M')}
"""
                )

                # Anexar arquivo PDF
                if filename:
                    file_path = os.path.join(
                        app.config['UPLOAD_FOLDER'], filename)
                    with open(file_path, 'rb') as f:
                        msg.attach(filename, 'application/pdf', f.read())

                mail.send(msg)
                logger.info(f"Email enviado - Candidatura de {nome} ({email})")
            except Exception as email_error:
                logger.error(f"Erro ao enviar email: {str(email_error)}")
                # Retorna sucesso mesmo se email falhar, pois arquivo foi salvo
                return jsonify({
                    'success': True,
                    'message': 'Candidatura recebida! (Email pendente)'
                }), 200

            logger.info(
                f"Candidatura - Nome: {nome}, Email: {email}, Arquivo: {filename}")

            return jsonify({
                'success': True,
                'message': 'Candidatura enviada com sucesso!'
            }), 200
        else:
            errors = []
            for field, field_errors in form.errors.items():
                errors.extend(field_errors)

            logger.error(f"Validação falhou: {form.errors}")
            return jsonify({
                'success': False,
                'message': 'Erro na validação',
                'errors': errors
            }), 400

    except Exception as e:
        logger.error(f"Erro trabalhe conosco: {str(e)}")
        import traceback
        logger.error(traceback.format_exc())
        return jsonify({
            'success': False,
            'message': 'Erro ao processar candidatura'
        }), 500

# ===========================
# TRATAMENTO DE ERROS
# ===========================


@app.errorhandler(404)
def not_found(e):
    return render_template('index.html', current_year=datetime.now().year), 404


# ===========================
# GOOGLE VERIFICATION
# ===========================

@app.route('/google<path:filename>.html')
def google_verification(filename):
    """Serve Google Search Console verification file"""
    try:
        return app.send_static_file(f'google{filename}.html')
    except:
        return "File not found", 404


@app.errorhandler(429)
def rate_limit_exceeded(e):
    return jsonify({
        'success': False,
        'message': 'Muitas requisições. Aguarde alguns minutos.'
    }), 429


@app.errorhandler(413)
def file_too_large(e):
    return jsonify({
        'success': False,
        'message': f'Arquivo muito grande. Máximo: 5MB'
    }), 413


@app.errorhandler(500)
def internal_error(e):
    logger.error(f"Erro 500: {str(e)}")
    return jsonify({
        'success': False,
        'message': 'Erro interno. Tente novamente.'
    }), 500

# ===========================
# HEADERS DE SEGURANÇA
# ===========================


@app.after_request
def set_security_headers(response):
    response.headers['X-Content-Type-Options'] = 'nosniff'
    response.headers['X-Frame-Options'] = 'DENY'
    response.headers['X-XSS-Protection'] = '1; mode=block'
    response.headers['Referrer-Policy'] = 'strict-origin-when-cross-origin'
    response.headers['Permissions-Policy'] = 'geolocation=(), microphone=(), camera=()'

    if request.path.startswith('/static/'):
        response.headers['Cache-Control'] = 'public, max-age=31536000'
    else:
        response.headers['Cache-Control'] = 'no-store'

    return response

# ===========================
# ROTAS SEO
# ===========================


@app.route('/sitemap.xml')
def sitemap():
    """Sitemap XML para SEO"""
    return send_from_directory('static', 'sitemap.xml', mimetype='application/xml')


@app.route('/robots.txt')
def robots():
    """Robots.txt para crawlers"""
    return send_from_directory('static', 'robots.txt', mimetype='text/plain')

# ===========================
# EXECUÇÃO
# ===========================


if __name__ == '__main__':
    is_production = os.getenv('FLASK_ENV') == 'production'

    if not is_production:
        logger.warning("⚠️  Modo desenvolvimento - NÃO use em produção!")

    app.run(
        host='0.0.0.0',
        port=5000,
        debug=False,
        threaded=True
    )
