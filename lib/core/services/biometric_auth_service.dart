import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

/// Service for handling biometric authentication (fingerprint, Face ID, etc.)
/// Provides a way to access the encryption key without typing the master password
class BiometricAuthService {
  static final BiometricAuthService _instance = BiometricAuthService._internal();
  factory BiometricAuthService() => _instance;
  BiometricAuthService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();

  /// Check if the device supports biometric authentication
  Future<bool> isBiometricAvailable() async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();
      return canCheckBiometrics && isDeviceSupported;
    } on PlatformException {
      return false;
    }
  }

  /// Get available biometric types (fingerprint, face, iris)
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } on PlatformException {
      return [];
    }
  }

  /// Check if device has fingerprint sensor
  Future<bool> hasFingerprint() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.fingerprint);
  }

  /// Check if device has face recognition
  Future<bool> hasFaceRecognition() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.contains(BiometricType.face);
  }

  /// Authenticate using biometrics
  /// This is one of the MULTIPLE ways to access the encryption key
  Future<bool> authenticate({
    String localizedReason = 'Please authenticate to access your notes',
    bool useErrorDialogs = true,
    bool stickyAuth = true,
  }) async {
    try {
      // First check if biometric is available
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        print('Biometric not available on this device');
        return false;
      }

      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          useErrorDialogs: useErrorDialogs,
          stickyAuth: stickyAuth,
          biometricOnly: false, // Allow both biometric and device credentials
        ),
      );
      return didAuthenticate;
    } on PlatformException catch (e) {
      print('Biometric authentication error: ${e.code} - ${e.message}');
      
      // Handle specific errors
      if (e.code == 'NotAvailable' || e.code == 'NotEnrolled') {
        print('Biometric not set up on device');
      } else if (e.code == 'LockedOut') {
        print('Too many failed attempts. Device locked.');
      } else if (e.code == 'PermanentlyLockedOut') {
        print('Biometric authentication disabled. Use password.');
      }
      
      return false;
    } catch (e) {
      print('Unexpected error during biometric auth: $e');
      return false;
    }
  }

  /// Get biometric type name for display
  Future<String> getBiometricTypeName() async {
    final biometrics = await getAvailableBiometrics();
    
    if (biometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (biometrics.contains(BiometricType.fingerprint)) {
      return 'Fingerprint';
    } else if (biometrics.contains(BiometricType.iris)) {
      return 'Iris';
    } else if (biometrics.contains(BiometricType.strong)) {
      return 'Biometric';
    }
    
    return 'Biometric Authentication';
  }

  /// Stop authentication (if in progress)
  Future<void> stopAuthentication() async {
    try {
      await _localAuth.stopAuthentication();
    } catch (e) {
      print('Error stopping authentication: $e');
    }
  }
}
