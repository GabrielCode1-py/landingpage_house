// ===========================
// VARIÁVEIS GLOBAIS
// ===========================
let currentSlide = 0;
const slidesData = [
    {
        title: 'E-commerce Moderno',
        description: 'Plataforma completa de vendas online'
    },
    {
        title: 'Aplicativo Corporativo',
        description: 'Sistema de gestão empresarial'
    },
    {
        title: 'Landing Page',
        description: 'Design criativo e conversão otimizada'
    }
];

// ===========================
// HERO CAROUSEL (SEÇÃO HOME)
// ===========================
function initHeroCarousel() {
    const carousel = document.getElementById('hero-carousel');
    if (!carousel) return;

    const slides = carousel.querySelectorAll('.hero-carousel__slide');
    const prevButton = document.getElementById('hero-prev');
    const nextButton = document.getElementById('hero-next');
    const indicators = carousel.querySelectorAll('.hero-carousel__indicator');
    const progressBar = document.getElementById('hero-progress');
    
    let currentSlide = 0;
    let autoplayInterval;
    const autoplayDelay = 6000; // 6 segundos por slide

    // Função para mudar de slide
    function goToSlide(index) {
        // Remover classe active de todos
        slides.forEach(slide => slide.classList.remove('active'));
        indicators.forEach(indicator => indicator.classList.remove('active'));

        // Adicionar classe active ao slide atual
        currentSlide = index;
        slides[currentSlide].classList.add('active');
        indicators[currentSlide].classList.add('active');

        // Resetar barra de progresso
        resetProgress();
    }

    // Próximo slide
    function nextSlide() {
        const next = (currentSlide + 1) % slides.length;
        goToSlide(next);
    }

    // Slide anterior
    function prevSlide() {
        const prev = (currentSlide - 1 + slides.length) % slides.length;
        goToSlide(prev);
    }

    // Barra de progresso
    function resetProgress() {
        if (progressBar) {
            progressBar.style.transition = 'none';
            progressBar.style.width = '0%';
            
            // Forçar reflow
            void progressBar.offsetWidth;
            
            progressBar.style.transition = `width ${autoplayDelay}ms linear`;
            progressBar.style.width = '100%';
        }
    }

    // Autoplay
    function startAutoplay() {
        stopAutoplay(); // Limpar qualquer interval existente
        
        autoplayInterval = setInterval(() => {
            nextSlide();
        }, autoplayDelay);

        resetProgress();
    }

    function stopAutoplay() {
        if (autoplayInterval) {
            clearInterval(autoplayInterval);
        }
        if (progressBar) {
            progressBar.style.transition = 'none';
            progressBar.style.width = '0%';
        }
    }

    // Event listeners para setas
    if (prevButton) {
        prevButton.addEventListener('click', () => {
            prevSlide();
            startAutoplay(); // Reiniciar autoplay após ação manual
        });
    }

    if (nextButton) {
        nextButton.addEventListener('click', () => {
            nextSlide();
            startAutoplay(); // Reiniciar autoplay após ação manual
        });
    }

    // Event listeners para indicadores
    indicators.forEach((indicator, index) => {
        indicator.addEventListener('click', () => {
            goToSlide(index);
            startAutoplay(); // Reiniciar autoplay após ação manual
        });
    });

    // Pausar ao passar o mouse
    carousel.addEventListener('mouseenter', () => {
        stopAutoplay();
    });

    carousel.addEventListener('mouseleave', () => {
        startAutoplay();
    });

    // Suporte a touch/swipe
    let touchStartX = 0;
    let touchEndX = 0;

    carousel.addEventListener('touchstart', (e) => {
        touchStartX = e.changedTouches[0].screenX;
        stopAutoplay();
    }, { passive: true });

    carousel.addEventListener('touchend', (e) => {
        touchEndX = e.changedTouches[0].screenX;
        handleSwipe();
        startAutoplay();
    }, { passive: true });

    function handleSwipe() {
        const swipeThreshold = 50;
        const diff = touchStartX - touchEndX;

        if (Math.abs(diff) > swipeThreshold) {
            if (diff > 0) {
                nextSlide(); // Swipe left
            } else {
                prevSlide(); // Swipe right
            }
        }
    }

    // Suporte a teclado
    document.addEventListener('keydown', (e) => {
        if (e.key === 'ArrowLeft') {
            prevSlide();
            startAutoplay();
        } else if (e.key === 'ArrowRight') {
            nextSlide();
            startAutoplay();
        }
    });

    // Pausar quando a aba não está visível
    document.addEventListener('visibilitychange', () => {
        if (document.hidden) {
            stopAutoplay();
        } else {
            startAutoplay();
        }
    });

    // Lazy loading de imagens
    const images = carousel.querySelectorAll('img[loading="lazy"]');
    if ('IntersectionObserver' in window) {
        const imageObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target;
                    img.src = img.src; // Forçar carregamento
                    imageObserver.unobserve(img);
                }
            });
        });

        images.forEach(img => imageObserver.observe(img));
    }

    // Iniciar autoplay
    startAutoplay();
}

