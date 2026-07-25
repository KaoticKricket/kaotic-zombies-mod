#!/usr/bin/env python3
"""
TikTok Interactive Bridge for Black Ops 3 Zombies
Connects TikTok/Tikfinity events to BO3 dedicated server via RCON
"""

import socket
import time
import json
import threading
import requests
from flask import Flask, request, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)

# Configuration
TIKTOK_WEBHOOK_PORT = 5000
RCON_HOST = "127.0.0.1"
RCON_PORT = 27015
RCON_PASSWORD = ""  # Set your RCON password here

# Creator network access control
CREATOR_NETWORK_FILE = "creator_network.json"
AUTHORIZED_CREATORS = set()

def load_creator_network():
    """Load authorized creator IDs from file"""
    global AUTHORIZED_CREATORS
    try:
        with open(CREATOR_NETWORK_FILE, 'r') as f:
            data = json.load(f)
            AUTHORIZED_CREATORS = set(data.get('creators', []))
            print(f"Loaded {len(AUTHORIZED_CREATORS)} authorized creators")
    except FileNotFoundError:
        print("Creator network file not found, starting with empty network")
        AUTHORIZED_CREATORS = set()
    except Exception as e:
        print(f"Error loading creator network: {e}")
        AUTHORIZED_CREATORS = set()

def is_creator_authorized(creator_id):
    """Check if creator is in authorized network"""
    return creator_id in AUTHORIZED_CREATORS

def send_rcon_command(command):
    """Send RCON command to BO3 dedicated server"""
    try:
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        sock.settimeout(5)
        
        # RCON protocol for BO3
        # Format: 4 bytes length + 4 bytes type + payload + null terminator
        payload = command.encode('utf-8') + b'\x00'
        if RCON_PASSWORD:
            payload = RCON_PASSWORD.encode('utf-8') + b' ' + payload
        
        # BO3 uses a simple RCON implementation
        message = payload
        sock.sendto(message, (RCON_HOST, RCON_PORT))
        
        # Try to receive response
        try:
            response, _ = sock.recvfrom(1024)
            print(f"RCON response: {response.decode('utf-8', errors='ignore')}")
        except socket.timeout:
            print("RCON command sent (no response)")
        
        sock.close()
        return True
    except Exception as e:
        print(f"RCON error: {e}")
        return False

def dispatch_event_to_bo3(event_name, event_id, creator_id):
    """Dispatch event to BO3 via RCON"""
    print(f"Dispatching event: {event_name} (ID: {event_id}, Creator: {creator_id})")
    
    # Send event name first
    send_rcon_command(f"set kaotic_event_name {event_name}")
    time.sleep(0.1)
    
    # Send creator ID
    send_rcon_command(f"set kaotic_creator_id {creator_id}")
    time.sleep(0.1)
    
    # Send event ID to trigger the event
    send_rcon_command(f"set kaotic_event_id {event_id}")

@app.route('/webhook/tiktok', methods=['POST'])
def tiktok_webhook():
    """Receive TikTok interactive events"""
    try:
        data = request.json
        
        # Verify creator authorization
        creator_id = data.get('creator_id', '')
        if not is_creator_authorized(creator_id):
            print(f"Unauthorized creator attempt: {creator_id}")
            return jsonify({'status': 'unauthorized', 'message': 'Creator not in network'}), 403
        
        # Extract event data
        event_name = data.get('event_name', '')
        event_id = data.get('event_id', str(int(time.time() * 1000)))
        
        if not event_name:
            return jsonify({'status': 'error', 'message': 'Missing event_name'}), 400
        
        # Dispatch to BO3
        dispatch_event_to_bo3(event_name, event_id, creator_id)
        
        return jsonify({'status': 'success', 'event': event_name})
    
    except Exception as e:
        print(f"Webhook error: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/creator/add', methods=['POST'])
def add_creator():
    """Add creator to authorized network"""
    try:
        data = request.json
        creator_id = data.get('creator_id', '')
        
        if not creator_id:
            return jsonify({'status': 'error', 'message': 'Missing creator_id'}), 400
        
        AUTHORIZED_CREATORS.add(creator_id)
        
        # Save to file
        with open(CREATOR_NETWORK_FILE, 'w') as f:
            json.dump({'creators': list(AUTHORIZED_CREATORS)}, f, indent=2)
        
        # Update BO3 server with new whitelist
        creator_list = ','.join(AUTHORIZED_CREATORS)
        send_rcon_command(f"set kaotic_creator_whitelist {creator_list}")
        
        print(f"Added creator: {creator_id}")
        return jsonify({'status': 'success', 'creators': list(AUTHORIZED_CREATORS)})
    
    except Exception as e:
        print(f"Add creator error: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/creator/remove', methods=['POST'])
def remove_creator():
    """Remove creator from authorized network"""
    try:
        data = request.json
        creator_id = data.get('creator_id', '')
        
        if not creator_id:
            return jsonify({'status': 'error', 'message': 'Missing creator_id'}), 400
        
        AUTHORIZED_CREATORS.discard(creator_id)
        
        # Save to file
        with open(CREATOR_NETWORK_FILE, 'w') as f:
            json.dump({'creators': list(AUTHORIZED_CREATORS)}, f, indent=2)
        
        # Update BO3 server with new whitelist
        creator_list = ','.join(AUTHORIZED_CREATORS)
        send_rcon_command(f"set kaotic_creator_whitelist {creator_list}")
        
        print(f"Removed creator: {creator_id}")
        return jsonify({'status': 'success', 'creators': list(AUTHORIZED_CREATORS)})
    
    except Exception as e:
        print(f"Remove creator error: {e}")
        return jsonify({'status': 'error', 'message': str(e)}), 500

@app.route('/creator/list', methods=['GET'])
def list_creators():
    """List all authorized creators"""
    return jsonify({'status': 'success', 'creators': list(AUTHORIZED_CREATORS)})

@app.route('/health', methods=['GET'])
def health():
    """Health check endpoint"""
    return jsonify({'status': 'healthy', 'creators_count': len(AUTHORIZED_CREATORS)})

if __name__ == '__main__':
    print("Starting TikTok Interactive Bridge for Black Ops 3 Zombies...")
    print(f"Webhook server listening on port {TIKTOK_WEBHOOK_PORT}")
    print(f"RCON target: {RCON_HOST}:{RCON_PORT}")
    
    load_creator_network()
    
    app.run(host='0.0.0.0', port=TIKTOK_WEBHOOK_PORT, debug=False)
