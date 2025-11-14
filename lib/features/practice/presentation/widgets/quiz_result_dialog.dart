import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/features/practice/domain/entities/exercise.dart';
import 'package:nihonix/features/practice/domain/entities/exercise_session.dart';

/// Simple quiz result dialog showing only score with Lottie animation
class QuizResultDialog extends StatelessWidget {
  final ExerciseSession session;
  final Map<int, int> selectedAnswers; // questionIndex -> optionId
  final Color accentColor;

  const QuizResultDialog({
    super.key,
    required this.session,
    required this.selectedAnswers,
    required this.accentColor,
  });

  /// Calculate quiz results
  QuizResult _calculateResults() {
    int correctCount = 0;
    int incorrectCount = 0;
    final List<QuestionResult> questionResults = [];

    for (int i = 0; i < session.exercises.length; i++) {
      final exercise = session.exercises[i];
      final selectedAnswerId = selectedAnswers[i];
      
      // Assume correct answer is option with id: 1
      int? correctAnswerId;
      if (exercise.options.isNotEmpty) {
        try {
          final correctOption = exercise.options.firstWhere(
            (opt) => opt.id == 1,
            orElse: () => exercise.options.first,
          );
          correctAnswerId = correctOption.id;
        } catch (e) {
          correctAnswerId = exercise.options.first.id;
        }
      }
      
      final isCorrect = selectedAnswerId != null && 
                       correctAnswerId != null && 
                       selectedAnswerId == correctAnswerId;

      if (isCorrect) {
        correctCount++;
      } else {
        incorrectCount++;
      }

      questionResults.add(QuestionResult(
        questionIndex: i,
        exercise: exercise,
        selectedAnswerId: selectedAnswerId,
        correctAnswerId: correctAnswerId,
        isCorrect: isCorrect,
      ));
    }

    final totalQuestions = session.exercises.length;
    final score = totalQuestions > 0 ? (correctCount / totalQuestions * 100).round() : 0;

    return QuizResult(
      score: score,
      correctCount: correctCount,
      incorrectCount: incorrectCount,
      totalQuestions: totalQuestions,
      questionResults: questionResults,
    );
  }

  /// Get Lottie animation URL based on score
  String _getLottieUrl(int score) {
    if (score >= 80) {
      // Excellent - celebration animation (confetti)
      return 'https://assets5.lottiefiles.com/packages/lf20_jcikwtux.json';
    } else if (score >= 60) {
      // Good - trophy animation
      return 'https://assets5.lottiefiles.com/packages/lf20_vybwn7df.json';
    } else {
      // Keep trying - encouragement animation (star)
      return 'https://assets5.lottiefiles.com/packages/lf20_vybwn7df.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateResults();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Get Lottie URL based on score
    final lottieUrl = _getLottieUrl(result.score);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSizes.s16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header with gradient
            Container(
              padding: const EdgeInsets.only(
                top: AppSizes.s32,
                left: AppSizes.s24,
                right: AppSizes.s24,
                bottom: AppSizes.s16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor,
                    accentColor.withOpacity(0.7),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // Lottie Animation
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: Lottie.network(
                      lottieUrl,
                      fit: BoxFit.contain,
                      repeat: true,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback to a simple icon if Lottie fails
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            result.score >= 60 ? Icons.celebration : Icons.emoji_events,
                            size: 80,
                            color: Colors.white,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSizes.s16),
                  
                  // Score Circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '${result.score}%',
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${result.correctCount}/${result.totalQuestions}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.s16),
                  
                  // Title
                  Text(
                    'Kết quả bài làm',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s8),
                  
                  // Message based on score
                  Text(
                    result.score >= 80
                        ? 'Xuất sắc! Bạn làm rất tốt! 🎉'
                        : result.score >= 60
                            ? 'Tốt lắm! Tiếp tục phát huy! 💪'
                            : 'Cố gắng thêm nhé! Bạn sẽ làm tốt hơn! 💪',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.95),
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Column(
                children: [
                  // Summary text
                  Container(
                    padding: const EdgeInsets.all(AppSizes.s16),
                    decoration: BoxDecoration(
                      color: isDark 
                          ? const Color(0xFF2A2A2A) 
                          : accentColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: accentColor,
                          size: 24,
                        ),
                        const SizedBox(width: AppSizes.s12),
                        Text(
                          'Bạn đã trả lời đúng ${result.correctCount} câu',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: AppSizes.s24),
                  
                  // Action Buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        // Navigate to result page
                        context.push(
                          '${AppRoutes.quizResult}?sessionId=${session.sessionId}',
                          extra: {
                            'session': session,
                            'selectedAnswers': selectedAnswers,
                            'accentColor': accentColor,
                          },
                        );
                      },
                      icon: const Icon(Icons.visibility_rounded, size: 20),
                      label: const Text(
                        'Xem kết quả chi tiết',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.s12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Close dialog
                        Navigator.of(context).pop(); // Pop quiz page
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                        side: BorderSide(color: accentColor, width: 2),
                        foregroundColor: accentColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Hoàn thành',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QuizResult {
  final int score;
  final int correctCount;
  final int incorrectCount;
  final int totalQuestions;
  final List<QuestionResult> questionResults;

  QuizResult({
    required this.score,
    required this.correctCount,
    required this.incorrectCount,
    required this.totalQuestions,
    required this.questionResults,
  });
}

class QuestionResult {
  final int questionIndex;
  final Exercise exercise;
  final int? selectedAnswerId;
  final int? correctAnswerId;
  final bool isCorrect;

  QuestionResult({
    required this.questionIndex,
    required this.exercise,
    required this.selectedAnswerId,
    required this.correctAnswerId,
    required this.isCorrect,
  });
}