// ===========================
// INICIALIZAÇÃO
// ===========================
document.addEventListener('DOMContentLoaded', function() {
    initHeroCarousel();
    initSidebar();
    initMobileMenu();
    initScrollEffects();
    initCarousel();
    initContactForm();
    initUploadForm();
    initSmoothScroll();
    initScrollToTop();
    initHeaderScrollToTop();
    initStatsCounter();
    initTrabalheConosco();
});

// ===========================
// MENU LATERAL ESQUERDO (SIDEBAR)
// ===========================
function initSidebar() {
    const hamburger = document.getElementById('hamburger');
    const sidebar = document.getElementById('sidebar');
    const sidebarClose = document.getElementById('sidebar-close');
    const sidebarOverlay = document.getElementById('sidebar-overlay');
    const sidebarLinks = document.querySelectorAll('.sidebar__link');

    if (!hamburger || !sidebar) return;

    // Abrir sidebar
    hamburger.addEventListener('click', () => {
        sidebar.classList.add('show');
        sidebarOverlay.classList.add('show');
        hamburger.classList.add('active');
        document.body.style.overflow = 'hidden'; // Prevenir scroll do body
    });

    // Fechar sidebar
    const closeSidebar = () => {
        sidebar.classList.remove('show');
        sidebarOverlay.classList.remove('show');
        hamburger.classList.remove('active');
        document.body.style.overflow = ''; // Restaurar scroll do body
    };

    // Fechar ao clicar no botão X
    if (sidebarClose) {
        sidebarClose.addEventListener('click', closeSidebar);
    }

    // Fechar ao clicar no overlay
    if (sidebarOverlay) {
        sidebarOverlay.addEventListener('click', closeSidebar);
    }

    // Fechar ao pressionar ESC
    document.addEventListener('keydown', (e) => {
        if (e.key === 'Escape' && sidebar.classList.contains('show')) {
            closeSidebar();
        }
    });

    // Scroll suave e fechar sidebar ao clicar nos links
    sidebarLinks.forEach(link => {
        link.addEventListener('click', (e) => {
            e.preventDefault();
            
            const targetId = link.getAttribute('href');
            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                const headerHeight = document.getElementById('header')?.offsetHeight || 0;
                const targetPosition = targetSection.offsetTop - headerHeight;

                // Fechar sidebar primeiro
                closeSidebar();

                // Aguardar animação de fechamento antes de scrollar
                setTimeout(() => {
                    window.scrollTo({
                        top: targetPosition,
                        behavior: 'smooth'
                    });

                    // Atualizar link ativo
                    updateActiveSidebarLink(link);
                }, 300);
            }
        });
    });

    // Atualizar link ativo baseado na seção atual
    function updateActiveSidebarLink(activeLink) {
        sidebarLinks.forEach(link => link.classList.remove('active'));
        if (activeLink) {
            activeLink.classList.add('active');
        }
    }

    // Detectar seção ativa durante scroll
    window.addEventListener('scroll', debounce(() => {
        const sections = document.querySelectorAll('section[id]');
        let currentSection = '';

        sections.forEach(section => {
            const sectionTop = section.offsetTop - 150;
            const sectionHeight = section.offsetHeight;
            
            if (window.pageYOffset >= sectionTop && window.pageYOffset < sectionTop + sectionHeight) {
                currentSection = section.getAttribute('id');
            }
        });

        if (currentSection) {
            const activeLink = document.querySelector(`.sidebar__link[data-section="${currentSection}"]`);
            updateActiveSidebarLink(activeLink);
        }
    }, 100));
}

