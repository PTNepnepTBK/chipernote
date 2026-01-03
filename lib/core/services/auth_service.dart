import 'database_service.dart';
import 'secure_storage_service.dart';
import 'biometric_auth_service.dart';

/// Main authentication service that manages the ONE encryption key
/// with MULTIPLE access methods (password, biometric)
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  final DatabaseService _dbService = DatabaseService();
  final SecureStorageService _secureStorage = SecureStorageService();
  final BiometricAuthService _biometricService = BiometricAuthService();

  bool _isAuthenticated = false;
  String? _currentEncryptionKey;

  bool get isAuthenticated => _isAuthenticated;
  String? get encryptionKey => _currentEncryptionKey;

  /// Initialize authentication service
  Future<void> initialize() async {
    // Initialize state
    _isAuthenticated = false;
    _currentEncryptionKey = null;
  }

  /// Setup master password and create encryption key
  /// This creates the ONE encryption key that will be used for all notes
  Future<bool> setupMasterPassword({
    required String password,
    required bool enableBiometric,
  }) async {
    try {
      // Generate salt for password hashing
      final salt = await _secureStorage.generateSalt();
      await _secureStorage.storeSalt(salt);

      // Hash the password
      final passwordHash = _secureStorage.hashPassword(password, salt);

      // Generate and store the encryption key
      await _secureStorage.generateAndStoreEncryptionKey();

      // Save master password data to database
      await _dbService.saveMasterPassword(
        passwordHash: passwordHash,
        salt: salt,
        biometricEnabled: enableBiometric,
      );

      // If biometric is enabled, verify it's available
      if (enableBiometric) {
        final isAvailable = await _biometricService.isBiometricAvailable();
        if (!isAvailable) {
          await _dbService.updateBiometricEnabled(false);
        }
      }

      return true;
    } catch (e) {
      print('Error setting up master password: $e');
      return false;
    }
  }

  /// Authenticate with master password
  /// This is ONE way to access the encryption key
  Future<bool> authenticateWithPassword(String password) async {
    try {
      final authData = await _dbService.getMasterPasswordData();
      if (authData == null) return false;

      final storedHash = authData['master_password_hash'] as String;
      final salt = authData['salt'] as String;

      final isValid = await _secureStorage.verifyPassword(
        password,
        storedHash,
        salt,
      );

      if (isValid) {
        // Get the encryption key
        _currentEncryptionKey = await _secureStorage.getEncryptionKey();
        _isAuthenticated = true;
        return true;
      }

      return false;
    } catch (e) {
      print('Error authenticating with password: $e');
      return false;
    }
  }

  /// Authenticate with biometric
  /// This is ANOTHER way to access the SAME encryption key
  Future<bool> authenticateWithBiometric() async {
    try {
      final authData = await _dbService.getMasterPasswordData();
      if (authData == null) return false;

      final biometricEnabled = (authData['biometric_enabled'] as int) == 1;
      if (!biometricEnabled) return false;

      // Check if biometric is available
      final isAvailable = await _biometricService.isBiometricAvailable();
      if (!isAvailable) return false;

      // Authenticate with biometric
      final authenticated = await _biometricService.authenticate(
        localizedReason: 'Authenticate to access ChiperNote',
      );

      if (authenticated) {
        // Get the SAME encryption key
        _currentEncryptionKey = await _secureStorage.getEncryptionKey();
        _isAuthenticated = true;
        return true;
      }

      return false;
    } catch (e) {
      print('Error authenticating with biometric: $e');
      return false;
    }
  }

  /// Check if master password is set up
  Future<bool> hasMasterPassword() async {
    return await _dbService.hasMasterPassword();
  }

  /// Check if biometric authentication is enabled
  Future<bool> isBiometricEnabled() async {
    final authData = await _dbService.getMasterPasswordData();
    if (authData == null) return false;
    return (authData['biometric_enabled'] as int) == 1;
  }

  /// Check if biometric is available on device
  Future<bool> isBiometricAvailable() async {
    return await _biometricService.isBiometricAvailable();
  }

  /// Get biometric type name
  Future<String> getBiometricTypeName() async {
    return await _biometricService.getBiometricTypeName();
  }

  /// Enable/disable biometric authentication
  Future<bool> setBiometricEnabled(bool enabled) async {
    try {
      if (enabled) {
        // Verify biometric is available
        final isAvailable = await _biometricService.isBiometricAvailable();
        if (!isAvailable) return false;

        // Authenticate to enable
        final authenticated = await _biometricService.authenticate(
          localizedReason: 'Authenticate to enable biometric unlock',
        );
        if (!authenticated) return false;
      }

      await _dbService.updateBiometricEnabled(enabled);
      return true;
    } catch (e) {
      print('Error setting biometric enabled: $e');
      return false;
    }
  }

  /// Logout
  void logout() {
    _isAuthenticated = false;
    _currentEncryptionKey = null;
  }

  /// Reset all authentication data (for testing or app reset)
  Future<void> reset() async {
    await _secureStorage.clearAll();
    _isAuthenticated = false;
    _currentEncryptionKey = null;
  }
}
