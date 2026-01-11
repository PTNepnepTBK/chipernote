import 'package:uuid/uuid.dart';
import 'database_service.dart';
import 'encryption_service.dart';
import 'auth_service.dart';

/// Service for managing notes with encryption
/// Demonstrates the ONE encryption key, MULTIPLE access methods concept
class NotesService {
  static final NotesService _instance = NotesService._internal();
  factory NotesService() => _instance;
  NotesService._internal();

  final DatabaseService _dbService = DatabaseService();
  final EncryptionService _encryptionService = EncryptionService();
  final AuthService _authService = AuthService();
  final Uuid _uuid = const Uuid();

  /// Create a new note
  /// The note content will be encrypted using the ONE encryption key
  /// that was accessed either via password or biometric
  Future<String?> createNote({
    required String title,
    required String content,
    String? color,
    bool ispinned = false,
  }) async {
    if (!_authService.isAuthenticated) {
      throw Exception('Not authenticated. Please unlock the app first.');
    }

    if (!_encryptionService.isReady()) {
      throw Exception('Encryption service not ready.');
    }

    try {
      final noteId = _uuid.v4();
      
      // Encrypt the note content using the ONE encryption key
      final encryptedContent = await _encryptionService.encryptNote(content);
      
      // Store encrypted note in database
      await _dbService.saveNote(
        id: noteId,
        title: title,
        content: content.substring(0, content.length > 100 ? 100 : content.length), // Preview
        encryptedData: encryptedContent,
        color: color,
        ispinned: ispinned,
      );

      return noteId;
    } catch (e) {
      print('Error creating note: $e');
      return null;
    }
  }

  /// Get all notes
  /// Notes will be decrypted using the ONE encryption key
  /// that was accessed either via password or biometric
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    if (!_authService.isAuthenticated) {
      throw Exception('Not authenticated. Please unlock the app first.');
    }

    try {
      final encryptedNotes = await _dbService.getAllNotes();
      final decryptedNotes = <Map<String, dynamic>>[];

      for (var note in encryptedNotes) {
        try {
          final encryptedData = note['encrypted_data'] as String;
          final decryptedContent = await _encryptionService.decryptNote(encryptedData);
          
          decryptedNotes.add({
            'id': note['id'],
            'title': note['title'],
            'content': decryptedContent,
            'created_at': note['created_at'],
            'updated_at': note['updated_at'],
            'is_pinned': note['is_pinned'] == 1,
            'color': note['color'],
          });
        } catch (e) {
          print('Error decrypting note ${note['id']}: $e');
        }
      }

      return decryptedNotes;
    } catch (e) {
      print('Error getting notes: $e');
      return [];
    }
  }

  /// Get a single note by ID
  Future<Map<String, dynamic>?> getNoteById(String id) async {
    if (!_authService.isAuthenticated) {
      throw Exception('Not authenticated. Please unlock the app first.');
    }

    try {
      final note = await _dbService.getNoteById(id);
      if (note == null) return null;

      final encryptedData = note['encrypted_data'] as String;
      final decryptedContent = await _encryptionService.decryptNote(encryptedData);
      
      return {
        'id': note['id'],
        'title': note['title'],
        'content': decryptedContent,
        'created_at': note['created_at'],
        'updated_at': note['updated_at'],
        'is_pinned': note['is_pinned'] == 1,
        'color': note['color'],
      };
    } catch (e) {
      print('Error getting note: $e');
      return null;
    }
  }

  /// Update an existing note
  Future<bool> updateNote({
    required String id,
    required String title,
    required String content,
    String? color,
    bool? ispinned,
  }) async {
    if (!_authService.isAuthenticated) {
      throw Exception('Not authenticated. Please unlock the app first.');
    }

    try {
      // Get existing note
      final existingNote = await _dbService.getNoteById(id);
      if (existingNote == null) return false;

      // Encrypt the new content
      final encryptedContent = await _encryptionService.encryptNote(content);
      
      // Update note in database
      await _dbService.saveNote(
        id: id,
        title: title,
        content: content.substring(0, content.length > 100 ? 100 : content.length),
        encryptedData: encryptedContent,
        color: color ?? existingNote['color'] as String?,
        ispinned: ispinned ?? (existingNote['is_pinned'] as int) == 1,
      );

      return true;
    } catch (e) {
      print('Error updating note: $e');
      return false;
    }
  }

  /// Delete a note
  Future<bool> deleteNote(String id) async {
    if (!_authService.isAuthenticated) {
      throw Exception('Not authenticated. Please unlock the app first.');
    }

    try {
      await _dbService.deleteNote(id);
      return true;
    } catch (e) {
      print('Error deleting note: $e');
      return false;
    }
  }

  /// Toggle pinned status
  Future<bool> togglepinned(String id, bool ispinned) async {
    if (!_authService.isAuthenticated) {
      throw Exception('Not authenticated. Please unlock the app first.');
    }

    try {
      await _dbService.togglepinned(id, ispinned);
      return true;
    } catch (e) {
      print('Error toggling pinned: $e');
      return false;
    }
  }
}