// ===========================
// MENU MOBILE
// ===========================
function initMobileMenu() {
    const navToggle = document.getElementById('nav-toggle');
    const navMenu = document.getElementById('nav-menu');
    const navClose = document.getElementById('nav-close');
    const navLinks = document.querySelectorAll('.nav__link');

    // Abrir menu
    if (navToggle) {
        navToggle.addEventListener('click', () => {
            navMenu.classList.add('show-menu');
            navToggle.classList.add('active');
        });
    }

    // Fechar menu
    if (navClose) {
        navClose.addEventListener('click', () => {
            navMenu.classList.remove('show-menu');
            navToggle.classList.remove('active');
        });
    }

    // Fechar menu ao clicar em um link
    navLinks.forEach(link => {
        link.addEventListener('click', () => {
            navMenu.classList.remove('show-menu');
            if (navToggle) {
                navToggle.classList.remove('active');
            }
        });
    });
}

// ===========================
// EFEITOS DE SCROLL
// ===========================
function initScrollEffects() {
    const header = document.getElementById('header');
    const sections = document.querySelectorAll('section[id]');

    window.addEventListener('scroll', () => {
        // Header shadow on scroll
        if (window.scrollY >= 50) {
            header.classList.add('scroll-header');
        } else {
            header.classList.remove('scroll-header');
        }

        // Active link highlighting
        highlightActiveSection(sections);
    });
}

function highlightActiveSection(sections) {
    const scrollY = window.pageYOffset;

    sections.forEach(section => {
        const sectionHeight = section.offsetHeight;
        const sectionTop = section.offsetTop - 100;
        const sectionId = section.getAttribute('id');
        const navLink = document.querySelector(`.nav__link[href="#${sectionId}"]`);

        if (navLink) {
            if (scrollY > sectionTop && scrollY <= sectionTop + sectionHeight) {
                navLink.classList.add('active-link');
            } else {
                navLink.classList.remove('active-link');
            }
        }
    });
}

