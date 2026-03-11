import os
import json
from cryptography.fernet import Fernet

def verify_encryption():
    audit_log = "m:/vault-server/server/data/audit_log.json"
    key_file = "m:/vault-server/server/secret.key"
    
    print("--- Security Verification Script ---")
    
    if not os.path.exists(key_file):
        print(f"[FAIL] Secret key not found at {key_file}!")
        return

    with open(key_file, "rb") as f:
        key = f.read()
    
    cipher = Fernet(key)
    
    # Verify Audit Log
    if os.path.exists(audit_log):
        print(f"\nChecking Audit Log: {audit_log}")
        with open(audit_log, "rb") as f:
            content = f.read()
            
        if not content:
            print("[INFO] Audit log is empty.")
            return

        try:
            # Try to parse as JSON. If encrypted, this should FAIL.
            json.loads(content)
            print("[FAIL] Audit log is PLAINTEXT!")
        except:
            print("[PASS] Audit log is not valid JSON (likely encrypted).")
            
        try:
            decrypted = cipher.decrypt(content)
            # Try to parse decrypted as JSON
            data = json.loads(decrypted)
            print(f"[PASS] Successfully decrypted audit log. Found {len(data)} entries.")
        except Exception as e:
            print(f"[FAIL] Could not decrypt audit log with secret key: {e}")
    else:
        print(f"\n[SKIP] Audit log not found at {audit_log}")

if __name__ == "__main__":
    verify_encryption()
