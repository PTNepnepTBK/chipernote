# ChiperNote 🔐

**Secure Notes Application with Bank-Grade Encryption**

ChiperNote adalah aplikasi catatan terenkripsi yang mengimplementasikan konsep **ONE Database Encryption Key, MULTIPLE Ways to Access It**. Aplikasi ini menyediakan keamanan tingkat perbankan dengan AES-256 encryption, sambil memberikan fleksibilitas autentikasi melalui master password atau biometric (fingerprint/Face ID).

![Flutter](https://img.shields.io/badge/Flutter-3.9.2-02569B?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0-0175C2?logo=dart)
![License](https://img.shields.io/badge/License-MIT-green)

## ✨ Features

### 🔒 Security
- **AES-256-CBC Encryption** - Bank-grade encryption untuk semua catatan
- **Master Password** - Password di-hash dengan SHA-256 + salt
- **Biometric Authentication** - Unlock dengan fingerprint atau Face ID
- **ONE Encryption Key** - Satu kunci untuk semua catatan, multiple cara akses
- **Secure Storage** - Encryption key tersimpan di OS Keychain/Keystore
- **No Plain Text** - Tidak ada data sensitif yang disimpan plain text

### 🎯 User Experience
- **Beautiful Dark UI** - Modern design dengan gradient dan animations
- **Onboarding Flow** - Penjelasan fitur untuk first-time users
- **Auto Biometric Prompt** - Biometric prompt otomatis saat buka app
- **Password Fallback** - Selalu bisa pakai password jika biometric gagal
- **Persistent State** - Status onboarding dan authentication tersimpan
- **Smooth Animations** - Lock rotation, glow effects, fade transitions

### 📱 Functionality
- Create, Read, Update, Delete notes (CRUD)
- Automatic encryption/decryption
- pinned notes
- Color-coded notes
- Search and filter (future)
- Categories and folders (future)

## 🏗️ Architecture

### ONE Encryption Key, MULTIPLE Access Methods

```
┌─────────────────────────────────────────┐
│        ONE ENCRYPTION KEY               │
│  (Stored in Secure Storage)             │
└─────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
        ▼                       ▼
┌─────────────┐         ┌─────────────┐
│  Method 1:  │         │  Method 2:  │
│  Password   │         │  Biometric  │
└─────────────┘         └─────────────┘
        │                       │
        └───────────┬───────────┘
                    │
                    ▼
          ┌─────────────────┐
          │  Access Notes   │
          │  (Encrypted)    │
          └─────────────────┘
```

**Keuntungan:**
- User flexibility (pilih cara paling nyaman)
- Security consistency (semua catatan terenkripsi sama)
- Easy to extend (mudah tambah method baru: PIN, pattern, dll)

### Tech Stack

- **Framework:** Flutter 3.9.2
- **Language:** Dart 3.0
- **Database:** SQLite (sqflite)
- **Secure Storage:** flutter_secure_storage (Keychain/Keystore)
- **Biometric:** local_auth
- **Encryption:** AES-256-CBC (encrypt package)
- **Hashing:** SHA-256 (crypto package)

### Services Architecture

```
lib/core/services/
├── database_service.dart       # SQLite operations
├── secure_storage_service.dart # Encryption key management
├── biometric_auth_service.dart # Biometric APIs
├── auth_service.dart           # Auth orchestrator
├── encryption_service.dart     # AES encryption/decryption
└── notes_service.dart          # Notes CRUD with encryption
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK 3.9.2 or higher
- Dart 3.0 or higher
- Android Studio / VS Code
- Device/Emulator dengan biometric support (optional)

### Installation

1. **Clone repository:**
   ```bash
   git clone https://github.com/yourusername/chipernote.git
   cd chipernote
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

### First Run

1. Splash screen akan muncul (2-3 detik)
2. Onboarding screens (3 halaman) - swipe untuk lanjut
3. Setup Password screen:
   - Buat master password (min 8 karakter)
   - Aktifkan biometric (optional)
   - Klik "Create & Secure"
4. Masuk ke Notes List (ready to use!)

### Subsequent Runs

1. Splash screen
2. Authentication screen:
   - Biometric prompt muncul otomatis (jika enabled)
   - Atau masukkan password manual
3. Masuk ke Notes List

## 📖 Documentation

Dokumentasi lengkap tersedia di:

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Penjelasan arsitektur lengkap
- **[IMPLEMENTATION_SUMMARY.md](IMPLEMENTATION_SUMMARY.md)** - Summary implementasi
- **[DIAGRAMS.md](DIAGRAMS.md)** - Visual flow diagrams
- **[TESTING_GUIDE.md](TESTING_GUIDE.md)** - Panduan testing lengkap
- **[QUICK_REFERENCE.md](QUICK_REFERENCE.md)** - Quick reference untuk development
- **[usage_examples.dart](lib/examples/usage_examples.dart)** - Code examples

## 🧪 Testing

### Quick Test
```bash
flutter run
```

### Full Test Suite
```bash
flutter test
```

### Test Scenarios

1. **First Time User Flow**
   - Install → Onboarding → Setup Password → Notes List

2. **Returning User Flow**
   - Open App → Authentication → Notes List

3. **Biometric Authentication**
   - Auto-prompt → Authenticate → Access granted

4. **Password Authentication**
   - Enter password → Unlock → Access granted

5. **Note Operations**
   - Create note → Encrypted automatically
   - Read note → Decrypted automatically
   - Update/Delete → Works seamlessly

Lihat [TESTING_GUIDE.md](TESTING_GUIDE.md) untuk test cases lengkap.

## 🔐 Security Features

### Data Protection

1. **Password Security**
   - SHA-256 hashing dengan unique salt
   - Salt tersimpan di Secure Storage
   - Hash tersimpan di SQLite
   - Password asli tidak pernah disimpan

2. **Encryption Key Management**
   - AES-256 key generated once
   - Stored in OS Secure Storage (Keychain/Keystore)
   - Only accessible after authentication
   - Cleared from memory on logout

3. **Note Encryption**
   - AES-256-CBC encryption
   - Unique IV per encryption
   - Format: "IV:base64:encryptedtext"
   - Transparent to user

4. **Session Management**
   - Authentication required per session
   - Key loaded only when authenticated
   - Automatic logout on app close
   - Re-authentication on app reopen

### Threat Model

**Protected Against:**
- ✅ Unauthorized access (password/biometric required)
- ✅ Data breach (all notes encrypted)
- ✅ Password theft (stored as hash only)
- ✅ Key exposure (stored in secure storage)
- ✅ Plain text leakage (no sensitive data in plain text)

**Not Protected Against:**
- ⚠️ Device compromise (rooted/jailbroken)
- ⚠️ Physical access with device unlock
- ⚠️ Keyloggers (use built-in secure keyboard feature)
- ⚠️ Screen recording (use stealth mode feature)

## 📱 Platform Support

### Android
- ✅ API Level 23+ (Android 6.0+)
- ✅ Fingerprint sensor
- ✅ Face unlock (device dependent)
- ✅ Android Keystore
- ✅ SQLite support

### iOS
- ✅ iOS 12.0+
- ✅ Touch ID
- ✅ Face ID
- ✅ Keychain
- ✅ SQLite support

### Permissions

**Android (AndroidManifest.xml):**
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

**iOS (Info.plist):**
```xml
<key>NSFaceIDUsageDescription</key>
<string>We need Face ID to unlock your notes</string>
```

## 🎯 Usage Example

### Basic Usage

```dart
import 'package:chipernote/core/services/auth_service.dart';
import 'package:chipernote/core/services/notes_service.dart';

// Setup master password (first time)
await AuthService().setupMasterPassword(
  password: 'MySecurePassword123!',
  enableBiometric: true,
);

// Authenticate with password
bool authenticated = await AuthService().authenticateWithPassword(
  'MySecurePassword123!'
);

// Or authenticate with biometric
bool authenticated = await AuthService().authenticateWithBiometric();

// Create encrypted note
if (authenticated) {
  String? noteId = await NotesService().createNote(
    title: 'My Secret Note',
    content: 'This will be encrypted!',
  );
}

// Read encrypted notes
List<Map<String, dynamic>> notes = await NotesService().getAllNotes();
// Notes are automatically decrypted

// Logout
AuthService().logout();
```

Lihat [usage_examples.dart](lib/examples/usage_examples.dart) untuk contoh lengkap.

## 🛣️ Roadmap

### Current Version (1.0.0)
- [x] Master password authentication
- [x] Biometric authentication (fingerprint/face)
- [x] AES-256 note encryption
- [x] SQLite database
- [x] Onboarding flow
- [x] Beautiful dark UI
- [x] Persistent state

### Future Enhancements
- [ ] Password change functionality
- [ ] PIN code authentication
- [ ] Pattern lock authentication
- [ ] Note categories and folders
- [ ] Search and filter
- [ ] Note sharing with encryption
- [ ] Cloud backup (end-to-end encrypted)
- [ ] Export/import encrypted notes
- [ ] Auto-lock after inactivity
- [ ] Failed attempt counter
- [ ] Emergency recovery mechanism
- [ ] Secure keyboard integration
- [ ] Screenshot/screen recording protection

## 🤝 Contributing

Contributions are welcome! Silakan:

1. Fork repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)
- Email: your.email@example.com

## 🙏 Acknowledgments

- Flutter team untuk framework yang amazing
- Package maintainers (sqflite, local_auth, encrypt, dll)
- Community untuk inspiration dan support

## 📞 Support

Jika ada pertanyaan atau issue:
- Open an issue di GitHub
- Email ke: support@chipernote.app
- Join Discord: [link]

## ⭐ Show Your Support

Jika project ini helpful, berikan star di GitHub! ⭐

---

**Built with ❤️ using Flutter**