// ===========================
// CARROSSEL
// ===========================
function initCarousel() {
    const carouselContainer = document.querySelector('.carousel__container');
    const prevButton = document.querySelector('.carousel__button--prev');
    const nextButton = document.querySelector('.carousel__button--next');
    const indicatorsContainer = document.querySelector('.carousel__indicators');
    
    if (!carouselContainer) return;

    const slides = document.querySelectorAll('.carousel__slide');
    const totalSlides = slides.length;

    // Criar indicadores
    createIndicators(indicatorsContainer, totalSlides);

    // Event listeners para botões
    if (prevButton) {
        prevButton.addEventListener('click', () => {
            changeSlide(-1);
        });
    }

    if (nextButton) {
        nextButton.addEventListener('click', () => {
            changeSlide(1);
        });
    }

    // Auto-play do carrossel
    let autoplayInterval = setInterval(() => {
        changeSlide(1);
    }, 5000);

    // Pausar auto-play ao interagir
    const carousel = document.querySelector('.carousel');
    if (carousel) {
        carousel.addEventListener('mouseenter', () => {
            clearInterval(autoplayInterval);
        });

        carousel.addEventListener('mouseleave', () => {
            autoplayInterval = setInterval(() => {
                changeSlide(1);
            }, 5000);
        });
    }

    function changeSlide(direction) {
        currentSlide += direction;

        if (currentSlide >= totalSlides) {
            currentSlide = 0;
        } else if (currentSlide < 0) {
            currentSlide = totalSlides - 1;
        }

        updateCarousel();
    }

    function updateCarousel() {
        const offset = -currentSlide * 100;
        carouselContainer.style.transform = `translateX(${offset}%)`;
        updateIndicators();
    }

    function createIndicators(container, count) {
        if (!container) return;

        for (let i = 0; i < count; i++) {
            const indicator = document.createElement('div');
            indicator.classList.add('carousel__indicator');
            if (i === 0) indicator.classList.add('active');
            
            indicator.addEventListener('click', () => {
                currentSlide = i;
                updateCarousel();
            });

            container.appendChild(indicator);
        }
    }

    function updateIndicators() {
        const indicators = document.querySelectorAll('.carousel__indicator');
        indicators.forEach((indicator, index) => {
            if (index === currentSlide) {
                indicator.classList.add('active');
            } else {
                indicator.classList.remove('active');
            }
        });
    }

    // Suporte para touch/swipe em dispositivos móveis
    let touchStartX = 0;
    let touchEndX = 0;

    if (carousel) {
        carousel.addEventListener('touchstart', (e) => {
            touchStartX = e.changedTouches[0].screenX;
        });

        carousel.addEventListener('touchend', (e) => {
            touchEndX = e.changedTouches[0].screenX;
            handleSwipe();
        });
    }

    function handleSwipe() {
        const swipeThreshold = 50;
        const diff = touchStartX - touchEndX;

        if (Math.abs(diff) > swipeThreshold) {
            if (diff > 0) {
                // Swipe left
                changeSlide(1);
            } else {
                // Swipe right
                changeSlide(-1);
            }
        }
    }
}

// ===========================
// FORMULÁRIO DE CONTATO
// ===========================
function initContactForm() {
    const contactForm = document.getElementById('contactForm');
    const formFeedback = document.getElementById('formFeedback');

    if (!contactForm) return;

    contactForm.addEventListener('submit', async (e) => {
        e.preventDefault();

        const formData = new FormData(contactForm);
        const submitButton = contactForm.querySelector('.form__button');

        // Desabilitar botão durante envio
        submitButton.disabled = true;
        submitButton.textContent = 'Enviando...';
        formFeedback.textContent = '';
        formFeedback.className = 'form__feedback';

        try {
            const response = await fetch('/contato', {
                method: 'POST',
                body: formData
            });

            const data = await response.json();

            if (data.success) {
                showFeedback(formFeedback, data.message, 'success');
                contactForm.reset();
            } else {
                showFeedback(formFeedback, data.message, 'error');
            }
        } catch (error) {
            showFeedback(formFeedback, 'Erro ao enviar mensagem. Tente novamente.', 'error');
        } finally {
            submitButton.disabled = false;
            submitButton.textContent = 'Enviar Mensagem';
        }
    });
}

