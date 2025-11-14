import 'package:flutter/material.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import '../../domain/entities/exercise.dart';

/// Generic exercise question card widget (supports both fill_blank and multiple_choice)
class ExerciseQuestionCard extends StatefulWidget {
  final Exercise exercise;
  final int currentIndex;
  final int totalQuestions;
  final Function(int optionId) onAnswerSelected;
  final int? selectedAnswerId;
  final Color? accentColor;

  const ExerciseQuestionCard({
    super.key,
    required this.exercise,
    required this.currentIndex,
    required this.totalQuestions,
    required this.onAnswerSelected,
    this.selectedAnswerId,
    this.accentColor,
  });

  @override
  State<ExerciseQuestionCard> createState() => _ExerciseQuestionCardState();
}

class _ExerciseQuestionCardState extends State<ExerciseQuestionCard> {
  Color get _accentColor => widget.accentColor ?? AppColors.accent2;
  
  String get _typeLabel {
    switch (widget.exercise.type) {
      case 'fill_blank':
        return 'Điền vào chỗ trống';
      case 'multiple_choice':
        return 'Trắc nghiệm';
      default:
        return 'Bài tập';
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress Indicator
        Row(
          children: [
            Text(
              'Câu ${widget.currentIndex + 1}/${widget.totalQuestions}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.s12,
                vertical: AppSizes.s4,
              ),
              decoration: BoxDecoration(
                color: _accentColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _typeLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: _accentColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.s16),

        // Progress Bar
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: (widget.currentIndex + 1) / widget.totalQuestions,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(_accentColor),
            minHeight: 6,
          ),
        ),
        const SizedBox(height: AppSizes.s24),

        // Question Card
        Container(
          padding: const EdgeInsets.all(AppSizes.s20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Question Text
              Text(
                widget.exercise.question.text,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              
              if (widget.exercise.question.hint != null) ...[
                const SizedBox(height: AppSizes.s12),
                // Hint
                Container(
                  padding: const EdgeInsets.all(AppSizes.s12),
                  decoration: BoxDecoration(
                    color: Colors.amber.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.amber.shade200,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline_rounded,
                        color: Colors.amber.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: AppSizes.s8),
                      Expanded(
                        child: Text(
                          widget.exercise.question.hint!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.amber.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              if (widget.exercise.question.context != null) ...[
                const SizedBox(height: AppSizes.s12),
                // Context
                Container(
                  padding: const EdgeInsets.all(AppSizes.s12),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.info_outline_rounded,
                        color: Colors.blue.shade700,
                        size: 20,
                      ),
                      const SizedBox(width: AppSizes.s8),
                      Expanded(
                        child: Text(
                          widget.exercise.question.context!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: AppSizes.s24),

        // Options
        Text(
          'Chọn đáp án:',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey.shade800,
          ),
        ),
        const SizedBox(height: AppSizes.s12),

        ...widget.exercise.options.map((option) {
          final isSelected = widget.selectedAnswerId == option.id;
          
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSizes.s12),
            child: _OptionButton(
              text: option.text,
              isSelected: isSelected,
              accentColor: _accentColor,
              onTap: () => widget.onAnswerSelected(option.id),
            ),
          );
        }),
      ],
    );
  }
}

class _OptionButton extends StatelessWidget {
  final String text;
  final bool isSelected;
  final Color accentColor;
  final VoidCallback onTap;

  const _OptionButton({
    required this.text,
    required this.isSelected,
    required this.accentColor,
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
            color: isSelected 
                ? accentColor.withValues(alpha: 0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected 
                  ? accentColor
                  : Colors.grey.shade300,
              width: isSelected ? 2 : 1.5,
            ),
          ),
          child: Row(
            children: [
              // Radio indicator
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected ? accentColor : Colors.transparent,
                  border: Border.all(
                    color: isSelected ? accentColor : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      )
                    : null,
              ),
              const SizedBox(width: AppSizes.s12),

              // Option text
              Expanded(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected ? accentColor : Colors.grey.shade800,
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

