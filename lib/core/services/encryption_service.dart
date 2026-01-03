import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'auth_service.dart';

/// Service for encrypting and decrypting notes
/// Uses the ONE encryption key that can be accessed through MULTIPLE ways
class EncryptionService {
  static final EncryptionService _instance = EncryptionService._internal();
  factory EncryptionService() => _instance;
  EncryptionService._internal();

  final AuthService _authService = AuthService();

  /// Encrypt note content
  Future<String> encryptNote(String plainText) async {
    final encryptionKey = _authService.encryptionKey;
    
    if (encryptionKey == null || !_authService.isAuthenticated) {
      throw Exception('Not authenticated. Cannot encrypt note.');
    }

    // Generate key from stored encryption key
    final key = encrypt_lib.Key.fromUtf8(_padKey(encryptionKey));
    final iv = encrypt_lib.IV.fromLength(16);
    
    final encrypter = encrypt_lib.Encrypter(
      encrypt_lib.AES(key, mode: encrypt_lib.AESMode.cbc),
    );

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    
    // Combine IV and encrypted data
    final combined = '${iv.base64}:${encrypted.base64}';
    return combined;
  }

  /// Decrypt note content
  Future<String> decryptNote(String encryptedText) async {
    final encryptionKey = _authService.encryptionKey;
    
    if (encryptionKey == null || !_authService.isAuthenticated) {
      throw Exception('Not authenticated. Cannot decrypt note.');
    }

    try {
      // Split IV and encrypted data
      final parts = encryptedText.split(':');
      if (parts.length != 2) {
        throw Exception('Invalid encrypted data format');
      }

      final iv = encrypt_lib.IV.fromBase64(parts[0]);
      final encrypted = encrypt_lib.Encrypted.fromBase64(parts[1]);

      // Generate key from stored encryption key
      final key = encrypt_lib.Key.fromUtf8(_padKey(encryptionKey));
      
      final encrypter = encrypt_lib.Encrypter(
        encrypt_lib.AES(key, mode: encrypt_lib.AESMode.cbc),
      );

      final decrypted = encrypter.decrypt(encrypted, iv: iv);
      return decrypted;
    } catch (e) {
      throw Exception('Failed to decrypt note: $e');
    }
  }

  /// Pad or truncate key to 32 characters (256 bits)
  String _padKey(String key) {
    if (key.length >= 32) {
      return key.substring(0, 32);
    }
    return key.padRight(32, '0');
  }

  /// Check if service is ready to encrypt/decrypt
  bool isReady() {
    return _authService.isAuthenticated && _authService.encryptionKey != null;
  }
}