// ===========================
// UPLOAD DE ARQUIVO
// ===========================
function initUploadForm() {
    const uploadForm = document.getElementById('uploadForm');
    const fileInput = document.getElementById('fileInput');
    const uploadLabel = document.querySelector('.upload__label');
    const uploadText = document.querySelector('.upload__text');
    const uploadFeedback = document.getElementById('uploadFeedback');

    if (!uploadForm) return;

    // Atualizar texto quando arquivo é selecionado
    fileInput.addEventListener('change', (e) => {
        const fileName = e.target.files[0]?.name;
        if (fileName) {
            uploadText.textContent = fileName;
        } else {
            uploadText.textContent = 'Escolher arquivo PDF';
        }
    });

    // Drag and drop
    uploadLabel.addEventListener('dragover', (e) => {
        e.preventDefault();
        uploadLabel.style.borderColor = 'var(--primary-color)';
    });

    uploadLabel.addEventListener('dragleave', (e) => {
        e.preventDefault();
        uploadLabel.style.borderColor = 'var(--border-color)';
    });

    uploadLabel.addEventListener('drop', (e) => {
        e.preventDefault();
        uploadLabel.style.borderColor = 'var(--border-color)';
        
        const files = e.dataTransfer.files;
        if (files.length > 0) {
            fileInput.files = files;
            uploadText.textContent = files[0].name;
        }
    });

    // Submit do formulário
    uploadForm.addEventListener('submit', async (e) => {
        e.preventDefault();

        const file = fileInput.files[0];
        if (!file) {
            showFeedback(uploadFeedback, 'Por favor, selecione um arquivo.', 'error');
            return;
        }

        // Validar tamanho do arquivo (16MB)
        const maxSize = 16 * 1024 * 1024;
        if (file.size > maxSize) {
            showFeedback(uploadFeedback, 'Arquivo muito grande. Máximo: 16MB', 'error');
            return;
        }

        // Validar extensão
        if (!file.name.toLowerCase().endsWith('.pdf')) {
            showFeedback(uploadFeedback, 'Apenas arquivos PDF são permitidos.', 'error');
            return;
        }

        const formData = new FormData();
        formData.append('file', file);

        const submitButton = uploadForm.querySelector('.upload__button');
        submitButton.disabled = true;
        submitButton.textContent = 'Enviando...';
        uploadFeedback.textContent = '';
        uploadFeedback.className = 'upload__feedback';

        try {
            const response = await fetch('/upload', {
                method: 'POST',
                body: formData
            });

            const data = await response.json();

            if (data.success) {
                showFeedback(uploadFeedback, data.message, 'success');
                uploadForm.reset();
                uploadText.textContent = 'Escolher arquivo PDF';
            } else {
                showFeedback(uploadFeedback, data.message, 'error');
            }
        } catch (error) {
            showFeedback(uploadFeedback, 'Erro ao fazer upload. Tente novamente.', 'error');
        } finally {
            submitButton.disabled = false;
            submitButton.textContent = 'Enviar Arquivo';
        }
    });
}

// ===========================
// SMOOTH SCROLL
// ===========================
function initSmoothScroll() {
    const links = document.querySelectorAll('a[href^="#"]');

    links.forEach(link => {
        link.addEventListener('click', (e) => {
            const targetId = link.getAttribute('href');
            
            // Ignorar links que não são para seções
            if (targetId === '#' || targetId.length <= 1) return;

            const targetSection = document.querySelector(targetId);
            
            if (targetSection) {
                e.preventDefault();
                
                const headerHeight = document.getElementById('header').offsetHeight;
                const targetPosition = targetSection.offsetTop - headerHeight;

                window.scrollTo({
                    top: targetPosition,
                    behavior: 'smooth'
                });
            }
        });
    });
}

// ===========================
// SCROLL TO TOP
// ===========================
function initScrollToTop() {
    const scrollTopButton = document.getElementById('scrollTop');

    if (!scrollTopButton) return;

    window.addEventListener('scroll', () => {
        if (window.scrollY >= 400) {
            scrollTopButton.classList.add('show');
        } else {
            scrollTopButton.classList.remove('show');
        }
    });

    scrollTopButton.addEventListener('click', () => {
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    });
}

