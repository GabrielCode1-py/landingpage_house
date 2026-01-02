# 🏠 Landing Page House

Landing page profissional e completa desenvolvida com HTML5, CSS3, JavaScript e Python (Flask).  
**Responsiva, segura e em conformidade com a LGPD.**

---

## 📋 Estrutura do Projeto

```
landingpage_house/
│
├── templates/
│   ├── index.html              # Página principal
│   └── privacidade.html        # Política de privacidade (LGPD)
│
├── static/
│   ├── css/
│   │   └── style.css           # Estilos completos e responsivos
│   ├── js/
│   │   └── main.js             # JavaScript (vanilla)
│   └── images/                 # Imagens e assets
│       ├── hero-*.jpg          # Imagens do carousel hero
│       ├── office-*.jpg        # Imagens do escritório
│       └── about-history.jpg   # Imagem da história
│
├── uploads/                    # PDFs de currículos (não versionado)
├── app.py                      # Backend Flask com segurança
├── requirements.txt            # Dependências Python
├── create_placeholder_images.py # Script para gerar placeholders
├── .gitignore                  # Arquivos ignorados (dados sensíveis)
│
├── README.md                   # Este arquivo
├── SECURITY_REPORT.md          # Relatório de segurança detalhado
├── DEPLOY_GUIDE.md             # Guia completo de deploy
├── HERO_CAROUSEL_DOCS.md       # Documentação do carousel
└── SOBRE_SECTION_DOCS.md       # Documentação da seção Sobre
```

---

## ✨ Funcionalidades

### 🎨 Frontend
- ✅ **Design responsivo** (mobile-first)
- ✅ **Hero carousel** com autoplay, navegação e swipe
- ✅ **Menu sidebar** com overlay e animações
- ✅ **Smooth scroll** entre seções
- ✅ **Animações** ao scroll (IntersectionObserver)
- ✅ **Contadores animados** na seção de estatísticas
- ✅ **Formulários** com validação JavaScript
- ✅ **Upload de arquivos** com preview
- ✅ **Botão "voltar ao topo"**
- ✅ **Footer dinâmico** com ano automático

### 🔐 Backend & Segurança
- ✅ **Flask** com headers de segurança HTTP
- ✅ **Rate limiting** (proteção contra spam/brute force)
- ✅ **Validação e sanitização** de entrada
- ✅ **Upload seguro** de PDFs (5MB máximo)
- ✅ **Prevenção de path traversal**
- ✅ **Session cookies** seguros
- ✅ **Logs detalhados** (contatos e candidaturas)
- ✅ **Conformidade LGPD** completa

### 📄 Seções da Página
1. **Home/Hero**: Carousel com 3 slides
2. **Quem Somos**: História, valores, galeria, estatísticas
3. **Serviços**: Cards de serviços
4. **Portfólio**: Carousel de projetos
5. **Trabalhe Conosco**: Formulário + upload de currículo
6. **Contato**: Formulário de contato
7. **Footer**: Links, redes sociais, política de privacidade

---

## 🛠️ Tecnologias Utilizadas

### Frontend
- **HTML5**: Estrutura semântica
- **CSS3**: Custom properties, Grid, Flexbox, animations
- **JavaScript (Vanilla)**: Sem frameworks, código nativo

### Backend
- **Python 3.13+**
- **Flask 3.0.0**: Framework web minimalista
- **Werkzeug 3.0.1**: Segurança de arquivos
- **Pillow 11.3.0**: Geração de imagens placeholder

### Segurança
- Rate limiting customizado
- Headers HTTP de segurança
- Validação e sanitização de dados
- CSRF protection ready
- HTTPS ready (produção)

---

## 📦 Instalação

### Pré-requisitos
- Python 3.13 ou superior
- pip (gerenciador de pacotes Python)

### 1. Clonar ou baixar o projeto

```bash
cd landingpage_house
```

### 2. Criar ambiente virtual (recomendado)

```bash
python -m venv venv
```

### 3. Ativar o ambiente virtual

**Windows:**
```bash
venv\Scripts\activate
```

**Linux/Mac:**
```bash
source venv/bin/activate
```

### 4. Instalar dependências

