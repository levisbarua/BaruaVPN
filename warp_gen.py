import urllib.request
import json
import datetime
import random
import string
import base64
from urllib.error import HTTPError

# Generate WireGuard keypair using wg (if installed) or python cryptography
# Since we might not have wg, we'll use a pure python x25519 implementation or just rely on a pre-generated one.
# Wait, pure python x25519 is hard without libraries. 
# Cloudflare API actually requires a public key to register.
# Let's try to run `wg genkey` via subprocess.
import subprocess

def run_cmd(cmd):
    return subprocess.check_output(cmd, shell=True).decode('utf-8').strip()

try:
    private_key = run_cmd('wg genkey')
    public_key = run_cmd(f'echo {private_key} | wg pubkey')
except Exception as e:
    print("WireGuard tools not found. Please install wireguard-tools first.")
    exit(1)

def register():
    install_id = ''.join(random.choices(string.ascii_letters + string.digits, k=22))
    body = {
        "key": public_key,
        "install_id": install_id,
        "fcm_token": f"{install_id}:APA91b{install_id}",
        "tos": datetime.datetime.now().isoformat() + "+02:00",
        "model": "PC",
        "serial_number": install_id,
        "locale": "en_US"
    }
    
    headers = {
        'Content-Type': 'application/json',
        'User-Agent': 'okhttp/3.12.1'
    }
    
    req = urllib.request.Request(
        'https://api.cloudflareclient.com/v0a884/reg',
        data=json.dumps(body).encode('utf8'),
        headers=headers
    )
    
    try:
        response = urllib.request.urlopen(req)
        data = json.loads(response.read())
        
        print("Registration successful!")
        print("Private Key: ", private_key)
        print("Public Key:  ", data['config']['peers'][0]['public_key'])
        print("Endpoint:    ", data['config']['peers'][0]['endpoint']['host'])
        print("AllowedIPs:  ", "0.0.0.0/0")
        print("Client IP:   ", data['config']['interface']['addresses']['v4'])
        
    except HTTPError as e:
        print("Error:", e.read().decode())

if __name__ == '__main__':
    register()