// ===========================
// HEADER SCROLL TO TOP
// ===========================
function initHeaderScrollToTop() {
    const header = document.getElementById('header');
    const logoLink = document.getElementById('logo-link');
    const navBrand = document.getElementById('nav-brand');

    // Função para scroll suave ao topo
    const scrollToTop = (e) => {
        e.preventDefault();
        window.scrollTo({
            top: 0,
            behavior: 'smooth'
        });
    };

    // Ao clicar na logo
    if (logoLink) {
        logoLink.addEventListener('click', scrollToTop);
    }

    // Ao clicar no brand (área da logo)
    if (navBrand) {
        navBrand.addEventListener('click', scrollToTop);
    }

    // Ao clicar no header (exceto menu e links de navegação)
    if (header) {
        header.addEventListener('click', (e) => {
            // Verificar se o clique não foi em um link de navegação ou botões do menu
            const isNavLink = e.target.closest('.nav__link');
            const isNavToggle = e.target.closest('.nav__toggle');
            const isNavClose = e.target.closest('.nav__close');
            const isNavMenu = e.target.closest('.nav__menu');
            
            // Se clicou no header mas não nos elementos de navegação
            if (!isNavLink && !isNavToggle && !isNavClose && !isNavMenu) {
                scrollToTop(e);
            }
        });
    }
}

// ===========================
// FUNÇÕES AUXILIARES
// ===========================
function showFeedback(element, message, type) {
    if (!element) return;

    element.textContent = message;
    element.classList.add(type);
    
    // Remover feedback após 5 segundos
    setTimeout(() => {
        element.textContent = '';
        element.className = element.classList.contains('form__feedback') 
            ? 'form__feedback' 
            : 'upload__feedback';
    }, 5000);
}

// Debounce function para otimizar eventos de scroll
function debounce(func, wait) {
    let timeout;
    return function executedFunction(...args) {
        const later = () => {
            clearTimeout(timeout);
            func(...args);
        };
        clearTimeout(timeout);
        timeout = setTimeout(later, wait);
    };
}

// ===========================
// ANIMAÇÕES DE ENTRADA
// ===========================
function initScrollAnimations() {
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -100px 0px'
    };

    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
                observer.unobserve(entry.target);
            }
        });
    }, observerOptions);

    // Observar elementos que devem animar
    const animatedElements = document.querySelectorAll('.servico__card, .sobre__container, .contato__container');
    animatedElements.forEach(el => observer.observe(el));
}

// Inicializar animações quando o DOM carregar
document.addEventListener('DOMContentLoaded', initScrollAnimations);

// ===========================
// CONTADOR DE ESTATÍSTICAS
// ===========================
function initStatsCounter() {
    const stats = document.querySelectorAll('.sobre__stat-number');
    
    if (stats.length === 0) return;

    let hasAnimated = false;

    const animateCounter = (element) => {
        const target = parseInt(element.getAttribute('data-target'));
        const duration = 2000; // 2 segundos
        const increment = target / (duration / 16); // 60 FPS
        let current = 0;

        const updateCounter = () => {
            current += increment;
            if (current < target) {
                element.textContent = Math.floor(current);
                requestAnimationFrame(updateCounter);
            } else {
                element.textContent = target;
            }
        };

        updateCounter();
    };

    // Observer para detectar quando a seção está visível
    const observer = new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting && !hasAnimated) {
                hasAnimated = true;
                stats.forEach(stat => {
                    animateCounter(stat);
                });
                observer.disconnect();
            }
        });
    }, {
        threshold: 0.5 // Animar quando 50% da seção estiver visível
    });

    // Observar a seção de estatísticas
    const statsSection = document.querySelector('.sobre__stats');
    if (statsSection) {
        observer.observe(statsSection);
    }
}

