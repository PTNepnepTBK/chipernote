# ChiperNote - Visual Architecture Diagrams

## 1. Authentication Flow Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        APP STARTUP                               │
└─────────────────────────────────────────────────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  Splash Screen   │
                    └──────────────────┘
                              │
                              ▼
                 ┌────────────────────────┐
                 │  Check Onboarding      │
                 │  Status (SQLite)       │
                 └────────────────────────┘
                              │
                ┌─────────────┴─────────────┐
                │                           │
                ▼                           ▼
    ┌──────────────────┐        ┌──────────────────┐
    │  Onboarding      │        │  Check Master    │
    │  Not Completed   │        │  Password Exists │
    └──────────────────┘        └──────────────────┘
                │                           │
                ▼                 ┌─────────┴─────────┐
    ┌──────────────────┐         │                   │
    │  Show Onboarding │         ▼                   ▼
    │  Screens (1-3)   │   ┌─────────┐      ┌──────────────┐
    └──────────────────┘   │  Exists │      │  Not Exists  │
                │           └─────────┘      └──────────────┘
                ▼                 │                   │
    ┌──────────────────┐         │                   │
    │  Mark Completed  │         │                   │
    │  in SQLite       │         │                   │
    └──────────────────┘         │                   │
                │                 │                   │
                └─────────────────┴───────────────────┘
                              │
                              ▼
                ┌──────────────────────────┐
                │  Setup Password Screen   │
                │  (First Time Only)       │
                └──────────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────┐
        │  1. User enters master password         │
        │  2. Generate salt & hash password       │
        │  3. Generate encryption key             │
        │  4. Save hash+salt to SQLite            │
        │  5. Save encryption key to Secure Store │
        │  6. Optional: Enable biometric          │
        └─────────────────────────────────────────┘
                              │
                              ▼
                ┌──────────────────────────┐
                │  Authentication Screen   │
                │  (Returning Users)       │
                └──────────────────────────┘
                              │
                ┌─────────────┴─────────────┐
                │                           │
                ▼                           ▼
    ┌──────────────────┐        ┌──────────────────┐
    │  Password Auth   │        │  Biometric Auth  │
    │  (Method 1)      │        │  (Method 2)      │
    └──────────────────┘        └──────────────────┘
                │                           │
                │  ┌─────────────────────┐  │
                └──│  Verify & Get       │──┘
                   │  Encryption Key     │
                   └─────────────────────┘
                              │
                              ▼
                    ┌──────────────────┐
                    │  Notes List      │
                    │  (Authenticated) │
                    └──────────────────┘
```

## 2. Encryption Key Management

```
┌─────────────────────────────────────────────────────────────────┐
│             ONE ENCRYPTION KEY CONCEPT                           │
└─────────────────────────────────────────────────────────────────┘

                    ┌─────────────────────┐
                    │  Setup Password     │
                    └─────────────────────┘
                              │
                              ▼
        ┌─────────────────────────────────────────┐
        │  Generate ONE Encryption Key            │
        │  (AES-256, stored in Secure Storage)    │
        └─────────────────────────────────────────┘
                              │
                              ▼
                ┌─────────────────────────┐
                │  This KEY encrypts      │
                │  ALL notes in the app   │
                └─────────────────────────┘
                              │
                ┌─────────────┴─────────────┐
                │                           │
                ▼                           ▼
    ┌──────────────────────┐    ┌──────────────────────┐
    │  Access Method 1:    │    │  Access Method 2:    │
    │  Master Password     │    │  Biometric           │
    └──────────────────────┘    └──────────────────────┘
                │                           │
                │                           │
                └───────────┬───────────────┘
                            │
                            ▼
                ┌───────────────────────┐
                │  Retrieve the SAME    │
                │  Encryption Key       │
                └───────────────────────┘
                            │
                            ▼
                ┌───────────────────────┐
                │  Decrypt Notes        │
                └───────────────────────┘
