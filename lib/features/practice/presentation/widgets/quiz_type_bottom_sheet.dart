import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';

class QuizTypeBottomSheet extends StatelessWidget {
  final String topicId;
  final String topicName;
  final VoidCallback onFillBlankTap;
  final VoidCallback onMultipleChoiceTap;

  const QuizTypeBottomSheet({
    super.key,
    required this.topicId,
    required this.topicName,
    required this.onFillBlankTap,
    required this.onMultipleChoiceTap,
  });

  @override
  Widget build(BuildContext context) {
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

              // Title
              Text(
                'Chọn loại bài tập',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade900,
                ),
              ),
              const SizedBox(height: AppSizes.s8),
              Text(
                'Chủ đề: $topicName',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: AppSizes.s24),

              // Fill Blank Option
              _QuizTypeOption(
                icon: Icons.edit_note_rounded,
                title: 'Điền vào chỗ trống',
                subtitle: 'Hoàn thành câu bằng cách điền từ phù hợp',
                color: AppColors.accent2,
                onTap: onFillBlankTap,
              ),
              const SizedBox(height: AppSizes.s12),

              // Multiple Choice Option
              _QuizTypeOption(
                icon: Icons.checklist_rounded,
                title: 'Trắc nghiệm',
                subtitle: 'Chọn đáp án đúng từ nhiều lựa chọn',
                color: AppColors.accent1,
                onTap: onMultipleChoiceTap,
              ),
              const SizedBox(height: AppSizes.s16),
            ],
          ),
        ),
      ),
    );
  }

  static Future<String?> show({
    required BuildContext context,
    required String topicId,
    required String topicName,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => QuizTypeBottomSheet(
        topicId: topicId,
        topicName: topicName,
        onFillBlankTap: () {
          Navigator.pop(context, 'fill_blank');
        },
        onMultipleChoiceTap: () {
          Navigator.pop(context, 'multiple_choice');
        },
      ),
    );
  }
}

class _QuizTypeOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _QuizTypeOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(AppSizes.s16),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.grey.shade200,
              width: 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(AppSizes.s12),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 28,
                ),
              ),
              const SizedBox(width: AppSizes.s16),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 18,
                color: Colors.grey.shade400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