// ===========================
// TRABALHE CONOSCO - UPLOAD E VALIDAÇÃO
// ===========================
function initTrabalheConosco() {
    const form = document.getElementById('trabalheConoscoForm');
    const fileInput = document.getElementById('candidato-curriculo');
    const fileName = document.querySelector('.form__file-name');
    const feedback = document.getElementById('trabalheConoscoFeedback');

    if (!form || !fileInput) return;

    // Mostrar nome do arquivo selecionado
    fileInput.addEventListener('change', (e) => {
        const file = e.target.files[0];
        
        if (file) {
            // Validar tipo de arquivo
            if (file.type !== 'application/pdf') {
                showFeedback(feedback, 'Apenas arquivos PDF são permitidos.', 'error');
                fileInput.value = '';
                fileName.textContent = '';
                return;
            }

            // Validar tamanho (5MB = 5 * 1024 * 1024 bytes)
            const maxSize = 5 * 1024 * 1024;
            if (file.size > maxSize) {
                showFeedback(feedback, 'O arquivo deve ter no máximo 5MB.', 'error');
                fileInput.value = '';
                fileName.textContent = '';
                return;
            }

            // Mostrar nome do arquivo
            fileName.textContent = `📄 ${file.name} (${formatFileSize(file.size)})`;
            hideFeedback(feedback);
        } else {
            fileName.textContent = '';
        }
    });

    // Submeter formulário
    form.addEventListener('submit', async (e) => {
        e.preventDefault();

        // Validar campos obrigatórios
        const nome = document.getElementById('candidato-nome').value.trim();
        const email = document.getElementById('candidato-email').value.trim();
        const telefone = document.getElementById('candidato-telefone').value.trim();
        const resumo = document.getElementById('candidato-resumo').value.trim();
        const curriculo = fileInput.files[0];

        if (!nome || !email || !telefone || !resumo) {
            showFeedback(feedback, 'Por favor, preencha todos os campos obrigatórios.', 'error');
            return;
        }

        if (!curriculo) {
            showFeedback(feedback, 'Por favor, anexe seu currículo em PDF.', 'error');
            return;
        }

        // Validar email
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        if (!emailRegex.test(email)) {
            showFeedback(feedback, 'Por favor, insira um e-mail válido.', 'error');
            return;
        }

        // Criar FormData
        const formData = new FormData();
        formData.append('nome', nome);
        formData.append('email', email);
        formData.append('telefone', telefone);
        formData.append('resumo', resumo);
        formData.append('curriculo', curriculo);

        // Desabilitar botão e mostrar loading
        const submitBtn = form.querySelector('button[type="submit"]');
        const originalText = submitBtn.textContent;
        submitBtn.disabled = true;
        submitBtn.textContent = 'Enviando...';
        submitBtn.classList.add('loading');

        try {
            const response = await fetch('/trabalhe-conosco', {
                method: 'POST',
                body: formData
            });

            const data = await response.json();

            if (data.success) {
                showFeedback(feedback, data.message, 'success');
                form.reset();
                fileName.textContent = '';
                
                // Scroll suave para o feedback
                feedback.scrollIntoView({ behavior: 'smooth', block: 'center' });
            } else {
                showFeedback(feedback, data.message, 'error');
            }
        } catch (error) {
            showFeedback(feedback, 'Erro ao enviar candidatura. Tente novamente.', 'error');
            console.error('Erro:', error);
        } finally {
            submitBtn.disabled = false;
            submitBtn.textContent = originalText;
            submitBtn.classList.remove('loading');
        }
    });
}

// Formatar tamanho do arquivo
function formatFileSize(bytes) {
    if (bytes === 0) return '0 Bytes';
    
    const k = 1024;
    const sizes = ['Bytes', 'KB', 'MB'];
    const i = Math.floor(Math.log(bytes) / Math.log(k));
    
    return Math.round(bytes / Math.pow(k, i) * 100) / 100 + ' ' + sizes[i];
}

// ===========================
// TRATAMENTO DE ERROS GLOBAL
// ===========================
window.addEventListener('error', (e) => {
    console.error('Erro capturado:', e.message);
});

// ===========================
// PERFORMANCE
// ===========================
// Adicionar debounce aos eventos de scroll
window.addEventListener('scroll', debounce(() => {
    // Lógica de scroll otimizada já implementada acima
}, 10));

console.log('🚀 Landing Page carregada com sucesso!');
