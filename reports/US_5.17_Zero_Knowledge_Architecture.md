# Zero-Knowledge Architecture Documentation
## Password Manager Application

**Document Version:** 1.0  
**Last Updated:** 2026-02-08  
**Classification:** Public

---

## 1. Executive Summary

This password manager implements a **zero-knowledge architecture**, meaning:

> **The server cannot decrypt, view, or access your vault data, even if compromised.**

Your master password never leaves your device in plaintext, and vault decryption happens entirely on your device. The server only stores encrypted data that is useless without your master password.

---

## 2. Zero-Knowledge Principles

### Core Guarantee
```
┌─────────────────────────────────────────────┐
│  "We cannot see your passwords,             │
│   even if we wanted to."                    │
│                                             │
│  - Server admins cannot access vault data   │
│  - Database breaches expose no passwords    │
│  - Court orders cannot compel decryption    │
└─────────────────────────────────────────────┘
```

### What This Means

✅ **You control:**
- Your master password (never shared)
- Vault decryption keys (derived locally)
- All plaintext password data

❌ **Server never has:**
- Your master password
- Vault decryption keys
- Any plaintext vault content

---

## 3. Architecture Overview

### High-Level Data Flow

```
┌──────────────────────────────────────────────────────────────┐
│                     YOUR DEVICE (Client)                      │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ 1. Master Password: "MySecretPassword123"              │  │
│  │                          ↓                             │  │
│  │ 2. Derive Auth Key: Argon2(password + auth_salt)      │  │
│  │    → Used for authentication only                     │  │
│  │                          ↓                             │  │
│  │ 3. Derive Vault Key: Argon2(password + vault_salt)    │  │
│  │    → Used for vault encryption only                   │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
                              ↓ (send auth verifier)
                              ↓ (send encrypted vault)
┌──────────────────────────────────────────────────────────────┐
│                       SERVER (Backend)                        │
│  ┌────────────────────────────────────────────────────────┐  │
│  │ Stores (ALL ENCRYPTED):                                │  │
│  │  - auth_salt (public)                                  │  │
│  │  - verifier (hashed auth key)                          │  │
│  │  - vault_salt (transmitted with vault)                 │  │
│  │  - encrypted_vault (XChaCha20-Poly1305 ciphertext)     │  │
│  │                                                         │  │
│  │ ❌ NEVER has:                                          │  │
│  │  - Master password                                     │  │
│  │  - Vault decryption key                                │  │
│  │  - Plaintext passwords                                 │  │
│  └────────────────────────────────────────────────────────┘  │
└──────────────────────────────────────────────────────────────┘
```

---

## 4. Cryptographic Implementation

### Registration Flow

```dart
// CLIENT SIDE ONLY
String masterPassword = "MySecretPassword123";

// Step 1: Generate random auth salt (public, stored on server)
Uint8List authSalt = randomBytes(16);

// Step 2: Derive authentication verifier
Uint8List authKey = Argon2(
  password: masterPassword,
  salt: authSalt,
  time_cost: 3,
  memory_cost: 128MB,
  parallelism: 4,
  output_length: 32
);

// Step 3: Send to server (password never sent!)
POST /register {
  username: "alice",
  salt: hex(authSalt),      // Server stores this
  verifier: hex(authKey)    // Server stores this
}
```

**Key Point:** The auth key is derived from the password but **cannot be reversed** to get the password back (Argon2 is a one-way function).

### Login Flow

```dart
// CLIENT SIDE
String masterPassword = getUserInput();

// Step 1: Get user's auth salt from server
authSalt = GET /auth_salt/alice

// Step 2: Re-derive auth key locally
authKey = Argon2(masterPassword, authSalt, ...)

// Step 3: Send verifier to server
token = POST /login {
  username: "alice",
  verifier: hex(authKey)
}

// Server compares verifier with stored value
// If match → returns session token
// Password never sent over network!
```

### Vault Encryption Flow

