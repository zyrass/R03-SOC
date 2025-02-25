import json
import os
import sys
import requests
from datetime import datetime

# Codes d'erreur
ERR_NO_REQUEST_MODULE = 1
ERR_BAD_ARGUMENTS = 2
ERR_FILE_NOT_FOUND = 6
ERR_INVALID_JSON = 7

# Configuration du chemin
pwd = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
LOG_FILE = f'{pwd}/logs/integrations.log'

# Indices pour les arguments
ALERT_INDEX = 1
WEBHOOK_INDEX = 3


def generate_msg(alert: dict, options: dict = None) -> str:
    """
    Génère le message d'alerte formaté pour Discord.
    """
    # Définition des couleurs selon le niveau d'alerte
    # level = alert['rule']['level']
    # if level <= 4:
    #     color = 3066993  # Vert
    # elif 5 <= level <= 12:
    #     color = 16776960  # Jaune
    # else:
    #     color = 15158332  # Rouge

    # Récupération des informations de l'agent
    agent_name = alert.get('agent', {}).get('name', 'agentless')
    agent_ip = alert.get('agent', {}).get('ip', 'N/A')
    signature_id = alert.get('data', {}).get('alert', {}).get('signature_id', 'N/A')
    

    # Construction du payload pour Discord
    payload = {
        "username": "Wazuh Alert",
        "avatar_url": "https://wazuh.com/uploads/2024/06/multi-site-implementation-logo.webp",
        "embeds": [{
            "title": f"Alerte Wazuh - Règle {alert['rule']['id']}",
            "description": alert['rule']['description'],
            "color": 15158332,
            "fields": [
                {
                    "name": f"{agent_name}",
                    "value": agent_ip,
                    "inline": True
                },
                {
                    "name": "Signature ID",
                    "value": signature_id,
                    "inline": True
                },
                {
                    "name": "Niveau d'alerte suricata",
                    "value": alert['data']['alert']['severity'],
                    "inline": True
                }
            ],
            "footer": {
                "text": f"Détecté le {datetime.now().strftime('%d-%m-%Y')} à {datetime.now().strftime('%H:%M:%S')} | Localisation: {alert.get('location', 'N/A')}"
            }
        }]
    }

    debug(f"Payload généré: {json.dumps(payload, indent=2)}")
    return json.dumps(payload)

def send_msg(msg: str, webhook_url: str) -> None:
    """
    Envoie le message au webhook Discord.
    """
    headers = {'content-type': 'application/json'}
    try:
        debug(f"Tentative d'envoi vers {webhook_url}")
        response = requests.post(webhook_url, data=msg, headers=headers, timeout=10)
        response.raise_for_status()
        debug(f"Message envoyé avec succès. Status: {response.status_code}")
        # Log de la réponse complète pour le débogage
        debug(f"Réponse complète: {response.text}")
    except requests.exceptions.RequestException as e:
        debug(f"Erreur lors de l'envoi du message: {str(e)}")
        raise


def debug(msg: str) -> None:
    """
    Enregistre les messages de debug dans le fichier de log.
    """
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    log_message = f"[{timestamp}] {msg}"

    print(log_message)
    with open(LOG_FILE, 'a') as f:
        f.write(log_message + '\n')


def main(args):
    debug("Démarrage du script Discord")
    debug(f"Arguments reçus: {args}")

    if len(args) < 4:
        debug("Arguments insuffisants")
        sys.exit(ERR_BAD_ARGUMENTS)

    alert_file = args[ALERT_INDEX]
    webhook_url = args[WEBHOOK_INDEX]

    debug(f"Fichier d'alerte: {alert_file}")
    debug(f"Webhook URL: {webhook_url}")

    try:
        with open(alert_file) as f:
            alert_data = json.load(f)
            debug("Alerte chargée avec succès")
    except Exception as e:
        debug(f"Erreur lors de la lecture du fichier d'alerte: {str(e)}")
        sys.exit(ERR_FILE_NOT_FOUND)

    msg = generate_msg(alert_data)
    send_msg(msg, webhook_url)


if __name__ == "__main__":
    main(sys.argv)