```bash
pip install -r requirements.txt
```

### 5. Gerar imagens placeholder (opcional)

```bash
python create_placeholder_images.py
```

---

## ▶️ Como Executar

### Desenvolvimento

1. Ative o ambiente virtual
2. Execute o servidor Flask:

```bash
python app.py
```

3. Acesse no navegador:
```
http://localhost:5000
```

4. Para a política de privacidade:
```
http://localhost:5000/privacidade
```

### Produção

Consulte o guia completo em **[DEPLOY_GUIDE.md](DEPLOY_GUIDE.md)**

---

## 📱 Responsividade Garantida

Testado e otimizado para todos os dispositivos:

| Dispositivo | Resolução | Status |
|-------------|-----------|--------|
| Mobile Small | 320px - 480px | ✅ |
| Mobile | 481px - 767px | ✅ |
| Tablet | 768px - 967px | ✅ |
| Desktop | 968px - 1200px | ✅ |
| Large Desktop | 1201px+ | ✅ |

### Componentes Responsivos:
- ✅ Header com logo adaptável
- ✅ Menu sidebar fullscreen em mobile
- ✅ Hero carousel com touch/swipe
- ✅ Grids adaptativos (2-col → 1-col)
- ✅ Galeria de imagens responsiva
- ✅ Formulários mobile-friendly
- ✅ Footer stack vertical em mobile

---

## 🔐 Segurança (LGPD Compliant)

### Medidas Implementadas:
- ✅ **Headers HTTP** de segurança
- ✅ **Rate limiting** (proteção contra spam)
- ✅ **Validação** e sanitização de entrada
- ✅ **Upload seguro** de arquivos
- ✅ **Session cookies** seguros (HttpOnly, Secure, SameSite)
- ✅ **Logs detalhados** para auditoria
- ✅ **Política de privacidade** completa
- ✅ **Conformidade LGPD** (Lei nº 13.709/2018)

### Dados Protegidos:
- 📄 Currículos em PDF (pasta `uploads/`)
- 📝 Logs de contato (`contatos.log`)
- 📝 Logs de candidaturas (`candidaturas.log`)

**Importante**: Esses arquivos **NÃO são versionados** (estão no `.gitignore`)

Consulte **[SECURITY_REPORT.md](SECURITY_REPORT.md)** para detalhes completos.

---

## 📂 Seções da Landing Page

### 1. 🏠 Hero (Home)
Carousel principal com:
- 3 slides com imagens/gifs/vídeos
- Autoplay (6 segundos)
- Navegação por setas e indicadores
- Suporte a touch/swipe
- Animações Ken Burns

### 2. 👥 Quem Somos
- História da empresa com imagem
- Missão, visão e valores (3 cards)
- Galeria do escritório (5 imagens, grid assimétrico)
- Estatísticas animadas (4 contadores)

### 3. 💼 Serviços
Cards com serviços oferecidos

### 4. 🎨 Portfólio
Carousel de projetos realizados

### 5. 💼 Trabalhe Conosco
- Formulário completo (nome, email, telefone, resumo)
- Upload de currículo em PDF (máx. 5MB)
- Validação frontend e backend
- Benefícios da empresa
- Feedback visual

### 6. 📧 Contato
- Formulário de mensagem
- Validação de campos
- Feedback de sucesso/erro

### 7. 🔻 Footer
- Links rápidos
- Redes sociais
- Ano dinâmico (2026)
- Link para política de privacidade
- Menção à LGPD

---

## 🔧 Configuração

### Variáveis de Ambiente (Produção)

Crie arquivo `.env`:
```env
SECRET_KEY=sua_chave_super_secreta_aqui
FLASK_ENV=production
MAX_CONTENT_LENGTH=5242880
UPLOAD_FOLDER=uploads
```

### Configurações de Upload
```python
# app.py
MAX_FILE_SIZE = 5 * 1024 * 1024  # 5MB
ALLOWED_EXTENSIONS = {'pdf'}
```

---

## 🎨 Personalização

### Cores (CSS Variables)
Edite em `static/css/style.css`:

