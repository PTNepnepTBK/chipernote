import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

/// Simple test screen untuk debug biometric
class TestBiometricScreen extends StatefulWidget {
  const TestBiometricScreen({Key? key}) : super(key: key);

  @override
  State<TestBiometricScreen> createState() => _TestBiometricScreenState();
}

class _TestBiometricScreenState extends State<TestBiometricScreen> {
  final LocalAuthentication _auth = LocalAuthentication();
  String _status = 'Checking...';
  List<String> _logs = [];

  @override
  void initState() {
    super.initState();
    _checkBiometric();
  }

  void _addLog(String message) {
    setState(() {
      _logs.add('${DateTime.now().toString().substring(11, 19)} - $message');
    });
    print(message);
  }

  Future<void> _checkBiometric() async {
    try {
      _addLog('=== Checking Biometric Support ===');

      // Check if device supports biometric
      final bool canCheckBiometrics = await _auth.canCheckBiometrics;
      _addLog('Can check biometrics: $canCheckBiometrics');

      final bool isDeviceSupported = await _auth.isDeviceSupported();
      _addLog('Device supported: $isDeviceSupported');

      // Get available biometrics
      List<BiometricType> availableBiometrics = [];
      try {
        availableBiometrics = await _auth.getAvailableBiometrics();
        _addLog('Available biometrics: ${availableBiometrics.length}');
        for (var type in availableBiometrics) {
          _addLog('  - ${type.toString()}');
        }
      } catch (e) {
        _addLog('Error getting biometrics: $e');
      }

      setState(() {
        if (canCheckBiometrics && isDeviceSupported) {
          if (availableBiometrics.isEmpty) {
            _status = '⚠️ Device supports biometric but none enrolled';
          } else {
            _status = '✅ Biometric available: ${availableBiometrics.map((e) => e.name).join(", ")}';
          }
        } else {
          _status = '❌ Biometric not supported on this device';
        }
      });
    } catch (e) {
      _addLog('Error checking biometric: $e');
      setState(() {
        _status = '❌ Error: $e';
      });
    }
  }

  Future<void> _testAuthenticate() async {
    _addLog('=== Testing Authentication ===');
    setState(() {
      _status = 'Authenticating...';
    });

    try {
      final bool authenticated = await _auth.authenticate(
        localizedReason: 'Test biometric authentication',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      _addLog('Authentication result: $authenticated');
      setState(() {
        _status = authenticated ? '✅ Authentication SUCCESS!' : '❌ Authentication FAILED';
      });
    } on PlatformException catch (e) {
      _addLog('Platform Exception: ${e.code} - ${e.message}');
      setState(() {
        _status = '❌ Error: ${e.code}';
      });
    } catch (e) {
      _addLog('Error: $e');
      setState(() {
        _status = '❌ Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Biometric'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              color: Colors.deepPurple.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Biometric Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _status,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Buttons
            ElevatedButton.icon(
              onPressed: _checkBiometric,
              icon: const Icon(Icons.refresh),
              label: const Text('Re-check Biometric'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _testAuthenticate,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Test Authentication'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 16),

            // Logs
            const Text(
              'Logs:',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: _logs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        _logs[index],
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
