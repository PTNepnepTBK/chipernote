# Panduan Troubleshooting Biometric

## Jika Biometric Tidak Berfungsi

### 1. Test Biometric di Device

Jalankan test screen untuk cek apakah device support biometric:

```dart
// Tambahkan di main.dart atau buat button untuk navigate ke:
import 'package:chipernote/test_biometric.dart';

// Navigate ke:
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => TestBiometricScreen()),
);
```

### 2. Checklist untuk Android

#### a. Permissions di AndroidManifest.xml
Pastikan ada permissions ini:
```xml
<uses-permission android:name="android.permission.USE_BIOMETRIC"/>
<uses-permission android:name="android.permission.USE_FINGERPRINT"/>
```

✅ **Sudah ada di file ini:**
`android/app/src/main/AndroidManifest.xml`

#### b. Device Requirements
- **Minimum API Level:** 23 (Android 6.0)
- **Fingerprint:** Device harus punya sensor fingerprint
- **Face Unlock:** Device harus support face unlock (tidak semua device)

#### c. Device Settings
1. Buka Settings → Security
2. Pastikan sudah setup fingerprint/face unlock
3. Test dengan unlock device pakai biometric
4. Jika device unlock berhasil, app juga harus bisa

#### d. Emulator Testing
Jika pakai emulator:
1. Extended Controls (... button)
2. Fingerprint
3. Touch the sensor
4. Atau gunakan command: `adb -e emu finger touch 1`

### 3. Checklist untuk iOS

#### a. Permissions di Info.plist
Pastikan ada ini:
```xml
<key>NSFaceIDUsageDescription</key>
<string>ChiperNote needs Face ID to unlock your encrypted notes</string>
```

✅ **Sudah ditambahkan di file ini:**
`ios/Runner/Info.plist`

#### b. Device Requirements
- **Face ID:** iPhone X atau lebih baru
- **Touch ID:** iPhone 5s sampai iPhone 8/8 Plus, iPad dengan Touch ID

#### c. Device Settings
1. Settings → Face ID & Passcode (atau Touch ID)
2. Pastikan sudah setup Face ID/Touch ID
3. Test dengan unlock device
4. Face ID harus bisa detect wajah

#### d. Simulator Testing
1. Face ID: Features → Face ID → Enrolled
2. Touch ID: Features → Touch ID → Enrolled
3. Test authentication: Matching Face/Touch

### 4. Debug dengan Logs

Buka terminal dan run:
```bash
flutter run
```

Lihat logs saat buka auth screen:
```
=== Biometric Status ===
Enabled in settings: true
Available on device: true
Type: Fingerprint
Auto-triggering biometric authentication...
Starting biometric authentication...
```

**Jika Available = false:**
- Device tidak support atau biometric belum di-setup
- Cek device settings

**Jika Available = true tapi prompt tidak muncul:**
- Cek permissions
- Restart app
- Clear app data

### 5. Error Codes & Solutions

#### NotAvailable
```
Biometric authentication error: NotAvailable
```
**Solusi:** Device tidak punya sensor biometric atau tidak support

#### NotEnrolled
```
Biometric authentication error: NotEnrolled
```
**Solusi:** User belum setup fingerprint/face di device settings

#### LockedOut
```
Biometric authentication error: LockedOut
```
**Solusi:** Terlalu banyak gagal attempts. Tunggu 30 detik atau restart device

#### PermanentlyLockedOut
```
Biometric authentication error: PermanentlyLockedOut
```
**Solusi:** Biometric disabled. User harus unlock device dengan PIN/password dulu

### 6. Testing Flow

#### Test 1: Fresh Install dengan Biometric
1. Install app
2. Buka app → Onboarding
3. Setup password screen → **Check biometric toggle**
   - Jika **enabled** → Device support biometric ✅
   - Jika **disabled** → Device tidak support ❌
4. Aktifkan toggle jika tersedia
5. Create password
6. Close app
7. Buka lagi → **Biometric prompt harus muncul**
8. Authenticate → Masuk ke notes ✅

