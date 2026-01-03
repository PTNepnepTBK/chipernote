# ChiperNote - Secure Notes Application

## Architecture Overview

### ONE Database Encryption Key, MULTIPLE Ways to Access It

This application implements a secure architecture where:
- **ONE encryption key** is used to encrypt all notes
- **MULTIPLE authentication methods** can be used to access this key:
  1. Master Password
  2. Biometric Authentication (Fingerprint/Face ID)

### How It Works

#### 1. Initial Setup Flow
```
Splash Screen → Check if onboarding completed
  ├─ No  → Onboarding Screen → Setup Password Screen → Create Master Password + Encryption Key
  └─ Yes → Check if password exists
      ├─ Yes → Authentication Screen
      └─ No  → Setup Password Screen
```

#### 2. Encryption Key Management

**Key Generation (First Time Setup)**
1. User creates a master password
2. Password is hashed with salt and stored in SQLite
3. A **single encryption key** is generated and stored in Flutter Secure Storage
4. This key will encrypt ALL notes

**Key Access Methods**
- **Method 1: Master Password**
  - User enters password
  - Password is verified against hashed version in SQLite
  - If valid, encryption key is retrieved from Secure Storage
  - User is authenticated and can access notes

- **Method 2: Biometric (Fingerprint/Face ID)**
  - User enables biometric during setup
  - When app opens, biometric prompt appears
  - If biometric verification succeeds, encryption key is retrieved
  - User is authenticated and can access notes

#### 3. Data Storage Architecture

**SQLite Database Tables:**
- `app_settings` - Stores app configuration (e.g., onboarding_completed)
- `user_auth` - Stores hashed password, salt, biometric settings
- `notes` - Stores encrypted note data

**Flutter Secure Storage:**
- Stores the **ONE encryption key** securely
- Stores password salt
- Only accessible after successful authentication

### Security Features

1. **Bank-Grade Encryption (AES-256)**
   - All notes encrypted with AES-256-CBC
   - Unique IV for each note encryption

2. **Secure Password Storage**
   - Passwords never stored in plain text
   - SHA-256 hashing with unique salt
   - Salt stored separately in Secure Storage

3. **Biometric Integration**
   - Uses device's native biometric APIs
   - Biometric just grants access to encryption key
   - Original encryption key remains the same

4. **Session Management**
   - Encryption key loaded only after authentication
   - Key cleared from memory on logout
   - Re-authentication required on app restart

### Services Architecture

#### Core Services

1. **DatabaseService** (`database_service.dart`)
   - Manages SQLite database
   - Handles CRUD operations for settings, auth, and encrypted notes
   - Methods:
     - `setOnboardingCompleted()` / `hasCompletedOnboarding()`
     - `saveMasterPassword()` / `getMasterPasswordData()`
     - `saveNote()` / `getAllNotes()` / `deleteNote()`

2. **SecureStorageService** (`secure_storage_service.dart`)
   - Manages Flutter Secure Storage
   - Generates and stores encryption key
   - Handles password hashing and verification
   - Methods:
     - `generateAndStoreEncryptionKey()`
     - `getEncryptionKey()`
     - `hashPassword()` / `verifyPassword()`

3. **BiometricAuthService** (`biometric_auth_service.dart`)
   - Manages biometric authentication
   - Checks device capabilities
   - Methods:
     - `isBiometricAvailable()`
     - `authenticate()`
     - `getBiometricTypeName()`

4. **AuthService** (`auth_service.dart`)
   - Main authentication orchestrator
   - Combines password and biometric authentication
   - Manages encryption key access
   - Methods:
     - `setupMasterPassword()`
     - `authenticateWithPassword()`
     - `authenticateWithBiometric()`
     - `logout()`

5. **EncryptionService** (`encryption_service.dart`)
   - Encrypts/decrypts note content
   - Uses the ONE encryption key from AuthService
   - Methods:
     - `encryptNote()`
     - `decryptNote()`

6. **NotesService** (`notes_service.dart`)
   - High-level notes management
   - Combines database and encryption services
   - Methods:
     - `createNote()` - Encrypts and saves
     - `getAllNotes()` - Retrieves and decrypts
     - `updateNote()` / `deleteNote()`

### User Flow Examples

#### First Time User
1. Open app → Splash Screen
2. Onboarding screens (security features explained)
3. Setup Password Screen
   - Create master password
   - Optionally enable biometric
4. System generates encryption key
5. Navigate to Notes List (authenticated)

#### Returning User (Password Auth)
1. Open app → Splash Screen
2. Authentication Screen
3. Enter master password
4. System verifies password and retrieves encryption key
5. Navigate to Notes List (authenticated)

#### Returning User (Biometric Auth)
1. Open app → Splash Screen
2. Authentication Screen
3. Biometric prompt appears automatically
4. User authenticates with fingerprint/face
5. System retrieves encryption key
6. Navigate to Notes List (authenticated)

### File Structure
```
lib/
├── core/
│   ├── services/
│   │   ├── database_service.dart          # SQLite management
│   │   ├── secure_storage_service.dart    # Encryption key storage
│   │   ├── biometric_auth_service.dart    # Biometric APIs
│   │   ├── auth_service.dart              # Main auth orchestrator
│   │   ├── encryption_service.dart        # Note encryption/decryption
│   │   └── notes_service.dart             # Notes CRUD with encryption
│   └── ...
├── features/
│   ├── authentication/
│   │   └── screens/
│   │       ├── splash_screen.dart         # Initial routing logic
│   │       ├── onboarding_screen.dart     # First-time user intro
│   │       ├── setup_password_screen.dart # Master password setup
│   │       └── auth_screen.dart           # App unlock screen
│   └── notes/
│       └── screens/
│           └── notes_list_screen.dart     # Main app screen
└── main.dart
```

### Dependencies Used
- `sqflite` - SQLite database
- `flutter_secure_storage` - Secure key storage
- `local_auth` - Biometric authentication
- `encrypt` - AES encryption
- `crypto` - Hashing functions
- `uuid` - Unique note IDs

### Testing the App

1. **First Launch**
   - Should show onboarding
   - Create a master password
   - Enable/disable biometric
   - See notes list

2. **Close and Reopen**
   - Should skip onboarding
   - Show authentication screen
   - Test password unlock
   - Test biometric unlock (if enabled)

3. **Security Tests**
   - Wrong password should fail
   - Biometric cancellation should not grant access
   - App data persists across restarts

### Important Notes

⚠️ **Security Considerations:**
- Master password cannot be recovered (by design)
- Encryption key is tied to the device's secure storage
- If user forgets password and biometric fails, data is unrecoverable
- Consider implementing a backup/export feature for production

🔐 **Why This Architecture?**
- **Flexibility**: Multiple authentication methods using same key
- **Security**: Key never exposed, only accessed when authenticated
- **User Experience**: Convenient biometric access without compromising security
- **Scalability**: Easy to add more authentication methods (e.g., PIN, pattern)

### Future Enhancements
- [ ] Add PIN code authentication
- [ ] Implement note categories/folders
- [ ] Add note sharing with encryption
- [ ] Cloud backup with end-to-end encryption
- [ ] Password change functionality
- [ ] Export/import encrypted notes
