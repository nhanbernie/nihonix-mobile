import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/shared/widgets/common_app_bar.dart';

class QuizPlayPage extends ConsumerStatefulWidget {
  final String topicId;
  final String topicName;
  final String quizType; // 'fill_blank' or 'multiple_choice'

  const QuizPlayPage({
    super.key,
    required this.topicId,
    required this.topicName,
    required this.quizType,
  });

  @override
  ConsumerState<QuizPlayPage> createState() => _QuizPlayPageState();
}

class _QuizPlayPageState extends ConsumerState<QuizPlayPage> {
  @override
  Widget build(BuildContext context) {
    // Get display info based on quiz type
    final isFillBlank = widget.quizType == 'fill_blank';
    final title = isFillBlank ? 'Điền vào chỗ trống' : 'Trắc nghiệm';
    final icon = isFillBlank ? Icons.edit_note_rounded : Icons.checklist_rounded;
    final color = isFillBlank ? AppColors.accent2 : AppColors.accent1;

    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: CommonAppBar(
        title: title,
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 64 + AppSizes.s12,
          left: AppSizes.s16,
          right: AppSizes.s16,
          bottom: MediaQuery.of(context).padding.bottom + AppSizes.s16,
        ),
        child: Column(
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(AppSizes.s20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.withValues(alpha: 0.8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: Colors.white,
                  ),
                  const SizedBox(width: AppSizes.s16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: AppSizes.s4),
                        Text(
                          widget.topicName,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.s24),

            // Empty State - No exercises yet
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(AppSizes.s24),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.assignment_outlined,
                        size: 64,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s24),

                    // Title
                    Text(
                      'Chưa có bài tập',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s8),

                    // Subtitle
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s32),
                      child: Text(
                        'Hiện tại chưa có bài tập cho chủ đề này.\nSử dụng AI để tạo bài tập tự động!',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                          height: 1.5,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.s32),

                    // Create with AI Button
                    Container(
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
                          // TODO: Navigate to AI generate exercise page
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Tính năng tạo bài tập bằng AI đang được phát triển'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.auto_awesome_rounded, size: 24),
                        label: const Text(
                          'Tạo bằng AI',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          foregroundColor: Colors.white,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSizes.s32,
                            vertical: AppSizes.s16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSizes.s12),

                    // Back Button
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        'Quay lại',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

