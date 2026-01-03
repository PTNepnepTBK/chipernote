# Testing Guide - ChiperNote

## Prerequisites

Sebelum testing, pastikan:
- ✅ Flutter SDK terinstall
- ✅ Device/Emulator dengan biometric support (untuk test fitur biometric)
- ✅ Android Studio / VS Code
- ✅ Dependencies sudah di-install (`flutter pub get`)

## Quick Start Testing

### 1. Clean Install Test

```bash
# Dari terminal, jalankan:
cd d:\Flutter\project_flutter\chipernote
flutter clean
flutter pub get
flutter run
```

**Expected behavior:**
1. Splash screen muncul (dengan animasi lock icon)
2. Setelah 2-3 detik, onboarding screen muncul (3 halaman)
3. Geser sampai halaman terakhir, klik "Get Started"
4. Setup Password screen muncul
5. Buat password (min 8 karakter)
6. Toggle biometric jika tersedia
7. Klik "Create & Secure"
8. Masuk ke Notes List screen

### 2. Returning User Test (With Biometric)

```bash
# Setelah clean install test, tutup app dan buka lagi:
# Cara 1: Stop di IDE dan run lagi
# Cara 2: Close app dan buka dari launcher
```

**Expected behavior:**
1. Splash screen muncul
2. Langsung ke Authentication screen (skip onboarding)
3. Biometric prompt muncul otomatis
4. Authenticate dengan fingerprint/face
5. Masuk ke Notes List

### 3. Returning User Test (With Password)

**Expected behavior:**
1. Splash screen muncul
2. Authentication screen muncul
3. Cancel biometric prompt (atau biarkan timeout)
4. Masukkan password yang dibuat tadi
5. Klik "Unlock"
6. Masuk ke Notes List

## Detailed Test Cases

### Test Case 1: First Time Setup
**Objective:** Verify onboarding and password setup works correctly

**Steps:**
1. Uninstall app (jika sudah terinstall)
2. Install fresh dan jalankan
3. Lihat splash screen (2-3 detik)
4. Onboarding screen 1 muncul (Bank-Grade Encryption)
5. Swipe ke kanan → Screen 2 (Secure Keyboard)
6. Swipe ke kanan → Screen 3 (Stealth Mode)
7. Klik "Get Started"
8. Setup Password screen muncul
9. Masukkan password: `Test1234!`
10. Confirm password: `Test1234!`
11. Aktifkan biometric toggle (jika tersedia)
12. Klik "Create & Secure"

**Expected Results:**
- ✅ Semua screens muncul sesuai urutan
- ✅ Password validation bekerja (min 8 char, dll)
- ✅ Password strength indicator berubah warna
- ✅ Requirements list update secara real-time
- ✅ Biometric toggle disabled jika device tidak support
- ✅ Success masuk ke Notes List

**Verification in Database:**
```dart
// Bisa cek dengan tools atau debug:
// SQLite: app_settings.onboarding_completed = 'true'
// SQLite: user_auth table ada 1 row
// Secure Storage: encryption_key exists
```

---

### Test Case 2: Password Authentication
**Objective:** Verify password authentication works

**Steps:**
1. App sudah setup (dari Test Case 1)
2. Close app sepenuhnya
3. Buka app lagi
4. Tunggu splash screen
5. Authentication screen muncul
6. Biometric prompt muncul → Cancel/Skip
7. Masukkan password: `Test1234!`
8. Klik "Unlock"

**Expected Results:**
- ✅ Authentication screen muncul (tidak onboarding lagi)
- ✅ Password field visible
- ✅ Password bisa di-hide/show dengan icon
- ✅ Correct password → Masuk ke Notes List
- ✅ Wrong password → Error message muncul
- ✅ Password field shake animation saat error

**Test Wrong Password:**
1. Masukkan password salah: `WrongPass123`
2. Klik "Unlock"
3. Error message muncul: "Incorrect password"
4. Field ter-shake (animation)
5. Password ter-clear
6. Masukkan password benar
7. Success masuk

---

### Test Case 3: Biometric Authentication
**Objective:** Verify biometric works (Fingerprint/Face ID)

**Prerequisites:**
- Device/Emulator dengan biometric support
- Biometric sudah diaktifkan saat setup

**Steps:**
1. App sudah setup dengan biometric enabled
2. Close app
3. Buka app lagi
4. Splash screen
5. Authentication screen
6. Biometric prompt muncul otomatis (dalam 0.5 detik)
7. Authenticate dengan fingerprint/face

**Expected Results:**
- ✅ Biometric prompt muncul otomatis
- ✅ Prompt menampilkan text: "Authenticate to access ChiperNote"
- ✅ Success biometric → Langsung masuk Notes List
- ✅ Failed biometric → Tetap di auth screen, bisa retry atau pakai password
- ✅ Cancel biometric → Tetap di auth screen, bisa pakai password

