import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/shared/widgets/glass_icon_button.dart';
import '../../data/models/create_flashcard_request.dart';
import '../../data/models/update_flashcard_request.dart';
import '../../data/models/card_content_model.dart';
import '../providers/flashcard_di.dart';
import '../providers/folder_sets_provider.dart';
import '../providers/set_cards_provider.dart';

class CardFormPage extends ConsumerStatefulWidget {
  final String folderId;
  final String? setId; // null = create new, not null = edit existing
  final String? setName; // Set name for edit mode

  const CardFormPage({
    super.key,
    required this.folderId,
    this.setId,
    this.setName,
  });

  @override
  ConsumerState<CardFormPage> createState() => _CardFormPageState();
}

class FlashcardItem {
  final String? id; // null = new card, not null = existing card
  final TextEditingController termController;
  final TextEditingController definitionController;

  FlashcardItem({
    this.id,
    String? term,
    String? definition,
  })  : termController = TextEditingController(text: term),
        definitionController = TextEditingController(text: definition);

  void dispose() {
    termController.dispose();
    definitionController.dispose();
  }
}

class _CardFormPageState extends ConsumerState<CardFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<FlashcardItem> _cards = [];
  bool _isSaving = false;
  bool _isLoading = false;

  bool get _isEditing => widget.setId != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      // Set initial title for edit mode
      if (widget.setName != null) {
        _titleController.text = widget.setName!;
      }
      _loadExistingData();
    } else {
      // Thêm 2 card mặc định cho create mode
      _addCard();
      _addCard();
    }
  }

  Future<void> _loadExistingData() async {
    setState(() => _isLoading = true);

    try {
      // Get cards data
      final cardsAsync = ref.read(setCardsProvider(widget.setId!));

      await cardsAsync.when(
        data: (cards) async {
          if (cards.isNotEmpty) {
            // Set title from first card's setName (if available)
            // Note: You might need to get set name from another API
            // For now, we'll leave it empty or get from route params

            // Load all cards
            setState(() {
              _cards.clear();
              for (var card in cards) {
                _cards.add(FlashcardItem(
                  id: card.id,
                  term: card.front.text,
                  definition: card.back.text,
                ));
              }
            });
          }
        },
        loading: () {},
        error: (error, stack) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Lỗi khi tải dữ liệu: $error'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    for (var card in _cards) {
      card.dispose();
    }
    super.dispose();
  }

  void _addCard() {
    setState(() {
      _cards.add(FlashcardItem());
    });
  }

  void _removeCard(int index) {
    if (_cards.length > 1) {
      setState(() {
        _cards[index].dispose();
        _cards.removeAt(index);
      });
    }
  }

  void _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      if (_isEditing) {
        // Update mode - use bulk update API
        final cards = _cards.asMap().entries.map((entry) {
          final index = entry.key;
          final card = entry.value;

          return UpdateFlashcardCardRequest(
            id: card.id, // null = create new, not null = update existing
            front: CardContentModel(
              text: card.termController.text.trim(),
              type: 'text',
            ),
            back: CardContentModel(
              text: card.definitionController.text.trim(),
              type: 'text',
            ),
            order: index + 1,
          );
        }).toList();

        // Call update use case
        final useCase = ref.read(updateFlashcardUseCaseProvider);
        await useCase(
          setId: widget.setId!,
          setName: _titleController.text.trim(),
          cards: cards,
        );

        // Refresh both sets list and cards list
        ref.invalidate(folderSetsProvider(widget.folderId));
        ref.invalidate(setCardsProvider(widget.setId!));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cập nhật bộ thẻ thành công'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      } else {
        // Create mode - use create API
        final cards = _cards.asMap().entries.map((entry) {
          final index = entry.key;
          final card = entry.value;

          return CardRequest(
            front: CardContentRequest(
              text: card.termController.text.trim(),
              type: 'text',
            ),
            back: CardContentRequest(
              text: card.definitionController.text.trim(),
              type: 'text',
            ),
            order: index + 1,
          );
        }).toList();

        // Call create use case
        final useCase = ref.read(createFlashcardUseCaseProvider);
        await useCase(
          folderId: widget.folderId,
          setName: _titleController.text.trim(),
          cards: cards,
        );

        // Refresh sets list
        ref.invalidate(folderSetsProvider(widget.folderId));

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tạo bộ thẻ học thành công'),
              backgroundColor: Colors.green,
            ),
          );
          context.pop();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_isEditing
                ? 'Lỗi khi cập nhật bộ thẻ: $e'
                : 'Lỗi khi tạo bộ thẻ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Đang tải...',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
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
            onPressed: () => context.pop(),
          ),
          title: Text(
            _isEditing ? 'Chỉnh sửa bộ thẻ' : 'Tạo bộ thẻ mới',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          centerTitle: true,
          actions: [
            _isSaving
                ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : TextButton(
                    onPressed: _handleSave,
                    child: Text(
                      'Lưu',
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
          child: Column(
            children: [
              // Title & Description Section (Fixed at top)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(AppSizes.s24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title Field
                    Text(
                      'TITLE',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: AppSizes.s8),
                    TextFormField(
                      controller: _titleController,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Subject, chapter, unit',
                        hintStyle: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade300,
                          fontWeight: FontWeight.normal,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Vui lòng nhập tiêu đề';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSizes.s4),
                    Divider(color: AppColors.primary, thickness: 2),

                    const SizedBox(height: AppSizes.s16),

                    // Description (Optional)
                    GestureDetector(
                      onTap: () {
                        // TODO: Show description input
                      },
                      child: Text(
                        '+ Description',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Divider(height: 1, color: Colors.grey.shade200),

              // Cards List (Scrollable)
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSizes.s16),
                  itemCount: _cards.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: AppSizes.s16),
                  itemBuilder: (context, index) => _buildCardItem(index),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: GlassIconButton(
          icon: Icons.add,
          onTap: _addCard,
          size: 64,
          iconSize: 32,
          backgroundColor: AppColors.primary.withValues(alpha: 0.9),
          iconColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCardItem(int index) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.s16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Header (Index + Delete button)
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSizes.s8,
                  vertical: AppSizes.s4,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '${index + 1}',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
              const Spacer(),
              if (_cards.length > 1)
                IconButton(
                  icon: Icon(Icons.delete_outline,
                      color: Colors.grey.shade400, size: 20),
                  onPressed: () => _removeCard(index),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
            ],
          ),

          const SizedBox(height: AppSizes.s12),

          // TERM Field
          Text(
            'TERM',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: _cards[index].termController,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập từ vựng, câu hỏi...',
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppSizes.s12),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập term';
                }
                return null;
              },
            ),
          ),

          const SizedBox(height: AppSizes.s12),

          // Divider
          Divider(height: 1, color: Colors.grey.shade300),

          const SizedBox(height: AppSizes.s12),

          // DEFINITION Field
          Text(
            'DEFINITION',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF7F7F7),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextFormField(
              controller: _cards[index].definitionController,
              maxLines: 2,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
              decoration: InputDecoration(
                hintText: 'Nhập định nghĩa, nghĩa...',
                hintStyle: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(AppSizes.s12),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Vui lòng nhập definition';
                }
                return null;
              },
            ),
          ),
        ],
      ),
    );
  }
}
