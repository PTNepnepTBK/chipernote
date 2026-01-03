import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/services/notes_service.dart';

class NoteEditorScreen extends StatefulWidget {
  final String? noteId;
  final String? initialTitle;
  final String? initialContent;

  const NoteEditorScreen({
    Key? key,
    this.noteId,
    this.initialTitle,
    this.initialContent,
  }) : super(key: key);

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  Timer? _debounceTimer;
  bool _isSaving = false;
  bool _isFavorite = false;
  bool _isLocked = false;
  String _saveStatus = AppStrings.editing;

  // Internal note id for update/delete
  String? _noteId;
  final NotesService _notesService = NotesService();

  @override
  void initState() {
    super.initState();
    _noteId = widget.noteId;
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _contentController = TextEditingController(text: widget.initialContent ?? '');

    // Auto-save listener
    _titleController.addListener(_onContentChanged);
    _contentController.addListener(_onContentChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _onContentChanged() {
    if (!_isSaving) {
      setState(() {
        _saveStatus = AppStrings.editing;
      });

      // Debounce auto-save: cancel previous timer and start a new one
      _debounceTimer?.cancel();
      _debounceTimer = Timer(AppDurations.autoSaveDebounce, () async {
        if (!mounted) return;
        await _saveNote();
      });
    }
  }

  Future<bool> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty && content.isEmpty) return false;

    setState(() {
      _isSaving = true;
      _saveStatus = AppStrings.saving;
    });

    bool success = false;
    try {
      if (_noteId == null) {
        final createdId = await _notesService.createNote(
          title: title,
          content: content,
          color: null,
          isFavorite: _isFavorite,
        );
        if (createdId != null) {
          _noteId = createdId;
          success = true;
        }
      } else {
        success = await _notesService.updateNote(
          id: _noteId!,
          title: title,
          content: content,
          color: null,
          isFavorite: _isFavorite,
        );
      }
    } catch (e) {
      print('Error saving note: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
          _saveStatus = success ? AppStrings.allSaved : AppStrings.editing;
        });
      }
    }

    return success;
  }

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  void _toggleLock() {
    setState(() {
      _isLocked = !_isLocked;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isLocked
            ? AppStrings.noteLockedWithPassword
            : 'Note unlocked'),
        duration: Duration(seconds: 2),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppDimensions.radiusLarge),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: AppDimensions.spacingMd),
              width: AppDimensions.dragHandleWidth,
              height: AppDimensions.dragHandleHeight,
              decoration: BoxDecoration(
                color: AppColors.divider,
                borderRadius: BorderRadius.circular(AppDimensions.radiusFull),
              ),
            ),
            SizedBox(height: AppDimensions.spacingLg),
            _buildMenuOption(
              icon: Icons.content_copy,
              title: AppStrings.duplicate,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Note duplicated')),
                );
              },
            ),
            _buildMenuOption(
              icon: Icons.folder_outlined,
              title: AppStrings.moveToFolder,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            _buildMenuOption(
              icon: Icons.share,
              title: AppStrings.share,
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(height: 1, color: AppColors.divider),
            _buildMenuOption(
              icon: Icons.delete_outline,
              title: AppStrings.delete,
              color: AppColors.danger,
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation();
              },
            ),
            SizedBox(height: AppDimensions.spacingMd),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingLg,
          vertical: AppDimensions.spacingMd,
        ),
        child: Row(
          children: [
            Icon(icon, color: color ?? AppColors.textPrimary, size: 24),
            SizedBox(width: AppDimensions.spacingMd),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                color: color ?? AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
        ),
        title: Text(
          AppStrings.deleteNote,
          style: AppTextStyles.headlineMedium,
        ),
        content: Text(
          AppStrings.deleteNoteMessage,
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context); // Close dialog
              if (_noteId != null) {
                await _notesService.deleteNote(_noteId!);
              }
              Navigator.pop(context, true); // Close editor and signal deletion
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.danger,
            ),
            child: Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }

  Future<void> _handleBack() async {
    // Cancel any pending autosave and attempt to save immediately
    _debounceTimer?.cancel();

    final saved = await _saveNote();

    // If widget disposed while saving, do nothing
    if (!mounted) return;

    // Pop with result indicating whether a save occurred
    Navigator.pop(context, saved);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _handleBack();
        return false; // we manually popped inside _handleBack
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryMain.withValues(alpha: 0.95),
        elevation: 4,
        shadowColor: AppColors.shadow1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => _handleBack(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _saveStatus == AppStrings.allSaved
                  ? Icons.check_circle
                  : _saveStatus == AppStrings.saving
                      ? Icons.sync
                      : Icons.edit,
              size: 20,
              color: _saveStatus == AppStrings.allSaved
                  ? AppColors.success
                  : AppColors.textSecondary,
            ),
            SizedBox(width: AppDimensions.spacingSm),
            Text(
              _saveStatus,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: AppColors.success),
            onPressed: () async {
              final saved = await _saveNote();
              if (saved) Navigator.pop(context, true);
              else ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Nothing to save or failed to save')));
            },
          ),
          IconButton(
            icon: Icon(
              _isLocked ? Icons.lock : Icons.lock_open,
              color: _isLocked ? AppColors.lockIndicator : AppColors.success,
            ),
            onPressed: _toggleLock,
          ),
          IconButton(
            icon: Icon(
              _isFavorite ? Icons.star : Icons.star_border,
              color: _isFavorite ? AppColors.lockIndicator : AppColors.textSecondary,
            ),
            onPressed: _toggleFavorite,
          ),
          IconButton(
            icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: _showMoreOptions,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.spacingLg),
          child: Column(
            children: [
              // Title input
              TextField(
                controller: _titleController,
                style: AppTextStyles.headlineMedium,
                decoration: InputDecoration(
                  hintText: AppStrings.noteTitle,
                  hintStyle: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              Divider(color: AppColors.divider),
              SizedBox(height: AppDimensions.spacingMd),
              // Content input
              TextField(
                controller: _contentController,
                style: AppTextStyles.editorContent,
                decoration: InputDecoration(
                  hintText: 'Start typing...',
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  border: InputBorder.none,
                ),
                maxLines: null,
                minLines: 20,
                keyboardType: TextInputType.multiline,
              ),
            ],
          ),
        ),
      ),
    ), // close Scaffold
    ); // close WillPopScope
  }
}