**Test Biometric Button:**
1. Cancel prompt pertama
2. Klik button "Use Fingerprint" (atau "Use Face ID")
3. Biometric prompt muncul lagi
4. Authenticate
5. Success masuk

---

### Test Case 4: Biometric Not Available
**Objective:** Verify app works on device without biometric

**Setup:**
- Emulator tanpa biometric support
- Atau device biometric disabled di settings

**Steps:**
1. Fresh install
2. Setup password screen
3. Lihat biometric toggle

**Expected Results:**
- ✅ Biometric toggle disabled (greyed out)
- ✅ Text: "Not available on this device"
- ✅ Icon abu-abu (tidak colored)
- ✅ Toggle tidak bisa diklik
- ✅ Setup password tetap success tanpa biometric

---

### Test Case 5: Create Note (Encryption Test)
**Objective:** Verify note encryption works

**Steps:**
1. Login ke app (password atau biometric)
2. Di Notes List, klik FAB (+)
3. Note editor screen muncul
4. Masukkan title: "Secret Note"
5. Masukkan content: "This is my secret content that should be encrypted"
6. Save note
7. Back ke Notes List
8. Note muncul di list

**Expected Results:**
- ✅ Note ter-save
- ✅ Title terlihat di list
- ✅ Preview content terlihat

**Verification (Advanced):**
```dart
// Cek di SQLite database (via tools):
// notes.encrypted_data = "IV:base64:encryptedtext" format
// Content TIDAK plain text
// Hanya bisa dibaca setelah decrypt dengan key
```

---

### Test Case 6: Read Note (Decryption Test)
**Objective:** Verify note decryption works

**Steps:**
1. Buat note (dari Test Case 5)
2. Logout dari app
3. Close app
4. Buka app lagi
5. Login (password/biometric)
6. Buka note yang tadi dibuat
7. Lihat content

**Expected Results:**
- ✅ Note content muncul dengan benar
- ✅ Content sama dengan yang ditulis
- ✅ Tidak ada error/gibberish
- ✅ Decryption seamless (user tidak notice)

---

### Test Case 7: Persistent State Test
**Objective:** Verify data persists across app restarts

**Steps:**
1. Setup app dengan password
2. Create 3 notes
3. Close app
4. Reopen dan login
5. Verify 3 notes masih ada
6. Close app lagi
7. Reopen dan login
8. Verify 3 notes masih ada

**Expected Results:**
- ✅ Semua notes persist
- ✅ Content tetap bisa dibaca
- ✅ Onboarding tidak muncul lagi
- ✅ Authentication state correct

---

### Test Case 8: Enable Biometric After Setup
**Objective:** Verify biometric bisa diaktifkan kemudian

**Steps:**
1. Setup app tanpa biometric
2. Login dengan password
3. Go to settings (jika ada)
4. Enable biometric
5. Logout
6. Login lagi → Biometric should work

**Expected Results:**
- ✅ Biometric prompt muncul
- ✅ Authentication works
- ✅ Setting tersimpan di database

---

### Test Case 9: Security - Logout Test
**Objective:** Verify logout clears encryption key

**Steps:**
1. Login ke app
2. Buat/buka note (works)
3. Logout
4. Try to access notes service directly (dev test)

**Expected Results:**
- ✅ After logout, encryption key cleared from memory
- ✅ AuthService.isAuthenticated = false
- ✅ Cannot decrypt notes without re-authentication

---

### Test Case 10: Edge Cases

#### Test 10a: Empty Password
1. Setup screen
2. Don't enter password
3. Click "Create & Secure"
4. **Expected:** Error message "Please enter a password"

#### Test 10b: Short Password
1. Setup screen
2. Enter password: `123`
3. **Expected:** Error "Password must be at least 8 characters"

#### Test 10c: Password Mismatch
1. Setup screen
2. Password: `Test1234!`
3. Confirm: `Test5678!`
4. **Expected:** Error "Passwords do not match"

#### Test 10d: Cancel Biometric Multiple Times
1. Open app (biometric enabled)
2. Cancel biometric prompt
3. Biometric prompt muncul lagi
4. Cancel lagi
5. **Expected:** User bisa input password manual

---

## Performance Testing

### Test P1: App Startup Time
**Steps:**
1. Close app completely
2. Start stopwatch
3. Open app
4. Stop when authentication screen visible

**Expected:** < 3 seconds

### Test P2: Authentication Response Time
**Steps:**
1. Auth screen visible
2. Start stopwatch
3. Enter correct password
4. Click unlock
5. Stop when notes list visible

**Expected:** < 2 seconds

### Test P3: Note Creation Time
**Steps:**
1. Notes list
2. Start stopwatch
3. Create note with 1000 characters
4. Save
5. Stop when back to list