```dart
// CLIENT SIDE
Map<String, String> vault = {
  "gmail": "password123",
  "bank": "securePass456"
};

// Step 1: Generate random vault salt
Uint8List vaultSalt = randomBytes(16);

// Step 2: Derive vault encryption key (different from auth key!)
Uint8List vaultKey = Argon2(
  password: masterPassword,  // Same password, different salt
  salt: vaultSalt,           // Different salt = different key
  ...
);

// Step 3: Encrypt vault
Uint8List nonce = randomBytes(24);
Uint8List ciphertext = XChaCha20_Poly1305_Encrypt(
  plaintext: json.encode(vault),
  key: vaultKey,
  nonce: nonce
);

// Step 4: Send encrypted blob to server
POST /vault {
  blob: {
    vault_salt: hex(vaultSalt),     // Needed to re-derive key
    nonce: hex(nonce),              // Needed for decryption
    ciphertext: hex(ciphertext)     // Encrypted password data
  }
}
```

**Key Point:** The server receives encrypted data + metadata (salt, nonce) but the vault key never leaves your device.

### Vault Decryption Flow

```dart
// CLIENT SIDE
blob = GET /vault  // Download encrypted blob

// Step 1: Extract components
vaultSalt = hex_decode(blob.vault_salt);
nonce = hex_decode(blob.nonce);
ciphertext = hex_decode(blob.ciphertext);

// Step 2: Re-derive vault key from master password
vaultKey = Argon2(masterPassword, vaultSalt, ...);

// Step 3: Decrypt vault
plaintext = XChaCha20_Poly1305_Decrypt(
  ciphertext: ciphertext,
  key: vaultKey,
  nonce: nonce
);

vault = json.decode(plaintext);
// Now you can see your passwords!
```

---

## 5. Security Properties

### Authentication Without Password Transmission

**Traditional (Insecure):**
```
Client → Server: "username=alice&password=MySecret123"
❌ Password exposed to server
❌ Server breach = passwords leaked
```

**Our Approach (Secure):**
```
Client: Derives verifier = Argon2(password, salt)
Client → Server: "username=alice&verifier=a7f2e9c4..."
✅ Password never leaves client
✅ Server breach = only hashed verifiers leaked (useless)
```

### Separation of Concerns: Two Different Keys

| Purpose | Key Derivation | Stored On Server? | Reversible? |
|---------|----------------|-------------------|-------------|
| **Authentication** | Argon2(password, auth_salt) | Yes (as verifier) | No |
| **Vault Encryption** | Argon2(password, vault_salt) | No | No |

**Why two keys?**
- Compromising auth verifier ≠ ability to decrypt vault
- Losing session token ≠ losing vault encryption key
- Defense in depth

### End-to-End Encryption

```
Your Device         Network         Server          Database
    │                  │               │                │
    ├─ Encrypt ───────┼──────────────→│                │
    │  (plaintext      │  (ciphertext) │                │
    │   known here)    │               ├─ Store ───────→│
    │                  │               │  (ciphertext)  │
    │                  │               │                │
    ├─ Decrypt ←───────┼───────────────┤                │
    │  (plaintext      │  (ciphertext) │  (ciphertext)  │
    │   known here)    │               │                │
```

**At no point does the server see plaintext passwords.**

---

## 6. Threat Model

### What Zero-Knowledge Protects Against

✅ **Server Compromise**
- Attacker gains root access to server
- **Result:** Cannot decrypt vaults (no keys)

✅ **Database Breach**
- Attacker dumps entire database
- **Result:** Encrypted blobs are useless

✅ **Network Eavesdropping** (with HTTPS)
- Attacker intercepts traffic
- **Result:** Only encrypted data visible

✅ **Rogue Employee**
- Malicious admin tries to read vaults
- **Result:** Cannot decrypt without user's password

✅ **Government Subpoena**
- Court orders data disclosure
- **Result:** Can only provide encrypted data

### What Zero-Knowledge DOES NOT Protect Against

❌ **Weak Master Password**
- User chooses "password123"
- **Risk:** Brute-force attack may succeed

❌ **Client-Side Compromise**
- Malware on user's device
- **Risk:** Can capture master password during entry

❌ **Phishing**
- User enters password on fake site
- **Risk:** Attacker gets master password

❌ **Forgotten Password**
- User forgets master password
- **Result:** PERMANENT DATA LOSS (by design)

---

## 7. Verification & Auditing

### How to Verify Zero-Knowledge Claims

**As a User:**
1. **Inspect network traffic**: Use browser DevTools or Wireshark
   - Confirm master password never sent
   - Confirm only encrypted blobs transmitted

