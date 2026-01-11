/// USAGE EXAMPLES - How to use the ChiperNote services
/// 
/// This file demonstrates how to use the authentication and encryption
/// services with the ONE encryption key, MULTIPLE access methods concept.

import 'package:chipernote/core/services/auth_service.dart';
import 'package:chipernote/core/services/notes_service.dart';
import 'package:chipernote/core/services/database_service.dart';

/// Example 1: First-time setup - Create master password
Future<void> exampleSetupMasterPassword() async {
  final authService = AuthService();
  
  // Setup master password with biometric enabled
  bool success = await authService.setupMasterPassword(
    password: 'MySecurePassword123!',
    enableBiometric: true,
  );
  
  if (success) {
    print('Master password created successfully!');
    print('Encryption key generated and stored securely.');
  }
}

/// Example 2: Authenticate with password
Future<void> exampleAuthenticateWithPassword() async {
  final authService = AuthService();
  
  // Authenticate with master password
  bool authenticated = await authService.authenticateWithPassword('MySecurePassword123!');
  
  if (authenticated) {
    print('Authenticated successfully!');
    print('Encryption key is now accessible.');
    print('Can now create/read encrypted notes.');
  }
}

/// Example 3: Authenticate with biometric
Future<void> exampleAuthenticateWithBiometric() async {
  final authService = AuthService();
  
  // Check if biometric is available
  bool isAvailable = await authService.isBiometricAvailable();
  
  if (isAvailable) {
    // Authenticate with biometric
    bool authenticated = await authService.authenticateWithBiometric();
    
    if (authenticated) {
      print('Authenticated with biometric!');
      print('Same encryption key accessed through biometric.');
    }
  }
}

/// Example 4: Create an encrypted note
Future<void> exampleCreateNote() async {
  final authService = AuthService();
  final notesService = NotesService();
  
  // First, authenticate (either password or biometric)
  bool authenticated = await authService.authenticateWithPassword('MySecurePassword123!');
  
  if (authenticated) {
    // Now create a note (will be encrypted automatically)
    String? noteId = await notesService.createNote(
      title: 'My Secret Note',
      content: 'This is my secret content that will be encrypted!',
      color: '#FF5733',
      ispinned: false,
    );
    
    if (noteId != null) {
      print('Note created with ID: $noteId');
      print('Content encrypted with the ONE encryption key');
    }
  }
}

/// Example 5: Read encrypted notes
Future<void> exampleReadNotes() async {
  final authService = AuthService();
  final notesService = NotesService();
  
  // Authenticate first
  bool authenticated = await authService.authenticateWithPassword('MySecurePassword123!');
  
  if (authenticated) {
    // Get all notes (will be decrypted automatically)
    List<Map<String, dynamic>> notes = await notesService.getAllNotes();
    
    for (var note in notes) {
      print('Note: ${note['title']}');
      print('Content: ${note['content']}');
      print('Created: ${note['created_at']}');
      print('---');
    }
  }
}

/// Example 6: Check app state
Future<void> exampleCheckAppState() async {
  final dbService = DatabaseService();
  final authService = AuthService();
  
  // Check if onboarding completed
  bool hasOnboarded = await dbService.hasCompletedOnboarding();
  print('Onboarding completed: $hasOnboarded');
  
  // Check if master password exists
  bool hasPassword = await authService.hasMasterPassword();
  print('Master password set: $hasPassword');
  
  // Check if biometric is enabled
  bool biometricEnabled = await authService.isBiometricEnabled();
  print('Biometric enabled: $biometricEnabled');
  
  // Check if authenticated
  bool isAuthenticated = authService.isAuthenticated;
  print('Currently authenticated: $isAuthenticated');
}

/// Example 7: Update a note
Future<void> exampleUpdateNote(String noteId) async {
  final notesService = NotesService();
  
  // Update note (must be authenticated)
  bool success = await notesService.updateNote(
    id: noteId,
    title: 'Updated Title',
    content: 'Updated content - still encrypted!',
  );
  
  if (success) {
    print('Note updated successfully');
  }
}

/// Example 8: Delete a note
Future<void> exampleDeleteNote(String noteId) async {
  final notesService = NotesService();
  
  bool success = await notesService.deleteNote(noteId);
  
  if (success) {
    print('Note deleted successfully');
  }
}

/// Example 9: Toggle biometric authentication
Future<void> exampleToggleBiometric(bool enable) async {
  final authService = AuthService();
  
  bool success = await authService.setBiometricEnabled(enable);
  
  if (success) {
    print('Biometric ${enable ? 'enabled' : 'disabled'} successfully');
  }
}

/// Example 10: Logout
Future<void> exampleLogout() async {
  final authService = AuthService();
  
  // Clear encryption key from memory
  authService.logout();
  
  print('Logged out. Encryption key cleared from memory.');
  print('User must authenticate again to access notes.');
}

/// COMPLETE FLOW EXAMPLE
Future<void> completeFlowExample() async {
  final authService = AuthService();
  final notesService = NotesService();
  final dbService = DatabaseService();
  
  // 1. Check if first time user
  bool hasOnboarded = await dbService.hasCompletedOnboarding();
  
  if (!hasOnboarded) {
    print('=== FIRST TIME USER ===');
    
    // User goes through onboarding
    await dbService.setOnboardingCompleted();
    
    // User creates master password
    await authService.setupMasterPassword(
      password: 'MySecurePassword123!',
      enableBiometric: true,
    );
    
    print('✓ Account setup completed');
  } else {
    print('=== RETURNING USER ===');
    
    // Option 1: Authenticate with password
    bool authWithPassword = await authService.authenticateWithPassword('MySecurePassword123!');
    
    if (!authWithPassword) {
      // Option 2: Try biometric if password failed or user prefers it
      bool authWithBiometric = await authService.authenticateWithBiometric();
      
      if (!authWithBiometric) {
        print('❌ Authentication failed');
        return;
      }
    }
    
    print('✓ Authenticated successfully');
  }
  
  // 2. User is now authenticated - can work with notes
  
  // Create a note
  String? noteId = await notesService.createNote(
    title: 'My First Note',
    content: 'This is encrypted content',
  );
  
  if (noteId != null) {
    print('✓ Note created: $noteId');
    
    // Read the note
    var note = await notesService.getNoteById(noteId);
    print('✓ Note content: ${note?['content']}');
    
    // Update the note
    await notesService.updateNote(
      id: noteId,
      title: 'Updated Note',
      content: 'Updated encrypted content',
    );
    print('✓ Note updated');
  }
  
  // 3. Get all notes
  var allNotes = await notesService.getAllNotes();
  print('✓ Total notes: ${allNotes.length}');
  
  // 4. Logout
  authService.logout();
  print('✓ Logged out');
}

/// KEY POINTS:
/// 
/// 1. ONE Encryption Key:
///    - Generated once during master password setup
///    - Stored securely in Flutter Secure Storage
///    - Used to encrypt ALL notes
/// 
/// 2. MULTIPLE Access Methods:
///    - Password: User enters master password
///    - Biometric: User uses fingerprint/face
///    - Both methods access the SAME encryption key
/// 
/// 3. Security Flow:
///    - User authenticates → Encryption key loaded → Can access notes
///    - User logs out → Encryption key cleared → Cannot access notes
/// 
/// 4. Persistence:
///    - Onboarding status stored in SQLite
///    - Master password hash stored in SQLite
///    - Encryption key stored in Secure Storage
///    - Encrypted notes stored in SQLite