```

## 3. Data Storage Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    STORAGE LAYERS                                │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  Layer 1: SQLite Database (chipernote.db)                       │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────────────────────────────────┐         │
│  │  Table: app_settings                               │         │
│  │  ┌──────────┬─────────────┬────────────────────┐  │         │
│  │  │   key    │    value    │    created_at      │  │         │
│  │  ├──────────┼─────────────┼────────────────────┤  │         │
│  │  │ onboard..│    'true'   │  2026-01-03...     │  │         │
│  │  └──────────┴─────────────┴────────────────────┘  │         │
│  └────────────────────────────────────────────────────┘         │
│                                                                  │
│  ┌────────────────────────────────────────────────────┐         │
│  │  Table: user_auth                                  │         │
│  │  ┌──────────────┬────────┬─────────────────────┐  │         │
│  │  │  password    │  salt  │  biometric_enabled  │  │         │
│  │  │  _hash       │        │                     │  │         │
│  │  ├──────────────┼────────┼─────────────────────┤  │         │
│  │  │  abc123...   │ xyz... │         1           │  │         │
│  │  └──────────────┴────────┴─────────────────────┘  │         │
│  └────────────────────────────────────────────────────┘         │
│                                                                  │
│  ┌────────────────────────────────────────────────────┐         │
│  │  Table: notes (ENCRYPTED!)                         │         │
│  │  ┌──────┬───────┬──────────────────────────────┐  │         │
│  │  │  id  │ title │    encrypted_data            │  │         │
│  │  ├──────┼───────┼──────────────────────────────┤  │         │
│  │  │ uuid │ "My"  │  "IV:base64:encryptedtext"   │  │         │
│  │  └──────┴───────┴──────────────────────────────┘  │         │
│  └────────────────────────────────────────────────────┘         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  Layer 2: Flutter Secure Storage (OS Keychain/Keystore)         │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  ┌────────────────────────────────────────────────────┐         │
│  │  Key: encryption_key                               │         │
│  │  Value: "base64encodedkey..."                      │         │
│  │  (This is the ONE key that encrypts ALL notes)     │         │
│  └────────────────────────────────────────────────────┘         │
│                                                                  │
│  ┌────────────────────────────────────────────────────┐         │
│  │  Key: password_salt                                │         │
│  │  Value: "randomsalt..."                            │         │
│  └────────────────────────────────────────────────────┘         │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────┐
│  Layer 3: Memory (Runtime Only)                                 │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  AuthService._currentEncryptionKey (after authentication)       │
│  - Loaded from Secure Storage                                   │
│  - Used for encrypt/decrypt operations                          │
│  - Cleared on logout                                            │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

## 4. Authentication Methods Comparison

```
┌─────────────────────────────────────────────────────────────────┐
│             METHOD 1: PASSWORD AUTHENTICATION                    │
└─────────────────────────────────────────────────────────────────┘

  User enters password
         │
         ▼
  ┌───────────────┐
  │  Hash with    │
  │  stored salt  │
  └───────────────┘
         │
         ▼
  ┌───────────────┐      ┌─────────────┐
  │  Compare with │─────▶│   SQLite    │
  │  stored hash  │      │  user_auth  │
  └───────────────┘      └─────────────┘
         │
         ▼
     ┌────────┐
     │ Match? │
     └────────┘
         │
    ┌────┴────┐
    │         │
   YES       NO
    │         │
    │         └──▶ Authentication Failed
    │
    ▼
  ┌────────────────────┐
  │  Retrieve          │
  │  Encryption Key    │
  │  from Secure Store │
  └────────────────────┘
    │
    ▼
  ┌────────────────────┐
  │  Load key to       │
  │  memory            │
  └────────────────────┘
    │
    ▼
  Authenticated! ✓


┌─────────────────────────────────────────────────────────────────┐
│            METHOD 2: BIOMETRIC AUTHENTICATION                    │
└─────────────────────────────────────────────────────────────────┘

  Show biometric prompt
  (Fingerprint/Face)
         │
         ▼
  ┌───────────────┐
  │  OS handles   │
  │  verification │
  └───────────────┘
         │
         ▼
     ┌────────┐
     │Success?│
     └────────┘
         │
    ┌────┴────┐
    │         │
   YES       NO
    │         │
    │         └──▶ Authentication Failed
    │
    ▼
  ┌────────────────────┐
  │  Retrieve          │
  │  Encryption Key    │
  │  from Secure Store │
  │  (SAME KEY!)       │
  └────────────────────┘
    │
    ▼
  ┌────────────────────┐
  │  Load key to       │
  │  memory            │
  └────────────────────┘
    │
    ▼
  Authenticated! ✓


  ★ BOTH METHODS ACCESS THE SAME ENCRYPTION KEY ★
