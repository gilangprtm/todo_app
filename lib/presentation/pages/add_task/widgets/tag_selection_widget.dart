import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_color.dart';
import '../../../../core/utils/mahas.dart';
import '../../../../data/models/tag_model.dart';
import '../../../../core/mahas/widget/mahas_button.dart';
import '../../../../core/mahas/widget/mahas_bottomsheet.dart';
import '../../../../core/mahas/inputs/input_text_component.dart';
import '../../../../core/mahas/mahas_type.dart';
import '../../../providers/add_task/add_task_provider.dart';

/// Widget for displaying and selecting tags
class TagSelectionWidget extends ConsumerWidget {
  const TagSelectionWidget({super.key});

  /// Show bottom sheet for adding a new tag
  static void showAddTagBottomSheet(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(addTaskProvider.notifier);
    final InputTextController tagNameController = InputTextController();
    Color selectedColor = Colors.blue; // Default color

    // List of predefined colors for selection
    final List<Color> colorOptions = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
      Colors.black,
    ];

    MahasBottomSheet.show(
      context: context,
      title: 'Add New Tag',
      height: 400,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Tag name input
                InputTextComponent(
                  controller: tagNameController,
                  label: 'Tag Name',
                  required: true,
                ),

                // Color selection
                const Text('Select Color', style: TextStyle(fontSize: 14)),
                const SizedBox(height: 8),

                // Color grid
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children:
                      colorOptions.map((color) {
                        final isSelected = selectedColor == color;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedColor = color;
                            });
                          },
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Colors.white
                                        : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow:
                                  isSelected
                                      ? [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.2,
                                          ),
                                          blurRadius: 4,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                      : null,
                            ),
                          ),
                        );
                      }).toList(),
                ),

                const SizedBox(height: 24),

                // Add tag button
                MahasButton(
                  text: 'Add Tag',
                  textColor: AppColors.getCardColor(context),
                  color: AppColors.getTextPrimaryColor(context),
                  isFullWidth: true,
                  onPressed: () {
                    if (tagNameController.value.isNotEmpty) {
                      // Create a new tag
                      final newTag = TagModel(
                        name: tagNameController.value.trim(),
                        color: '#$selectedColor',
                      );

                      // Add the tag and refresh
                      notifier.addNewTag(newTag).then((_) {
                        // Close the bottom sheet
                        Mahas.back();
                      });
                    }
                  },
                ),

                const SizedBox(height: 16),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addTaskProvider);
    final notifier = ref.read(addTaskProvider.notifier);

    final availableTags = state.availableTags;
    final selectedTags = state.selectedTags;
    final showTagSelector = state.showTagSelector;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with toggle button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tags',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextButton.icon(
              onPressed: () => notifier.toggleTagSelector(),
              icon: Icon(
                showTagSelector
                    ? Icons.keyboard_arrow_up
                    : Icons.keyboard_arrow_down,
                size: 18,
                color: AppColors.getTextPrimaryColor(context),
              ),
              label: Text(
                showTagSelector ? 'Hide' : 'Show',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.getTextPrimaryColor(context),
                ),
              ),
            ),
          ],
        ),

        // Selected tags display
        if (selectedTags.isNotEmpty) ...[
          SizedBox(
            height: 36,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    selectedTags
                        .map((tag) => _buildSelectedTag(context, tag, ref))
                        .toList(),
              ),
            ),
          ),
        ],

        // Tag selector
        if (showTagSelector) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Row(
                      children:
                          availableTags
                              .map((tag) => _buildTagOption(context, tag, ref))
                              .toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              MahasButton(
                icon: Icon(Icons.add, color: AppColors.getCardColor(context)),
                color: AppColors.getTextPrimaryColor(context),
                type: ButtonType.icon,
                onPressed: () => showAddTagBottomSheet(context, ref),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildSelectedTag(BuildContext context, TagModel tag, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(
          tag.name,
          style: const TextStyle(color: Colors.white, fontSize: 13),
        ),
        backgroundColor: tag.getColor(),
        deleteIcon: const Icon(Icons.close, size: 16, color: Colors.white),
        onDeleted: () => ref.read(addTaskProvider.notifier).toggleTag(tag),
        visualDensity: VisualDensity.compact,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        labelPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
      ),
    );
  }

  Widget _buildTagOption(BuildContext context, TagModel tag, WidgetRef ref) {
    final selectedTags = ref.watch(
      addTaskProvider.select((state) => state.selectedTags),
    );
    final isSelected = selectedTags.any((t) => t.id == tag.id);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: OutlinedButton(
        onPressed: () => ref.read(addTaskProvider.notifier).toggleTag(tag),
        style: OutlinedButton.styleFrom(
          backgroundColor:
              isSelected
                  ? tag.getColor().withValues(alpha: 0.7)
                  : Colors.transparent,
          side: BorderSide(
            color: isSelected ? Colors.transparent : Colors.grey.shade300,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
          minimumSize: const Size(0, 28),
        ),
        child: Text(
          tag.name,
          style: TextStyle(
            color:
                isSelected
                    ? Colors.white
                    : AppColors.getTextPrimaryColor(context),
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
