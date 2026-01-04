# 🤖 Monitor DNS + Notificação WhatsApp
# Verifica quando housealimentoss.com.br estiver acessível e envia WhatsApp

import time
import socket
import requests
from datetime import datetime

# Configurações
DOMINIO = "housealimentoss.com.br"
WHATSAPP = "5541984967095"  # Número com código do país
CHECK_INTERVAL = 300  # Verificar a cada 5 minutos


def verificar_dns():
    """Verifica se o DNS está resolvendo para Cloudflare"""
    try:
        ip = socket.gethostbyname(DOMINIO)
        # IPs do Cloudflare começam com 104.x ou 172.x
        if ip.startswith('104.') or ip.startswith('172.'):
            return True, ip
        return False, ip
    except socket.gaierror:
        return False, None


def verificar_site_acessivel():
    """Verifica se o site está respondendo via HTTPS"""
    try:
        response = requests.get(
            f"https://{DOMINIO}", timeout=10, allow_redirects=True)
        return response.status_code == 200
    except:
        return False


def enviar_whatsapp_callmebot(mensagem):
    """Envia mensagem via CallMeBot API (gratuito)"""
    try:
        # CallMeBot API - Gratuito, sem cadastro
        # Instruções: https://www.callmebot.com/blog/free-api-whatsapp-messages/

        # Nota: É necessário primeiro adicionar o bot no WhatsApp
        # Envie "I allow callmebot to send me messages" para +34 644 51 37 69

        api_key = "SEU_API_KEY_AQUI"  # Obter em https://www.callmebot.com/

        url = f"https://api.callmebot.com/whatsapp.php"
        params = {
            'phone': WHATSAPP,
            'text': mensagem,
            'apikey': api_key
        }

        response = requests.get(url, params=params)
        return response.status_code == 200
    except Exception as e:
        print(f"Erro ao enviar WhatsApp: {e}")
        return False


def notificar_telegram(mensagem):
    """Alternativa: Enviar via Telegram (mais fácil de configurar)"""
    try:
        # Telegram Bot API - Gratuito
        # 1. Abra @BotFather no Telegram
        # 2. Envie /newbot e siga instruções
        # 3. Copie o token
        # 4. Envie mensagem para seu bot
        # 5. Acesse: https://api.telegram.org/botTOKEN/getUpdates
        # 6. Copie seu chat_id

        BOT_TOKEN = "SEU_BOT_TOKEN_AQUI"
        CHAT_ID = "SEU_CHAT_ID_AQUI"

        url = f"https://api.telegram.org/bot{BOT_TOKEN}/sendMessage"
        data = {
            'chat_id': CHAT_ID,
            'text': mensagem,
            'parse_mode': 'HTML'
        }

        response = requests.post(url, json=data)
        return response.status_code == 200
    except Exception as e:
        print(f"Erro ao enviar Telegram: {e}")
        return False


def monitorar():
    """Loop principal de monitoramento"""
    print("========================================")
    print("  🤖 Monitor DNS - HOUSE Alimentos")
    print("========================================")
    print()
    print(f"🌐 Domínio: {DOMINIO}")
    print(f"📱 WhatsApp: {WHATSAPP}")
    print(f"⏱️  Verificando a cada {CHECK_INTERVAL} segundos")
    print()
    print("Aguardando propagação DNS...")
    print()

    verificacoes = 0

    while True:
        verificacoes += 1
        agora = datetime.now().strftime('%d/%m/%Y %H:%M:%S')

        print(f"[{agora}] Verificação #{verificacoes}")

        # Verificar DNS
        dns_ok, ip = verificar_dns()

        if dns_ok:
            print(f"  ✅ DNS resolvido: {ip} (Cloudflare)")

            # Verificar se site está acessível
            print(f"  🔍 Testando acesso HTTPS...")
            site_ok = verificar_site_acessivel()

            if site_ok:
                print(f"  ✅ Site acessível!")
                print()
                print("========================================")
                print("  🎉 SITE NO AR!")
                print("========================================")
                print()

                mensagem = f"""
🎉 *HOUSE Alimentos - SITE NO AR!*

✅ Domínio: {DOMINIO}
✅ IP: {ip}
✅ Status: Online
✅ HTTPS: Funcionando

🌐 Acesse: https://{DOMINIO}

⏰ {agora}
"""

                print("📱 Enviando notificação WhatsApp...")

                # OPÇÃO 1: CallMeBot (WhatsApp - requer setup inicial)
                # if enviar_whatsapp_callmebot(mensagem):
                #     print("✅ WhatsApp enviado!")
                # else:
                #     print("❌ Erro ao enviar WhatsApp")

                # OPÇÃO 2: Telegram (mais fácil)
                # if notificar_telegram(mensagem):
                #     print("✅ Telegram enviado!")
                # else:
                #     print("❌ Erro ao enviar Telegram")

                # Por enquanto, apenas exibe e salva em arquivo
                print(mensagem)

                with open("dns_notificacao.txt", "w", encoding="utf-8") as f:
                    f.write(mensagem)
                    f.write(f"\n\nGabriel, seu site está no ar! 🎉\n")
                    f.write(f"Acesse: https://{DOMINIO}\n")

                print()
                print("💾 Notificação salva em: dns_notificacao.txt")
                print()
                print("🔔 GABRIEL: Vou avisar você manualmente no WhatsApp!")
                print(f"📱 Número: {WHATSAPP}")

                break  # Para o monitoramento
            else:
                print(f"  ⚠️  DNS resolvido mas site não responde")
        else:
            if ip:
                print(f"  ⏳ DNS ainda com IP antigo: {ip}")
            else:
                print(f"  ⏳ DNS ainda não resolvido")

        print(f"  ⏱️  Próxima verificação em {CHECK_INTERVAL}s")
        print()

        time.sleep(CHECK_INTERVAL)


if __name__ == "__main__":
    try:
        monitorar()
    except KeyboardInterrupt:
        print("\n\n⚠️  Monitoramento interrompido pelo usuário")
    except Exception as e:
        print(f"\n\n❌ Erro: {e}")
