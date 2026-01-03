import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Service for managing secure storage using Flutter Secure Storage
/// This stores the encryption key that will be used to encrypt/decrypt notes
/// The encryption key is ONE, but can be accessed through MULTIPLE ways:
/// 1. Master password verification
/// 2. Biometric authentication (if enabled)
class SecureStorageService {
  static final SecureStorageService _instance = SecureStorageService._internal();
  factory SecureStorageService() => _instance;
  SecureStorageService._internal();

  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: KeychainAccessibility.first_unlock,
    ),
  );

  static const String _encryptionKeyKey = 'encryption_key';
  static const String _saltKey = 'password_salt';

  /// Generate and store a new encryption key
  /// This key will be used to encrypt all notes
  Future<String> generateAndStoreEncryptionKey() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final random = List.generate(32, (i) => i * timestamp.hashCode);
    final key = base64Encode(utf8.encode(random.join()));
    
    await _storage.write(key: _encryptionKeyKey, value: key);
    return key;
  }

  /// Get the stored encryption key
  /// This is the ONE key used for all notes
  Future<String?> getEncryptionKey() async {
    return await _storage.read(key: _encryptionKeyKey);
  }

  /// Check if encryption key exists
  Future<bool> hasEncryptionKey() async {
    final key = await getEncryptionKey();
    return key != null && key.isNotEmpty;
  }

  /// Delete the encryption key (used when resetting the app)
  Future<void> deleteEncryptionKey() async {
    await _storage.delete(key: _encryptionKeyKey);
  }

  /// Generate a salt for password hashing
  Future<String> generateSalt() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final saltData = '$timestamp-chipernote-salt';
    return base64Encode(utf8.encode(saltData));
  }

  /// Store the salt
  Future<void> storeSalt(String salt) async {
    await _storage.write(key: _saltKey, value: salt);
  }

  /// Get the stored salt
  Future<String?> getSalt() async {
    return await _storage.read(key: _saltKey);
  }

  /// Hash password with salt
  String hashPassword(String password, String salt) {
    final combined = '$password$salt';
    final bytes = utf8.encode(combined);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  /// Verify password against stored hash
  Future<bool> verifyPassword(String password, String storedHash, String salt) async {
    final hash = hashPassword(password, salt);
    return hash == storedHash;
  }

  /// Clear all secure storage
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}