**Expected:** < 1 second

---

## Database Verification

### Manual Database Check

**Android:**
```bash
# Connect to device
adb shell

# Navigate to app data
cd /data/data/com.example.chipernote/databases/

# Open database
sqlite3 chipernote.db

# Check tables
.tables

# Check onboarding status
SELECT * FROM app_settings WHERE key='onboarding_completed';

# Check if password set
SELECT id, biometric_enabled FROM user_auth;

# Check notes (will be encrypted)
SELECT id, title FROM notes;

# Exit
.exit
```

**Expected Results:**
- Database exists
- Tables created (app_settings, user_auth, notes)
- Data populated correctly

---

## Security Verification

### Check 1: Password Not Stored Plain Text
```sql
-- In database:
SELECT master_password_hash FROM user_auth;
-- Should be long hash string, NOT plain password
```

### Check 2: Encryption Key Not in Database
```sql
-- Search all tables:
SELECT * FROM app_settings WHERE key='encryption_key';
-- Should return NO results (key is in Secure Storage, not DB)
```

### Check 3: Notes Are Encrypted
```sql
SELECT encrypted_data FROM notes LIMIT 1;
-- Should show: "IV:base64string:encryptedbase64string"
-- NOT plain text content
```

---

## Common Issues & Solutions

### Issue 1: Biometric Prompt Not Appearing
**Symptoms:** Auth screen shows but no biometric prompt
**Solutions:**
- Check device has biometric enrolled
- Check permission granted in AndroidManifest.xml
- Check biometric_enabled in database
- Try manual button "Use Fingerprint"

### Issue 2: "Incorrect Password" on Correct Password
**Symptoms:** Entering correct password shows error
**Solutions:**
- Check if salt stored correctly
- Verify password hash matches
- Clear app data and setup again

### Issue 3: Notes Show Gibberish
**Symptoms:** Note content shows random characters
**Solutions:**
- Check encryption key loaded
- Verify authenticated before decrypt
- Check IV format correct

### Issue 4: Onboarding Shows Every Time
**Symptoms:** Onboarding screens keep appearing
**Solutions:**
- Check onboarding_completed in database
- Verify database write permissions
- Check DatabaseService initialization

---

## Automated Testing (Optional)

### Unit Tests Example

```dart
// test/services/auth_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:chipernote/core/services/auth_service.dart';

void main() {
  group('AuthService Tests', () {
    test('Should hash password correctly', () {
      // Test implementation
    });

    test('Should verify correct password', () {
      // Test implementation
    });

    test('Should reject incorrect password', () {
      // Test implementation
    });
  });
}
```

Run tests:
```bash
flutter test
```

---

## Test Checklist

### Initial Setup ✓
- [ ] Fresh install works
- [ ] Onboarding appears (first time only)
- [ ] Password setup successful
- [ ] Biometric toggle works correctly
- [ ] Database initialized

### Authentication ✓
- [ ] Password authentication works
- [ ] Wrong password shows error
- [ ] Biometric authentication works
- [ ] Biometric fallback to password
- [ ] Authentication persists session

### Note Management ✓
- [ ] Create note (encryption works)
- [ ] Read note (decryption works)
- [ ] Update note
- [ ] Delete note
- [ ] Notes persist across restarts

### Security ✓
- [ ] Password hashed, not plain text
- [ ] Encryption key in secure storage
- [ ] Notes encrypted in database
- [ ] Logout clears encryption key
- [ ] No unauthorized access

### Edge Cases ✓
- [ ] Empty password rejected
- [ ] Short password rejected
- [ ] Password mismatch detected
- [ ] Biometric not available handled
- [ ] Multiple auth attempts work

### Performance ✓
- [ ] App starts quickly (< 3s)
- [ ] Authentication fast (< 2s)
- [ ] Note operations smooth
- [ ] No lag or freeze

---

## Success Criteria

✅ **PASSED** if:
- All test cases pass
- No crashes or errors
- Encryption/decryption transparent to user
- Authentication methods both work
- Data persists correctly
- Security verified

❌ **FAILED** if:
- Any test case fails
- App crashes
- Notes show gibberish
- Authentication doesn't work
- Data lost on restart
- Security compromised

---

## Next Steps After Testing

1. **If all tests pass:**
   - ✅ App ready for further development
   - ✅ Add more features (categories, search, etc)
   - ✅ Improve UI/UX
   - ✅ Add cloud sync (optional)

2. **If issues found:**
   - 🔧 Debug and fix issues
   - 🔧 Re-run tests
   - 🔧 Verify fixes work

3. **Production readiness:**
   - 📝 Add error logging
   - 📝 Add analytics (privacy-safe)
   - 📝 Add backup/export feature
   - 📝 Add recovery mechanism
   - 📝 Security audit

---

**Happy Testing! 🧪🔐**