```css
:root {
    --primary-color: #6366f1;      /* Cor principal */
    --secondary-color: #f43f5e;    /* Cor secundária */
    --title-color: #1e293b;        /* Títulos */
    --text-color: #475569;         /* Texto */
    --bg-color: #ffffff;           /* Fundo */
    /* ... outras variáveis */
}
```

### Conteúdo
Substitua textos e imagens placeholder pelos seus:

**Imagens:**
- `static/images/hero-*.jpg` - Imagens do carousel
- `static/images/office-*.jpg` - Fotos do escritório
- `static/images/about-history.jpg` - Imagem da história

**Textos:**
- `templates/index.html` - Todos os textos da página
- `templates/privacidade.html` - Dados da empresa

---

## 📚 Documentação Adicional

- **[SECURITY_REPORT.md](SECURITY_REPORT.md)** - Relatório completo de segurança
- **[DEPLOY_GUIDE.md](DEPLOY_GUIDE.md)** - Guia de deploy para produção
- **[HERO_CAROUSEL_DOCS.md](HERO_CAROUSEL_DOCS.md)** - Documentação do carousel
- **[SOBRE_SECTION_DOCS.md](SOBRE_SECTION_DOCS.md)** - Documentação da seção Sobre

---

## 🔍 Estrutura de Rotas

| Rota | Método | Descrição |
|------|--------|-----------|
| `/` | GET | Página principal |
| `/privacidade` | GET | Política de privacidade |
| `/contato` | POST | Processa formulário de contato |
| `/trabalhe-conosco` | POST | Processa candidatura + currículo |
| `/upload` | POST | Upload genérico de PDF |

---

## 🐛 Troubleshooting

### Erro: ModuleNotFoundError
```bash
# Certifique-se de instalar as dependências
pip install -r requirements.txt
```

### Erro: Address already in use
```bash
# Porta 5000 em uso, altere em app.py:
app.run(debug=True, host='0.0.0.0', port=8000)
```

### Upload não funciona
```bash
# Verifique se a pasta existe
mkdir uploads
```

### Imagens não aparecem
```bash
# Gere as imagens placeholder
python create_placeholder_images.py
```

---

## 🤝 Contribuindo

1. Fork o projeto
2. Crie uma branch para sua feature (`git checkout -b feature/MinhaFeature`)
3. Commit suas mudanças (`git commit -m 'Adiciona MinhaFeature'`)
4. Push para a branch (`git push origin feature/MinhaFeature`)
5. Abra um Pull Request

---

## ⚠️ Avisos Importantes

### 🔒 Segurança
- **NUNCA** commite arquivos `.log` ou a pasta `uploads/`
- **SEMPRE** use HTTPS em produção
- **MUDE** a `SECRET_KEY` antes do deploy
- **CONFIGURE** backup dos dados sensíveis

### 📋 LGPD
- Mantenha a política de privacidade atualizada
- Responda solicitações de titulares em até 15 dias
- Mantenha logs de acesso aos dados
- Implemente processo de exclusão de dados

### 🚀 Produção
- Desabilite `debug=False`
- Use servidor WSGI (Gunicorn)
- Configure Nginx como reverse proxy
- Implemente HTTPS obrigatório
- Configure firewall (UFW)
- Implemente monitoramento

---

## 📊 Checklist de Deploy

- [ ] Debug mode desabilitado
- [ ] SECRET_KEY gerada aleatoriamente
- [ ] Variáveis de ambiente configuradas
- [ ] HTTPS habilitado
- [ ] Firewall configurado
- [ ] Backup automatizado
- [ ] Monitoramento ativo
- [ ] Logs rotacionados
- [ ] Política de privacidade atualizada
- [ ] Contato do DPO configurado

---

## 📄 Licença

Este projeto é de uso livre para fins educacionais e comerciais.

---

## 👤 Autor

**Landing House Development Team**

---

## 📞 Suporte

- **Issues**: Abra uma issue no GitHub
- **Email**: contato@landinghouse.com.br
- **Privacidade**: privacidade@landinghouse.com.br
- **DPO**: dpo@landinghouse.com.br

---

## 🎉 Agradecimentos

- Flask community
- Python community
- Todos os contribuidores

---

**Desenvolvido com ❤️ em 2026**
