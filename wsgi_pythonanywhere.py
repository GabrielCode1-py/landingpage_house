# ===========================
# WSGI Configuration File
# HOUSE Alimentos - PythonAnywhere
# ===========================

from app import app as application
import sys
import os
from dotenv import load_dotenv

# Configuração para housealimentos2026.pythonanywhere.com
project_home = '/home/housealimentos2026/mysite'

# Adicionar diretório do projeto ao PATH
if project_home not in sys.path:
    sys.path.insert(0, project_home)

# Carregar variáveis de ambiente do arquivo .env
load_dotenv(os.path.join(project_home, '.env'))

# Importar aplicação Flask

# Configuração para ambiente de produção
application.config['DEBUG'] = False
application.config['TESTING'] = False

# Log de inicialização
print(f"✅ HOUSE Alimentos carregado de: {project_home}")
print(f"✅ Python version: {sys.version}")
