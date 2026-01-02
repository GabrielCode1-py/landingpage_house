/**
 * Sistema de Gerenciamento de Cookies - LGPD Compliant
 * HOUSE Alimentos
 */

class CookieConsent {
    constructor() {
        this.cookieName = 'house_cookie_consent';
        this.cookieExpiry = 365; // dias
        this.banner = document.getElementById('cookieBanner');
        this.modal = document.getElementById('cookieModal');
        this.modalOverlay = document.getElementById('cookieModalOverlay');
        
        this.init();
    }

    init() {
        // Verifica se já existe consentimento
        if (!this.hasConsent()) {
            this.showBanner();
        } else {
            this.applyConsent();
        }

        // Event listeners
        document.getElementById('cookieAccept')?.addEventListener('click', () => this.acceptAll());
        document.getElementById('cookieSettings')?.addEventListener('click', () => this.openModal());
        document.getElementById('cookieModalClose')?.addEventListener('click', () => this.closeModal());
        document.getElementById('cookieModalOverlay')?.addEventListener('click', () => this.closeModal());
        document.getElementById('cookieSaveSettings')?.addEventListener('click', () => this.saveSettings());
        document.getElementById('cookieRejectAll')?.addEventListener('click', () => this.rejectAll());
    }

    showBanner() {
        if (this.banner) {
            this.banner.style.display = 'block';
            setTimeout(() => {
                this.banner.classList.add('cookie-banner--show');
            }, 100);
        }
    }

    hideBanner() {
        if (this.banner) {
            this.banner.classList.remove('cookie-banner--show');
            setTimeout(() => {
                this.banner.style.display = 'none';
            }, 300);
        }
    }

    openModal() {
        if (this.modal) {
            this.modal.style.display = 'flex';
            setTimeout(() => {
                this.modal.classList.add('cookie-modal--show');
            }, 10);

            // Carrega preferências atuais
            this.loadCurrentPreferences();
        }
    }

    closeModal() {
        if (this.modal) {
            this.modal.classList.remove('cookie-modal--show');
            setTimeout(() => {
                this.modal.style.display = 'none';
            }, 300);
        }
    }

    loadCurrentPreferences() {
        const consent = this.getConsent();
        if (consent) {
            document.getElementById('cookiePerformance').checked = consent.performance || false;
            document.getElementById('cookieAnalytics').checked = consent.analytics || false;
        }
    }

    acceptAll() {
        const consent = {
            essential: true,
            performance: true,
            analytics: true,
            timestamp: new Date().toISOString()
        };
        
        this.saveConsent(consent);
        this.hideBanner();
        this.applyConsent();
        
        console.log('✓ Todos os cookies aceitos');
    }

    rejectAll() {
        const consent = {
            essential: true,
            performance: false,
            analytics: false,
            timestamp: new Date().toISOString()
        };
        
        this.saveConsent(consent);
        this.closeModal();
        this.hideBanner();
        this.applyConsent();
        
        console.log('✓ Apenas cookies essenciais aceitos');
    }

    saveSettings() {
        const consent = {
            essential: true,
            performance: document.getElementById('cookiePerformance').checked,
            analytics: document.getElementById('cookieAnalytics').checked,
            timestamp: new Date().toISOString()
        };
        
        this.saveConsent(consent);
        this.closeModal();
        this.hideBanner();
        this.applyConsent();
        
        console.log('✓ Preferências de cookies salvas:', consent);
    }

    saveConsent(consent) {
        try {
            // Salva no localStorage (mais seguro que cookies para preferências)
            localStorage.setItem(this.cookieName, JSON.stringify(consent));
            
            // Também salva um cookie simples para verificação rápida
            const expiryDate = new Date();
            expiryDate.setDate(expiryDate.getDate() + this.cookieExpiry);
            document.cookie = `${this.cookieName}=true; expires=${expiryDate.toUTCString()}; path=/; SameSite=Strict; Secure`;
        } catch (e) {
            console.error('Erro ao salvar preferências de cookies:', e);
        }
    }

    getConsent() {
        try {
            const stored = localStorage.getItem(this.cookieName);
            return stored ? JSON.parse(stored) : null;
        } catch (e) {
            console.error('Erro ao ler preferências de cookies:', e);
            return null;
        }
    }

    hasConsent() {
        return this.getConsent() !== null;
    }

    applyConsent() {
        const consent = this.getConsent();
        if (!consent) return;

        // Cookies essenciais sempre ativos
        this.enableEssentialCookies();

        // Cookies de desempenho
        if (consent.performance) {
            this.enablePerformanceCookies();
        } else {
            this.disablePerformanceCookies();
        }

        // Cookies de análise
        if (consent.analytics) {
            this.enableAnalyticsCookies();
        } else {
            this.disableAnalyticsCookies();
        }
    }

    enableEssentialCookies() {
        // Cookies essenciais para funcionamento do site
        console.log('✓ Cookies essenciais habilitados');
        // Exemplo: sessionStorage para scroll position, preferências de UI, etc.
    }

    enablePerformanceCookies() {
        console.log('✓ Cookies de desempenho habilitados');
        // Aqui você pode adicionar scripts de performance monitoring
        // Exemplo: monitoramento de velocidade de carregamento
    }

    disablePerformanceCookies() {
        console.log('⊗ Cookies de desempenho desabilitados');
        // Remove cookies de desempenho se existirem
    }

    enableAnalyticsCookies() {
        console.log('✓ Cookies de análise habilitados');
        // Aqui você pode adicionar Google Analytics, etc.
        // Exemplo:
        // if (typeof gtag !== 'undefined') {
        //     gtag('consent', 'update', {
        //         'analytics_storage': 'granted'
        //     });
        // }
    }

    disableAnalyticsCookies() {
        console.log('⊗ Cookies de análise desabilitados');
        // Desabilita analytics se existirem
    }

    // Método público para revogar consentimento
    revokeConsent() {
        try {
            localStorage.removeItem(this.cookieName);
            document.cookie = `${this.cookieName}=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;
            console.log('✓ Consentimento de cookies revogado');
            location.reload();
        } catch (e) {
            console.error('Erro ao revogar consentimento:', e);
        }
    }

    // Método público para verificar se um tipo de cookie está ativo
    isEnabled(type) {
        const consent = this.getConsent();
        return consent ? consent[type] === true : false;
    }
}

// Inicializa o sistema de cookies quando o DOM estiver pronto
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        window.cookieConsent = new CookieConsent();
    });
} else {
    window.cookieConsent = new CookieConsent();
}

// Expõe funções úteis globalmente
window.revokeCookieConsent = () => {
    if (window.cookieConsent) {
        window.cookieConsent.revokeConsent();
    }
};

window.isCookieEnabled = (type) => {
    return window.cookieConsent ? window.cookieConsent.isEnabled(type) : false;
};
