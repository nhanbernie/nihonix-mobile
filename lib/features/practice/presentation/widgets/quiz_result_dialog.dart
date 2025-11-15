import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/features/practice/domain/entities/exercise.dart';
import 'package:nihonix/features/practice/domain/entities/exercise_session.dart';

/// Simple and beautiful quiz result dialog
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
      // Excellent - celebration/confetti animation
      return 'https://assets5.lottiefiles.com/packages/lf20_jcikwtux.json';
    } else if (score >= 60) {
      // Good - success/trophy animation
      return 'https://assets5.lottiefiles.com/packages/lf20_vybwn7df.json';
    } else {
      // Keep trying - star/encouragement animation
      return 'https://assets5.lottiefiles.com/packages/lf20_jcikwtux.json';
    }
  }

  /// Get message based on score
  String _getMessage(int score) {
    if (score >= 80) {
      return 'Xuất sắc! 🎉';
    } else if (score >= 60) {
      return 'Tốt lắm! 💪';
    } else {
      return 'Cố gắng thêm nhé! 💪';
    }
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateResults();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final lottieUrl = _getLottieUrl(result.score);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(AppSizes.s24),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Lottie Animation Section
            Container(
              padding: const EdgeInsets.only(
                top: AppSizes.s32,
                left: AppSizes.s24,
                right: AppSizes.s24,
              ),
              child: Column(
                children: [
                  // Lottie Animation
                  SizedBox(
                    width: 180,
                    height: 180,
                    child: Lottie.network(
                      lottieUrl,
                      fit: BoxFit.contain,
                      repeat: true,
                      errorBuilder: (context, error, stackTrace) {
                        // Fallback icon
                        return Container(
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            result.score >= 60 
                                ? Icons.celebration_rounded 
                                : Icons.emoji_events_rounded,
                            size: 100,
                            color: accentColor,
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: AppSizes.s24),
                  
                  // Score Display
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSizes.s32,
                      vertical: AppSizes.s20,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          accentColor,
                          accentColor.withOpacity(0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: accentColor.withOpacity(0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${result.score}%',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        const SizedBox(height: AppSizes.s8),
                        Text(
                          '${result.correctCount}/${result.totalQuestions} câu đúng',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSizes.s20),
                  
                  // Message
                  Text(
                    _getMessage(result.score),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.all(AppSizes.s24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).pop();
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
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                        backgroundColor: accentColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.s12),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                        foregroundColor: isDark ? Colors.white70 : Colors.black54,
                      ),
                      child: const Text(
                        'Hoàn thành',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
