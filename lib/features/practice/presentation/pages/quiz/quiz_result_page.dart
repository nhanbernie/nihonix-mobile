import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/practice/domain/entities/exercise.dart';
import 'package:nihonix/features/practice/domain/entities/exercise_session.dart';

/// Quiz result page showing detailed results with explanations
class QuizResultPage extends StatelessWidget {
  final ExerciseSession session;
  final Map<int, int> selectedAnswers; // questionIndex -> optionId
  final Color accentColor;

  const QuizResultPage({
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
    final score =
        totalQuestions > 0 ? (correctCount / totalQuestions * 100).round() : 0;

    return QuizResult(
      score: score,
      correctCount: correctCount,
      incorrectCount: incorrectCount,
      totalQuestions: totalQuestions,
      questionResults: questionResults,
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _calculateResults();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Kết quả bài làm',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          // Header with score
          SliverToBoxAdapter(
            child: Container(
              margin: const EdgeInsets.all(AppSizes.s16),
              padding: const EdgeInsets.all(AppSizes.s24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    accentColor,
                    accentColor.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
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
                  // Score Circle
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${result.score}%',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSizes.s16),
                  Text(
                    '${result.correctCount}/${result.totalQuestions} câu đúng',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: AppSizes.s8),
                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _StatChip(
                        icon: Icons.check_circle,
                        label: 'Đúng',
                        count: result.correctCount,
                        color: Colors.green,
                      ),
                      const SizedBox(width: AppSizes.s16),
                      _StatChip(
                        icon: Icons.cancel,
                        label: 'Sai',
                        count: result.incorrectCount,
                        color: Colors.red,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Question Results List
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSizes.s16,
              0,
              AppSizes.s16,
              AppSizes.s40,
            ),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final questionResult = result.questionResults[index];
                  return _QuestionResultCard(
                    questionResult: questionResult,
                    isDark: isDark,
                    accentColor: accentColor,
                  );
                },
                childCount: result.questionResults.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSizes.s16,
        vertical: AppSizes.s8,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: AppSizes.s8),
          Text(
            '$count $label',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionResultCard extends StatelessWidget {
  final QuestionResult questionResult;
  final bool isDark;
  final Color accentColor;

  const _QuestionResultCard({
    required this.questionResult,
    required this.isDark,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final exercise = questionResult.exercise;
    final isCorrect = questionResult.isCorrect;

    return Container(
      margin: const EdgeInsets.only(bottom: AppSizes.s16),
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCorrect
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with status
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isCorrect ? Colors.green : Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isCorrect ? Icons.check : Icons.close,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Text(
                'Câu ${questionResult.questionIndex + 1}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s8,
                  vertical: AppSizes.s4,
                ),
                decoration: BoxDecoration(
                  color: isCorrect
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  isCorrect ? 'Đúng' : 'Sai',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isCorrect ? Colors.green : Colors.red,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s16),

          // Question
          Text(
            exercise.question.text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
              height: 1.5,
            ),
          ),

          // Hint if available
          if (exercise.question.hint != null) ...[
            const SizedBox(height: AppSizes.s8),
            Container(
              padding: const EdgeInsets.all(AppSizes.s12),
              decoration: BoxDecoration(
                color: Colors.amber.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.amber.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline_rounded,
                    color: Colors.amber.shade700,
                    size: 18,
                  ),
                  const SizedBox(width: AppSizes.s8),
                  Expanded(
                    child: Text(
                      exercise.question.hint!,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.amber.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          // Context if available
          if (exercise.question.context != null) ...[
            const SizedBox(height: AppSizes.s8),
            Container(
              padding: const EdgeInsets.all(AppSizes.s12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: Colors.blue.shade700,
                    size: 18,
                  ),
                  const SizedBox(width: AppSizes.s8),
                  Expanded(
                    child: Text(
                      exercise.question.context!,
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

          const SizedBox(height: AppSizes.s16),
          const Divider(),
          const SizedBox(height: AppSizes.s16),

          // Selected Answer
          Text(
            'Đáp án bạn chọn:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isDark ? Colors.white70 : Colors.black54,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          if (questionResult.selectedAnswerId != null)
            _AnswerOption(
              text: _getAnswerText(exercise, questionResult.selectedAnswerId!),
              isCorrect: isCorrect,
              isDark: isDark,
            )
          else
            Container(
              padding: const EdgeInsets.all(AppSizes.s12),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.help_outline, color: Colors.grey, size: 20),
                  const SizedBox(width: AppSizes.s8),
                  Text(
                    'Chưa trả lời',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),

          // Correct Answer (if wrong)
          if (!isCorrect && questionResult.correctAnswerId != null) ...[
            const SizedBox(height: AppSizes.s16),
            Text(
              'Đáp án đúng:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade700,
              ),
            ),
            const SizedBox(height: AppSizes.s8),
            _AnswerOption(
              text: _getAnswerText(exercise, questionResult.correctAnswerId!),
              isCorrect: true,
              isDark: isDark,
            ),
          ],

          // Explanation
          if (exercise.explanation.vi != null ||
              exercise.explanation.en != null) ...[
            const SizedBox(height: AppSizes.s16),
            Container(
              padding: const EdgeInsets.all(AppSizes.s16),
              decoration: BoxDecoration(
                color: accentColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: accentColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.school_rounded,
                        color: accentColor,
                        size: 20,
                      ),
                      const SizedBox(width: AppSizes.s8),
                      Text(
                        'Giải thích',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSizes.s12),
                  if (exercise.explanation.vi != null)
                    Text(
                      exercise.explanation.vi!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  if (exercise.explanation.en != null &&
                      exercise.explanation.vi == null) ...[
                    const SizedBox(height: AppSizes.s8),
                    Text(
                      exercise.explanation.en!,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.black87,
                        height: 1.5,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getAnswerText(Exercise exercise, int answerId) {
    try {
      final option = exercise.options.firstWhere(
        (opt) => opt.id == answerId,
      );
      return option.text;
    } catch (e) {
      return exercise.options.isNotEmpty ? exercise.options.first.text : '';
    }
  }
}

class _AnswerOption extends StatelessWidget {
  final String text;
  final bool isCorrect;
  final bool isDark;

  const _AnswerOption({
    required this.text,
    required this.isCorrect,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s12),
      decoration: BoxDecoration(
        color: isCorrect
            ? Colors.green.withOpacity(0.1)
            : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isCorrect
              ? Colors.green.withOpacity(0.3)
              : Colors.red.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isCorrect ? Icons.check_circle : Icons.cancel,
            color: isCorrect ? Colors.green : Colors.red,
            size: 20,
          ),
          const SizedBox(width: AppSizes.s8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
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