```

## 5. Note Encryption Flow

```
┌─────────────────────────────────────────────────────────────────┐
│                    CREATE ENCRYPTED NOTE                         │
└─────────────────────────────────────────────────────────────────┘

  User writes note content
         │
         ▼
  ┌────────────────────┐
  │  "My secret note   │
  │   content here"    │
  └────────────────────┘
         │
         ▼
  ┌────────────────────┐
  │  Get encryption    │
  │  key from memory   │
  │  (must be auth'd)  │
  └────────────────────┘
         │
         ▼
  ┌────────────────────┐
  │  Generate random   │
  │  IV (16 bytes)     │
  └────────────────────┘
         │
         ▼
  ┌────────────────────┐
  │  AES-256-CBC       │
  │  Encrypt           │
  └────────────────────┘
         │
         ▼
  ┌────────────────────┐
  │  "IV:base64:       │
  │   encrypteddata"   │
  └────────────────────┘
         │
         ▼
  ┌────────────────────┐
  │  Save to SQLite    │
  │  notes table       │
  └────────────────────┘


┌─────────────────────────────────────────────────────────────────┐
│                    READ ENCRYPTED NOTE                           │
└─────────────────────────────────────────────────────────────────┘

  User opens note
         │
         ▼
  ┌────────────────────┐
  │  Fetch encrypted   │
  │  data from SQLite  │
  └────────────────────┘
         │
         ▼
  ┌────────────────────┐
  │  "IV:base64:       │
  │   encrypteddata"   │
  └────────────────────┘
         │
         ▼
  ┌────────────────────┐
  │  Split IV and      │
  │  encrypted text    │
  └────────────────────┘
         │
         ▼
  ┌────────────────────┐
  │  Get encryption    │
  │  key from memory   │
  └────────────────────┘
         │
         ▼
  ┌────────────────────┐
  │  AES-256-CBC       │
  │  Decrypt           │
  └────────────────────┘
         │
         ▼
  ┌────────────────────┐
  │  "My secret note   │
  │   content here"    │
  └────────────────────┘
         │
         ▼
  Display to user
```

## 6. Security Layers

```
┌──────────────────────────────────────────────────────────────┐
│                      SECURITY LAYERS                          │
└──────────────────────────────────────────────────────────────┘

Layer 1: User Authentication
┌──────────────────────────────────────────────────────────────┐
│  • Master Password (hashed, never plain text)                │
│  • Biometric (OS-level verification)                         │
│  ✓ Prevents unauthorized access                             │
└──────────────────────────────────────────────────────────────┘
                            ↓
Layer 2: Encryption Key Protection
┌──────────────────────────────────────────────────────────────┐
│  • Stored in OS Secure Storage (Keychain/Keystore)          │
│  • Only accessible after authentication                      │
│  • Never exposed in plain text                              │
│  ✓ Protects the master key                                  │
└──────────────────────────────────────────────────────────────┘
                            ↓
Layer 3: Data Encryption
┌──────────────────────────────────────────────────────────────┐
│  • AES-256-CBC encryption                                    │
│  • Unique IV per encryption                                  │
│  • All notes encrypted with master key                      │
│  ✓ Protects the actual content                              │
└──────────────────────────────────────────────────────────────┘
                            ↓
Layer 4: Database Storage
┌──────────────────────────────────────────────────────────────┐
│  • SQLite with encrypted data                                │
│  • No plain text content stored                              │
│  • Metadata minimized                                        │
│  ✓ Secure persistence                                        │
└──────────────────────────────────────────────────────────────┘

Result: Multi-layered defense against unauthorized access
```

## Summary

These diagrams illustrate:
1. **Complete authentication flow** from app start to notes access
2. **ONE key, MULTIPLE access** concept visually explained
3. **Data storage architecture** with clear separation of concerns
4. **Comparison of authentication methods** showing they access the same key
5. **Note encryption/decryption flow** with AES-256
6. **Security layers** providing defense in depth

The architecture is designed for both **security** and **flexibility**, allowing users to choose their preferred authentication method while maintaining a single, secure encryption key for all their notes.
