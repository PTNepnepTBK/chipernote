import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_durations.dart';
import '../models/note_model.dart';
import '../screens/note_editor_screen.dart';

class NoteCard extends StatefulWidget {
  final Note note;
  final String decryptedTitle;
  final String decryptedContent;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const NoteCard({
    Key? key,
    required this.note,
    required this.decryptedTitle,
    required this.decryptedContent,
    this.onTap,
    this.onLongPress,
  }) : super(key: key);

  @override
  State<NoteCard> createState() => _NoteCardState();
}

class _NoteCardState extends State<NoteCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.cardHover,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getRelativeTime() {
    final now = DateTime.now();
    final difference = now.difference(widget.note.updatedAt);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${(difference.inDays / 7).floor()} weeks ago';
    }
  }

  void _handleTap() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NoteEditorScreen(
          noteId: widget.note.id,
          initialTitle: widget.decryptedTitle,
          initialContent: widget.decryptedContent,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        setState(() => _isPressed = true);
        _controller.forward();
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
        _controller.reverse();
      },
      onTap: widget.onTap ?? _handleTap,
      onLongPress: widget.onLongPress,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          // Limit overall card height to avoid overflow in tight grid cells
          constraints: BoxConstraints(minHeight: 90, maxHeight: 160),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMedium),
            border: Border(
              left: BorderSide(
                color: Color(int.parse(widget.note.colorCode.replaceFirst('#', '0xFF'))),
                width: 4,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow1,
                blurRadius: AppDimensions.shadowBlur1,
                offset: Offset(0, AppDimensions.shadowOffsetY1),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(AppDimensions.spacingMd),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: widget.note.isPinned
                          ? Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppDimensions.spacingSm,
                                vertical: AppDimensions.spacingXs,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryMain.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                              ),
                              child: Text(
                                'PINNED',
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: AppColors.secondaryMain,
                                ),
                              ),
                            )
                          : SizedBox.shrink(),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.note.hasIndependentPassword)
                          Icon(
                            Icons.lock,
                            size: 16,
                            color: AppColors.lockIndicator,
                          ),
                        if (widget.note.isFavorite) ...[
                          SizedBox(width: AppDimensions.spacingXs),
                          Icon(
                            Icons.star,
                            size: 16,
                            color: AppColors.lockIndicator,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                child: Text(
                  widget.decryptedTitle.isEmpty ? 'Untitled' : widget.decryptedTitle,
                  style: AppTextStyles.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(height: AppDimensions.spacingXs),
              // Content preview
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
                  child: Text(
                    widget.decryptedContent,
                    style: AppTextStyles.bodyMedium,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spacingXs),
              // Metadata
              Padding(
                padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd, vertical: AppDimensions.spacingXs),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 12,
                          color: AppColors.textDisabled,
                        ),
                        SizedBox(width: AppDimensions.spacingXs),
                        Expanded(
                          child: Text(
                            _getRelativeTime(),
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textDisabled,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: AppDimensions.spacingXs),
                    Row(
                      children: [
                        Icon(
                          Icons.article_outlined,
                          size: 12,
                          color: AppColors.textDisabled,
                        ),
                        SizedBox(width: AppDimensions.spacingXs),
                        Expanded(
                          child: Text(
                            '${widget.note.wordCount} words',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.textDisabled,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
