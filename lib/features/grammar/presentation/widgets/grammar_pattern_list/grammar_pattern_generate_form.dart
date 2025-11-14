import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/shared/widgets/common_bottom_sheet.dart';
import 'package:nihonix/features/grammar/presentation/providers/grammar_provider.dart';
import 'package:nihonix/features/grammar/presentation/providers/grammar_generate_provider.dart';

/// Form widget for generating grammar patterns with AI
class GrammarPatternGenerateForm extends ConsumerStatefulWidget {
  final String grammarSubTopicSlug;

  const GrammarPatternGenerateForm({
    super.key,
    required this.grammarSubTopicSlug,
  });

  @override
  ConsumerState<GrammarPatternGenerateForm> createState() =>
      _GrammarPatternGenerateFormState();
}

class _GrammarPatternGenerateFormState
    extends ConsumerState<GrammarPatternGenerateForm> {
  late final TextEditingController countController;
  late final TextEditingController promptController;

  @override
  void initState() {
    super.initState();
    countController = TextEditingController(text: '5');
    promptController = TextEditingController();
  }

  @override
  void dispose() {
    countController.dispose();
    promptController.dispose();
    super.dispose();
  }

  Future<void> _handleGenerate() async {
    final count = int.tryParse(countController.text);
    if (count == null || count < 1 || count > 10) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a number between 1-10'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Save references BEFORE popping dialog
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final customPrompt = promptController.text.isEmpty ? null : promptController.text;

    // Save provider notifiers
    final generateNotifier = ref.read(grammarGenerateProvider.notifier);
    final grammarNotifier = ref.read(grammarProvider.notifier);

    // Close dialog
    navigator.pop();

    // Generate patterns and GET result
    final result = await generateNotifier.generateGrammarPatterns(
      grammarSubTopicSlug: widget.grammarSubTopicSlug,
      levelCode: 'N5', // TODO: Get from user level
      count: count,
      customPrompt: customPrompt,
    );

    if (result != null) {
      // Success - reload patterns
      await grammarNotifier.loadPatterns(widget.grammarSubTopicSlug);

      // Clear generate state
      generateNotifier.clearResult();

      // Show success message
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text(
            'Generated ${result.count} patterns successfully!',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      // Error - show error message
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Error generating patterns'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final generateState = ref.watch(grammarGenerateProvider);

    return BottomSheetContent(
      title: 'Generate Grammar Patterns',
      subtitle: 'AI will generate grammar patterns for this topic',
      children: [
        // Count input
        TextField(
          controller: countController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of patterns',
            hintText: 'Enter number (1-10)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.numbers_rounded),
          ),
        ),
        const SizedBox(height: 16),

        // Custom prompt (optional)
        TextField(
          controller: promptController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Custom prompt (optional)',
            hintText: 'E.g., Focus on casual conversation...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.edit_note_rounded),
          ),
        ),
        const SizedBox(height: 24),

        // Generate button
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            onPressed: generateState.isGenerating ? null : _handleGenerate,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: generateState.isGenerating
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Text(
                    'Generate with AI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

