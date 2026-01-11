import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../models/note_model.dart';
import '../widgets/note_card.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../widgets/filter_chips_bar.dart';
import 'note_editor_screen.dart';
import '../../../core/services/notes_service.dart';

class NotesListScreen extends StatefulWidget {
  const NotesListScreen({Key? key}) : super(key: key);

  @override
  State<NotesListScreen> createState() => _NotesListScreenState();
}

class _NotesListScreenState extends State<NotesListScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  NoteFilter _selectedFilter = NoteFilter.all;
  List<Note> _notes = [];
  List<Note> _filteredNotes = [];

  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: AppDurations.fabPulse,
      vsync: this,
    )..repeat(reverse: true);

    _fabAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );

    _loadNotes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final notesService = NotesService();
    try {
      final rawNotes = await notesService.getAllNotes();
      setState(() {
        _notes = rawNotes.map((n) {
          final content = n['content'] as String? ?? '';
          final preview = n['title'] as String? ?? (content.length > 100 ? content.substring(0, 100) : content);
          return Note(
            id: n['id'] as String,
            encryptedTitle: preview,
            encryptedContent: content,
            titleSalt: '',
            contentSalt: '',
            titleIV: '',
            contentIV: '',
            ispinned: (n['is_pinned'] as bool?) ?? (n['is_pinned'] == 1),
            isPinned: false,
            colorCode: n['color'] as String? ?? '#00BCD4',
            createdAt: DateTime.parse(n['created_at'] as String),
            updatedAt: DateTime.parse(n['updated_at'] as String),
            wordCount: content.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).length,
            characterCount: content.length,
          );
        }).toList();
        _applyFilter();
      });
    } catch (e) {
      print('Error loading notes: $e');
      setState(() {
        _notes = [];
        _applyFilter();
      });
    }
  }

  void _openEditor(Note note) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          noteId: note.id,
          initialTitle: note.encryptedTitle,
          initialContent: note.encryptedContent,
        ),
      ),
    );

    if (result == true) {
      await _loadNotes();
    }
  }

  void _showNoteOptions(Note note) {
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
            ListTile(
              leading: Icon(Icons.edit, color: AppColors.textPrimary),
              title: Text('Edit'),
              onTap: () {
                Navigator.pop(context);
                _openEditor(note);
              },
            ),
            ListTile(
              leading: Icon(Icons.star, color: AppColors.textPrimary),
              title: Text(note.ispinned ? 'Unpinned' : 'Mark as pinned'),
              onTap: () async {
                Navigator.pop(context);
                final notesService = NotesService();
                await notesService.togglepinned(note.id, !note.ispinned);
                await _loadNotes();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete_outline, color: AppColors.danger),
              title: Text('Delete', style: TextStyle(color: AppColors.danger)),
              onTap: () async {
                Navigator.pop(context);
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppDimensions.radiusLarge),
                    ),
                    title: Text(AppStrings.deleteNote, style: AppTextStyles.headlineMedium),
                    content: Text(AppStrings.deleteNoteMessage, style: AppTextStyles.bodyMedium),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context, false), child: Text(AppStrings.cancel)),
                      ElevatedButton(onPressed: () => Navigator.pop(context, true), style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger), child: Text(AppStrings.delete)),
                    ],
                  ),
                );

                if (confirm == true) {
                  final notesService = NotesService();
                  await notesService.deleteNote(note.id);
                  await _loadNotes();
                }
              },
            ),
            SizedBox(height: AppDimensions.spacingMd),
          ],
        ),
      ),
    );
  }

  void _applyFilter() {
    setState(() {
      switch (_selectedFilter) {
        case NoteFilter.all:
          _filteredNotes = List.from(_notes);
          break;
        case NoteFilter.pinned:
          _filteredNotes = _notes.where((n) => n.ispinned).toList();
          break;
        case NoteFilter.recent:
          _filteredNotes = List.from(_notes)
            ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          break;
      }

      // Apply search filter
      if (_searchController.text.isNotEmpty) {
        _filteredNotes = _filteredNotes.where((note) {
          final searchLower = _searchController.text.toLowerCase();
          // In real app, you'd search decrypted content
          return note.id.toLowerCase().contains(searchLower);
        }).toList();
      }
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
        _applyFilter();
      }
    });
  }

  void _createNewNote() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(),
      ),
    );

    if (result == true) {
      await _loadNotes();
    }
  }

  String _getDecryptedTitle(Note note) {
    return note.encryptedTitle;
  }

  String _getDecryptedContent(Note note) {
    return note.encryptedContent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryMain,
        elevation: 4,
        shadowColor: AppColors.shadow2,
        leading: _isSearching
            ? null
            : IconButton(
                icon: Icon(Icons.menu, color: AppColors.textPrimary),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Drawer coming soon!')),
                  );
                },
              ),
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                style: AppTextStyles.bodyLarge,
                decoration: InputDecoration(
                  hintText: AppStrings.searchNotes,
                  hintStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textDisabled,
                  ),
                  border: InputBorder.none,
                ),
                onChanged: (value) => _applyFilter(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.myNotes,
                    style: AppTextStyles.titleLarge,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.lock,
                        size: 12,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        '${_notes.length} ${AppStrings.notesEncrypted}',
                        style: AppTextStyles.labelSmall,
                      ),
                    ],
                  ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? Icons.close : Icons.search,
              color: AppColors.textPrimary,
            ),
            onPressed: _toggleSearch,
          ),
          if (!_isSearching)
            IconButton(
              icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('More options coming soon!')),
                );
              },
            ),
        ],
      ),
      body: Column(
        children: [
          // Filter chips
          FilterChipsBar(
            selectedFilter: _selectedFilter,
            onFilterChanged: (filter) {
              setState(() {
                _selectedFilter = filter;
              });
              _applyFilter();
            },
          ),
          // Notes list or empty state
          Expanded(
            child: _filteredNotes.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.folder_open_rounded,
                          size: AppDimensions.emptyStateIllustration,
                          color: AppColors.textDisabled,
                        ),
                        SizedBox(height: AppDimensions.spacingLg),
                        Text(
                          _notes.isEmpty
                              ? AppStrings.noNotesYet
                              : AppStrings.noSearchResults,
                          style: AppTextStyles.headlineMedium,
                        ),
                        SizedBox(height: AppDimensions.spacingMd),
                        Text(
                          _notes.isEmpty
                              ? AppStrings.noNotesSubtitle
                              : AppStrings.tryDifferentSearch,
                          style: AppTextStyles.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : MasonryGridView.count(
                    padding: EdgeInsets.all(AppDimensions.spacingMd),
                    crossAxisCount: AppDimensions.gridColumns,
                    mainAxisSpacing: AppDimensions.gridGap,
                    crossAxisSpacing: AppDimensions.gridGap,
                    itemCount: _filteredNotes.length,
                    itemBuilder: (context, index) {
                      final note = _filteredNotes[index];
                      return NoteCard(
                        note: note,
                        decryptedTitle: _getDecryptedTitle(note),
                        decryptedContent: _getDecryptedContent(note),
                        onLongPress: () => _showNoteOptions(note),
                        onTap: () => _openEditor(note),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: _createNewNote,
          backgroundColor: AppColors.secondaryMain,
          child: Icon(
            Icons.add,
            size: AppDimensions.iconSizeLarge,
            color: AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
