import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/ai_loading_overlay.dart';
import '../providers/flashcard_di.dart';
import '../providers/folder_sets_provider.dart';

class GenerateFlashcardPage extends ConsumerStatefulWidget {
  final String folderId;

  const GenerateFlashcardPage({
    super.key,
    required this.folderId,
  });

  @override
  ConsumerState<GenerateFlashcardPage> createState() => _GenerateFlashcardPageState();
}

class _GenerateFlashcardPageState extends ConsumerState<GenerateFlashcardPage> {
  final _formKey = GlobalKey<FormState>();
  final _setNameController = TextEditingController();
  final _topicController = TextEditingController();
  final _customPromptController = TextEditingController();
  
  String _selectedLevel = 'N5';
  String _selectedDifficulty = 'beginner';
  int _cardCount = 10;
  bool _isGenerating = false;
  bool _showCustomPrompt = false;

  final List<String> _levels = ['N5', 'N4', 'N3', 'N2', 'N1'];
  final List<String> _difficulties = ['beginner', 'intermediate', 'advanced'];

  @override
  void dispose() {
    _setNameController.dispose();
    _topicController.dispose();
    _customPromptController.dispose();
    super.dispose();
  }

  Future<void> _handleGenerate() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isGenerating) return;

    setState(() => _isGenerating = true);

    try {
      final useCase = ref.read(generateFlashcardUseCaseProvider);
      await useCase(
        folderId: widget.folderId,
        setName: _setNameController.text.trim(),
        levelCode: _selectedLevel,
        difficulty: _selectedDifficulty,
        topic: _topicController.text.trim(),
        count: _cardCount,
        customPrompt: _showCustomPrompt && _customPromptController.text.isNotEmpty
            ? _customPromptController.text.trim()
            : null,
      );

      // Refresh sets list
      ref.invalidate(folderSetsProvider(widget.folderId));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Tạo flashcard bằng AI thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi khi tạo flashcard: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isGenerating = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
            systemNavigationBarColor: Colors.white,
            systemNavigationBarIconBrightness: Brightness.dark,
          ),
          child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: _isGenerating ? null : () => context.pop(),
          ),
          title: const Text(
            'Tạo flashcard bằng AI',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          actions: [
            _isGenerating
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: _handleGenerate,
                    child: Text(
                      'Tạo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSizes.s24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // AI Icon Header
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      size: 40,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.s8),
                Center(
                  child: Text(
                    'AI sẽ tạo flashcard tự động',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
                const SizedBox(height: AppSizes.s32),

                // Set Name
                _buildLabel('Tên bộ thẻ'),
                const SizedBox(height: AppSizes.s8),
                TextFormField(
                  controller: _setNameController,
                  decoration: InputDecoration(
                    hintText: 'VD: N5 Greetings Chapter 1',
                    filled: true,
                    fillColor: const Color(0xFFF7F7F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(AppSizes.s16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập tên bộ thẻ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.s20),

                // Level
                _buildLabel('Cấp độ'),
                const SizedBox(height: AppSizes.s8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedLevel,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    items: _levels.map((level) {
                      return DropdownMenuItem(
                        value: level,
                        child: Text(level),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedLevel = value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.s20),

                // Difficulty
                _buildLabel('Độ khó'),
                const SizedBox(height: AppSizes.s8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F7F7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
                  child: DropdownButtonFormField<String>(
                    value: _selectedDifficulty,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    items: _difficulties.map((difficulty) {
                      String label = difficulty;
                      if (difficulty == 'beginner') label = 'Cơ bản';
                      if (difficulty == 'intermediate') label = 'Trung bình';
                      if (difficulty == 'advanced') label = 'Nâng cao';
                      return DropdownMenuItem(
                        value: difficulty,
                        child: Text(label),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedDifficulty = value);
                      }
                    },
                  ),
                ),
                const SizedBox(height: AppSizes.s20),

                // Topic
                _buildLabel('Chủ đề'),
                const SizedBox(height: AppSizes.s8),
                TextFormField(
                  controller: _topicController,
                  decoration: InputDecoration(
                    hintText: 'VD: greetings, travel, food...',
                    filled: true,
                    fillColor: const Color(0xFFF7F7F7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(AppSizes.s16),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập chủ đề';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSizes.s20),

                // Card Count
                _buildLabel('Số lượng thẻ'),
                const SizedBox(height: AppSizes.s8),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (_cardCount > 1) {
                          setState(() => _cardCount--);
                        }
                      },
                      icon: const Icon(Icons.remove_circle_outline),
                      color: AppColors.primary,
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: AppSizes.s16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF7F7F7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '$_cardCount',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (_cardCount < 50) {
                          setState(() => _cardCount++);
                        }
                      },
                      icon: const Icon(Icons.add_circle_outline),
                      color: AppColors.primary,
                    ),
                  ],
                ),
                const SizedBox(height: AppSizes.s20),

                // Custom Prompt Toggle
                GestureDetector(
                  onTap: () {
                    setState(() => _showCustomPrompt = !_showCustomPrompt);
                  },
                  child: Row(
                    children: [
                      Icon(
                        _showCustomPrompt ? Icons.expand_less : Icons.expand_more,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: AppSizes.s8),
                      Text(
                        'Custom Prompt (Tùy chọn)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Custom Prompt Field
                if (_showCustomPrompt) ...[
                  const SizedBox(height: AppSizes.s12),
                  TextFormField(
                    controller: _customPromptController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Nhập yêu cầu tùy chỉnh cho AI...',
                      filled: true,
                      fillColor: const Color(0xFFF7F7F7),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.all(AppSizes.s16),
                    ),
                  ),
                ],

                const SizedBox(height: AppSizes.s40),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(AppSizes.s16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700, size: 20),
                      const SizedBox(width: AppSizes.s12),
                      Expanded(
                        child: Text(
                          'AI sẽ tạo $_cardCount flashcard về chủ đề "${ _topicController.text.isEmpty ? "..." : _topicController.text}" ở cấp độ $_selectedLevel',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
          ),
        ),
        // AI Loading Overlay - Outside Scaffold to cover full screen
        Positioned.fill(
          child: AILoadingOverlay(
            isVisible: _isGenerating,
            message: 'AI đang tạo ${_cardCount.round().toInt()} flashcard...',
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }
}
