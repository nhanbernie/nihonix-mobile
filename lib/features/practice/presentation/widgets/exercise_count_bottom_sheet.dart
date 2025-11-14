import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class ExerciseCountBottomSheet extends StatefulWidget {
  final String topicName;
  final String exerciseType; // 'fill_blank' or 'multiple_choice'

  const ExerciseCountBottomSheet({
    super.key,
    required this.topicName,
    required this.exerciseType,
  });

  @override
  State<ExerciseCountBottomSheet> createState() => _ExerciseCountBottomSheetState();

  static Future<int?> show({
    required BuildContext context,
    required String topicName,
    required String exerciseType,
  }) {
    return showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ExerciseCountBottomSheet(
        topicName: topicName,
        exerciseType: exerciseType,
      ),
    );
  }
}

class _ExerciseCountBottomSheetState extends State<ExerciseCountBottomSheet> {
  int _selectedCount = 10;

  final List<int> _countOptions = [5, 10, 15, 20];

  @override
  Widget build(BuildContext context) {
    final color = widget.exerciseType == 'fill_blank' 
        ? AppColors.accent2 
        : AppColors.accent1;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.s24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSizes.s20),

              // Header with AI icon
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(AppSizes.s12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color,
                          color.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_awesome_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: AppSizes.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tạo bài tập với AI',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppSizes.s4),
                        Text(
                          widget.topicName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSizes.s24),

              // Description
              Container(
                padding: const EdgeInsets.all(AppSizes.s16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: AppSizes.s12),
                    Expanded(
                      child: Text(
                        'AI sẽ tạo bài tập phù hợp với trình độ của bạn',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.blue.shade900,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSizes.s24),

              // Select count label
              Text(
                'Chọn số lượng bài tập:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: AppSizes.s16),

              // Count options
              Row(
                children: _countOptions.map((count) {
                  final isSelected = _selectedCount == count;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: AppSizes.s8),
                      child: _CountOption(
                        count: count,
                        isSelected: isSelected,
                        color: color,
                        onTap: () {
                          setState(() {
                            _selectedCount = count;
                          });
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppSizes.s24),

              // Generate button
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color,
                      color.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context, _selectedCount);
                  },
                  icon: const Icon(Icons.auto_awesome_rounded, size: 20),
                  label: const Text(
                    'Tạo ngay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CountOption extends StatelessWidget {
  final int count;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _CountOption({
    required this.count,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
          decoration: BoxDecoration(
            color: isSelected 
                ? color.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? color : Colors.grey.shade300,
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Column(
            children: [
              Text(
                '$count',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? color : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: AppSizes.s4),
              Text(
                'câu',
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected ? color : Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