#### Test 2: Password Fallback
1. Buka app
2. Biometric prompt muncul
3. **Cancel** prompt
4. Masukkan password manual
5. Unlock → Masuk ke notes ✅

#### Test 3: Wrong Biometric
1. Buka app
2. Biometric prompt muncul
3. Gunakan **wrong finger** atau **block face**
4. Authentication failed
5. Try again atau use password ✅

### 7. Common Issues

#### Issue: Biometric toggle selalu disabled
**Penyebab:** Device tidak support atau belum setup
**Solusi:**
1. Cek device settings → Setup fingerprint/face
2. Test unlock device dengan biometric
3. Jika device unlock tidak bisa, app juga tidak bisa

#### Issue: Prompt muncul tapi tidak detect
**Penyebab:** Sensor kotor atau tidak responsive
**Solusi:**
1. Bersihkan sensor fingerprint
2. Re-register fingerprint di device settings
3. Test dengan app lain yang pakai biometric

#### Issue: Biometric berhasil tapi app tidak unlock
**Penyebab:** Authentication callback tidak handle dengan benar
**Solusi:** Cek logs, seharusnya ada:
```
Biometric auth successful! Navigating to notes...
```

#### Issue: Auto-trigger tidak jalan
**Penyebab:** Biometric enabled di database tapi tidak auto-trigger
**Solusi:**
1. Pastikan `biometric_enabled = 1` di SQLite
2. Cek logs:
```
Auto-triggering biometric authentication...
```
3. Jika tidak ada, berarti tidak ter-trigger

### 8. Force Enable Biometric (untuk Testing)

Jika ingin force enable untuk testing:

```dart
// Di auth_screen.dart, uncomment ini:
Future<void> _checkBiometricStatus() async {
  final enabled = await _authService.isBiometricEnabled();
  final available = await _authService.isBiometricAvailable();
  
  // FORCE ENABLE untuk testing
  // setState(() {
  //   _biometricEnabled = true;
  //   _biometricAvailable = true;
  // });
  
  if (_biometricEnabled && _biometricAvailable) {
    _authenticateWithBiometric();
  }
}
```

### 9. Platform-Specific Commands

#### Android - Check if fingerprint enrolled:
```bash
adb shell settings get secure lock_screen_enabled
# 1 = enabled, 0 = disabled
```

#### Android - Simulate fingerprint touch (Emulator):
```bash
adb -e emu finger touch 1
```

#### iOS - Simulator face enrolled:
```bash
# In simulator: Features → Face ID → Enrolled
```

### 10. Quick Test Script

Buat test button di splash screen (temporary untuk testing):

```dart
// Di splash_screen.dart, tambahkan button:
FloatingActionButton(
  onPressed: () async {
    final auth = LocalAuthentication();
    final available = await auth.canCheckBiometrics;
    final types = await auth.getAvailableBiometrics();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Biometric Status'),
        content: Text('Available: $available\nTypes: $types'),
        actions: [
          TextButton(
            onPressed: () async {
              final result = await auth.authenticate(
                localizedReason: 'Test',
              );
              print('Result: $result');
            },
            child: Text('Test Auth'),
          ),
        ],
      ),
    );
  },
  child: Icon(Icons.fingerprint),
)
```

### 11. Verifikasi Instalasi

Pastikan dependencies terinstall:
```bash
flutter clean
flutter pub get
flutter run
```

Cek versi package:
```yaml
dependencies:
  local_auth: ^2.3.0
```

### 12. Contact Support

Jika masih tidak bisa:
1. Share logs dari console
2. Share device info (model, OS version)
3. Share screenshot error
4. Test dengan test_biometric.dart screen

---

## Summary Checklist

- [ ] Permissions added (AndroidManifest.xml & Info.plist)
- [ ] Device has biometric sensor
- [ ] Biometric enrolled in device settings
- [ ] App dapat detect biometric (toggle enabled)
- [ ] Biometric prompt muncul saat buka app
- [ ] Authentication berhasil → unlock app
- [ ] Fallback ke password works
- [ ] Logs menunjukkan "Available: true"

**Jika semua checklist ✅ tapi masih tidak work:**
Run `test_biometric.dart` dan share hasil log-nya!