2. **Read source code**: This is open-source
   - Check `lib/services/auth_service.dart`
   - Verify encryption happens client-side

3. **Test offline**: Disconnect from network
   - Can you still decrypt your vault? (Yes, if cached)
   - Proves decryption is client-side

**As an Auditor:**
1. Review cryptographic implementation
2. Verify key derivation parameters
3. Check for key material leakage
4. Test server-side access (should fail)

---

## 8. Compliance & Standards

### Cryptographic Standards

| Component | Algorithm | Standard |
|-----------|-----------|----------|
| Password Hashing | Argon2id | RFC 9106 |
| Vault Encryption | XChaCha20-Poly1305 | RFC 8439 + draft-irtf-cfrg-xchacha |
| Random Generation | Secure Random | CSRNG |

### Zero-Knowledge Best Practices

✅ **Key Derivation:**
- Uses Argon2id (memory-hard, resistant to GPU attacks)
- Sufficient iterations (time_cost=3, memory=128MB)
- Unique salts per user

✅ **Encryption:**
- Authenticated encryption (prevents tampering)
- Modern cipher (XChaCha20)
- Unique nonces (never reused)

✅ **Architecture:**
- Clear separation of auth & encryption keys
- No key material stored on server
- Client-side cryptography only

---

## 9. Limitations & Considerations

### Data We DO Store (Not Zero-Knowledge)

| Data | Visibility | Reason |
|------|------------|--------|
| Username | Server can see | Needed for routing requests |
| Login timestamps | Server can log | Needed for monitoring |
| IP addresses | Server can log | Needed for rate limiting |
| Vault size | Server can see | File system metadata |

**Note:** We commit to not storing unnecessary metadata. See Transparency Reports for details.

### Recovery = Impossible by Design

If you forget your master password:
- ❌ We cannot reset it
- ❌ We cannot recover your vault
- ❌ Your data is permanently lost

**This is a feature, not a bug.**  
Any "recovery" mechanism would violate zero-knowledge principles.

**Recommendation:** Use strong, memorable passwords and consider offline backups.

---

## 10. Future Enhancements

### Planned Improvements (Maintain Zero-Knowledge)

- [ ] **Account recovery codes**: User-generated backup codes
- [ ] **Multi-device sync**: Encrypted sync without server access
- [ ] **Secure sharing**: Share passwords without revealing to server
- [ ] **Biometric unlock**: Local authentication (password cached encrypted)

### Will NOT Implement (Violates Zero-Knowledge)

- ❌ Password recovery email
- ❌ Admin password reset
- ❌ Server-side password hints
- ❌ Weak password recovery "security questions"

---

## 11. Frequently Asked Questions

**Q: What if I forget my master password?**  
A: Your data is irrecoverably lost. This is by design. There is no "reset password" option.

**Q: Can the server admin see my passwords?**  
A: No. Your passwords are encrypted on your device before being sent to the server.

**Q: What if the server gets hacked?**  
A: The attacker gets encrypted blobs. Without your master password, they're useless.

**Q: How do I know you're telling the truth?**  
A: The code is open-source. You can verify the claims yourself or hire a security auditor.

**Q: Is this really more secure than [other password manager]?**  
A: Zero-knowledge is a standard feature in modern password managers. We implement the same guarantees as 1Password, Bitwarden, etc.

**Q: What about the "Forgot Password" link I see everywhere?**  
A: Those violate zero-knowledge. We prioritize security over convenience.

---

## 12. Conclusion

This password manager's zero-knowledge architecture ensures that:

1. **Your master password never leaves your device**
2. **Vault encryption keys never leave your device**
3. **The server stores only encrypted, unusable data**
4. **Even we cannot decrypt your passwords**

This design trades convenience (no password recovery) for maximum security. If you value privacy and security over ease of recovery, zero-knowledge is the right choice.

---

## References

- [Argon2 RFC 9106](https://www.rfc-editor.org/rfc/rfc9106.html)
- [XChaCha20-Poly1305 Specification](https://datatracker.ietf.org/doc/html/draft-irtf-cfrg-xchacha)
- [Zero-Knowledge Proofs (General)](https://en.wikipedia.org/wiki/Zero-knowledge_proof)

---

## Document Change Log

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2026-02-08 | Initial creation | Security Team |

---

**Next Review Date:** 2026-08-08
