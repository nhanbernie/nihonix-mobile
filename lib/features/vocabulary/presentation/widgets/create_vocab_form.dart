import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/shared/widgets/common_bottom_sheet.dart';
import '../providers/vocab_provider.dart';
import '../providers/vocab_generate_provider.dart';

/// Form widget for creating vocabulary with AI
class CreateVocabForm extends ConsumerStatefulWidget {
  final String topicId;

  const CreateVocabForm({
    super.key,
    required this.topicId,
  });

  @override
  ConsumerState<CreateVocabForm> createState() => _CreateVocabFormState();
}

class _CreateVocabFormState extends ConsumerState<CreateVocabForm> {
  late final TextEditingController countController;
  late final TextEditingController promptController;

  @override
  void initState() {
    super.initState();
    countController = TextEditingController(text: '10');
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
    if (count == null || count <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please enter a valid number'),
          ),
        );
      }
      return;
    }

    // Save ALL references BEFORE popping dialog
    final navigator = Navigator.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final customPrompt = promptController.text.isEmpty ? null : promptController.text;
    
    // Save provider notifiers
    final generateNotifier = ref.read(vocabGenerateProvider.notifier);
    final vocabNotifier = ref.read(vocabProvider.notifier);

    // Close dialog
    navigator.pop();

    // Generate vocabulary and GET result
    final result = await generateNotifier.generateVocabularyItems(
      topicId: widget.topicId,
      levelCode: 'N5', // TODO: Get from user level
      count: count,
      customPrompt: customPrompt,
    );

    if (result != null) {
      // Success - get result data
      final setId = result.setId;
      final setTitle = result.getSetTitleByLanguage('en');
      final generatedCount = result.generatedCount;

      // Reload vocab sets
      await vocabNotifier.loadVocabSetsByTopic(widget.topicId);

      // Clear generate state
      generateNotifier.clearResult();

      // Show success message
      scaffoldMessenger.showSnackBar(
        SnackBar(
          content: Text('Tạo $generatedCount từ vựng thành công!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );

      // Navigate to detail page
      router.push(
        '${AppRoutes.vocabSetDetail}?setId=$setId&setName=${Uri.encodeComponent(setTitle)}',
      );
    } else {
      // Error - show error message (error already in state)
      scaffoldMessenger.showSnackBar(
        const SnackBar(
          content: Text('Lỗi khi tạo từ vựng'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final generateState = ref.watch(vocabGenerateProvider);

    return BottomSheetContent(
      title: 'Create Vocabulary with AI',
      subtitle: 'AI will generate vocabulary list based on your prompt',
      children: [
        // Count field
        TextField(
          controller: countController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Number of Words',
            hintText: 'e.g., 10',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.numbers),
          ),
        ),
        const SizedBox(height: 16),

        // Prompt field (optional)
        TextField(
          controller: promptController,
          maxLines: 3,
          decoration: InputDecoration(
            labelText: 'Custom Prompt (Optional)',
            hintText: 'Describe specific vocabulary you want...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            prefixIcon: const Icon(Icons.auto_awesome),
          ),
        ),
        const SizedBox(height: 24),

        // Create button
        ElevatedButton(
          onPressed: generateState.isGenerating ? null : _handleGenerate,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
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
        const SizedBox(height: 16),
      ],
    );
  }
}

