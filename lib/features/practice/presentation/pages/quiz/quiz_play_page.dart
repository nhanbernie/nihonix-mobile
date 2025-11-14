import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/shared/widgets/common_app_bar.dart';
import 'package:nihonix/features/practice/presentation/providers/practice_provider.dart';
import 'package:nihonix/features/practice/presentation/widgets/fill_blank_question_card.dart';
import 'package:nihonix/features/practice/presentation/widgets/exercise_count_bottom_sheet.dart';
import 'package:nihonix/shared/widgets/ai_loading_overlay.dart';
import 'package:nihonix/features/practice/domain/entities/exercise_session.dart';

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
  int _currentQuestionIndex = 0;
  final Map<int, int> _selectedAnswers = {}; // questionIndex -> optionId
  bool _isGenerating = false;
  ExerciseSession? _exerciseSession;

  Future<void> _showCountBottomSheetAndGenerate() async {
    // Show bottom sheet to select exercise count
    final exerciseCount = await ExerciseCountBottomSheet.show(
      context: context,
      topicName: widget.topicName,
      exerciseType: widget.quizType,
    );

    if (exerciseCount == null || !mounted) return;

    // Start generating with loading overlay
    setState(() => _isGenerating = true);

    try {
      final session = widget.quizType == 'fill_blank'
          ? await ref.read(generateFillBlankExercisesProvider(
              topicId: widget.topicId,
              exerciseCount: exerciseCount,
            ).future)
          : await ref.read(generateMultipleChoiceExercisesProvider(
              topicId: widget.topicId,
              exerciseCount: exerciseCount,
            ).future);

      if (mounted) {
        setState(() {
          _exerciseSession = session;
          _isGenerating = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isGenerating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onAnswerSelected(int optionId) {
    setState(() {
      _selectedAnswers[_currentQuestionIndex] = optionId;
    });
  }

  void _nextQuestion(int totalQuestions) {
    if (_currentQuestionIndex < totalQuestions - 1) {
      setState(() {
        _currentQuestionIndex++;
      });
    }
  }

  void _previousQuestion() {
    if (_currentQuestionIndex > 0) {
      setState(() {
        _currentQuestionIndex--;
      });
    }
  }

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
      body: Stack(
        children: [
          // Main content
          _exerciseSession == null
              ? _buildEmptyState(context, color, icon, title)
              : _buildExerciseContent(context, color, icon, title),

          // AI Loading Overlay
          if (_isGenerating)
            const AILoadingOverlay(
              message: 'AI đang tạo bài tập...',
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseContent(BuildContext context, Color color, IconData icon, String title) {
    final session = _exerciseSession!;
    
    if (session.exercises.isEmpty) {
      return _buildEmptyState(context, color, icon, title);
    }

    final currentExercise = session.exercises[_currentQuestionIndex];
    final totalQuestions = session.exercises.length;

    return Padding(
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

          // Question Card
          Expanded(
            child: SingleChildScrollView(
              child: FillBlankQuestionCard(
                exercise: currentExercise,
                currentIndex: _currentQuestionIndex,
                totalQuestions: totalQuestions,
                onAnswerSelected: _onAnswerSelected,
                selectedAnswerId: _selectedAnswers[_currentQuestionIndex],
              ),
            ),
          ),

          // Navigation Buttons
          Row(
            children: [
              if (_currentQuestionIndex > 0)
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _previousQuestion,
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Trước'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                      side: BorderSide(color: color),
                      foregroundColor: color,
                    ),
                  ),
                ),
              if (_currentQuestionIndex > 0) const SizedBox(width: AppSizes.s12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _selectedAnswers[_currentQuestionIndex] != null
                      ? () {
                          if (_currentQuestionIndex < totalQuestions - 1) {
                            _nextQuestion(totalQuestions);
                          } else {
                            // TODO: Navigate to result page
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Hoàn thành!')),
                            );
                          }
                        }
                      : null,
                  icon: Icon(
                    _currentQuestionIndex < totalQuestions - 1
                        ? Icons.arrow_forward_rounded
                        : Icons.check_rounded,
                  ),
                  label: Text(
                    _currentQuestionIndex < totalQuestions - 1 ? 'Tiếp' : 'Hoàn thành',
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, Color color, IconData icon, String title) {
    return Padding(
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

          // Empty State
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
                      onPressed: _isGenerating ? null : _showCountBottomSheetAndGenerate,
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
    );
  }
}
