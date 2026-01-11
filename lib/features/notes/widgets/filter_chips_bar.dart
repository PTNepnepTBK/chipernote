import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_dimensions.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';

enum NoteFilter { all, pinned, recent }

class FilterChipsBar extends StatefulWidget {
  final NoteFilter selectedFilter;
  final ValueChanged<NoteFilter> onFilterChanged;

  const FilterChipsBar({
    Key? key,
    required this.selectedFilter,
    required this.onFilterChanged,
  }) : super(key: key);

  @override
  State<FilterChipsBar> createState() => _FilterChipsBarState();
}

class _FilterChipsBarState extends State<FilterChipsBar> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  String _getFilterLabel(NoteFilter filter) {
    switch (filter) {
      case NoteFilter.all:
        return AppStrings.filterAll;
      case NoteFilter.pinned:
        return AppStrings.filterpinned;

      case NoteFilter.recent:
        return AppStrings.filterRecent;
    }
  }

  IconData _getFilterIcon(NoteFilter filter) {
    switch (filter) {
      case NoteFilter.all:
        return Icons.grid_view;
      case NoteFilter.pinned:
        return Icons.push_pin;
      case NoteFilter.recent:
        return Icons.access_time;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimensions.filterChipsHeight,
      color: AppColors.backgroundSecondary,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              AppColors.backgroundSecondary,
              Colors.transparent,
              Colors.transparent,
              AppColors.backgroundSecondary,
            ],
            stops: [0.0, 0.05, 0.95, 1.0],
          ).createShader(bounds);
        },
        blendMode: BlendMode.dstOut,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: AppDimensions.spacingMd),
          itemCount: NoteFilter.values.length,
          itemBuilder: (context, index) {
            final filter = NoteFilter.values[index];
            final isSelected = widget.selectedFilter == filter;

            return Padding(
              padding: EdgeInsets.only(
                right: AppDimensions.spacingSm,
                top: AppDimensions.spacingSm,
                bottom: AppDimensions.spacingSm,
              ),
              child: AnimatedContainer(
                duration: AppDurations.normal,
                child: FilterChip(
                  selected: isSelected,
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      filter == NoteFilter.pinned
                          ? Transform.rotate(
                              angle: 0.7,
                              alignment: Alignment.center,
                              child: Icon(
                                _getFilterIcon(filter),
                                size: 16,
                                color: isSelected
                                    ? AppColors.textPrimary
                                    : AppColors.textSecondary,
                              ),
                            )
                          : Icon(
                              _getFilterIcon(filter),
                              size: 16,
                              color: isSelected
                                  ? AppColors.textPrimary
                                  : AppColors.textSecondary,
                            ),
                      SizedBox(width: AppDimensions.spacingXs),
                      Text(_getFilterLabel(filter)),
                    ],
                  ),
                  onSelected: (_) => widget.onFilterChanged(filter),
                  backgroundColor: AppColors.surface,
                  selectedColor: AppColors.secondaryMain,
                  labelStyle: AppTextStyles.labelMedium.copyWith(
                    color: isSelected
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSmall),
                  ),
                  showCheckmark: false,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
