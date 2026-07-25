#!/usr/bin/env python3
"""
Creator Network Management Script
"""

import requests
import json
import sys

BRIDGE_URL = "http://127.0.0.1:5000"

def add_creator(creator_id):
    try:
        response = requests.post(f"{BRIDGE_URL}/creator/add", json={"creator_id": creator_id})
        print(response.json())
    except Exception as e:
        print(f"Error: {e}")

def remove_creator(creator_id):
    try:
        response = requests.post(f"{BRIDGE_URL}/creator/remove", json={"creator_id": creator_id})
        print(response.json())
    except Exception as e:
        print(f"Error: {e}")

def list_creators():
    try:
        response = requests.get(f"{BRIDGE_URL}/creator/list")
        print(response.json())
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python manage_creators.py [add|remove|list] [creator_id]")
        sys.exit(1)
    
    command = sys.argv[1].lower()
    
    if command == "add":
        if len(sys.argv) < 3:
            print("Usage: python manage_creators.py add <creator_id>")
            sys.exit(1)
        add_creator(sys.argv[2])
    elif command == "remove":
        if len(sys.argv) < 3:
            print("Usage: python manage_creators.py remove <creator_id>")
            sys.exit(1)
        remove_creator(sys.argv[2])
    elif command == "list":
        list_creators()
    else:
        print("Unknown command. Use: add, remove, or list")
