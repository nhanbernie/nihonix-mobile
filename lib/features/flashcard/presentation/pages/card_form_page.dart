import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../../shared/widgets/glass_icon_button.dart';

class CardFormPage extends StatefulWidget {
  final String folderId;
  final String? cardId; // null = create new, not null = edit existing

  const CardFormPage({
    super.key,
    required this.folderId,
    this.cardId,
  });

  @override
  State<CardFormPage> createState() => _CardFormPageState();
}

class FlashcardItem {
  final TextEditingController termController;
  final TextEditingController definitionController;

  FlashcardItem({
    String? term,
    String? definition,
  })  : termController = TextEditingController(text: term),
        definitionController = TextEditingController(text: definition);

  void dispose() {
    termController.dispose();
    definitionController.dispose();
  }
}

class _CardFormPageState extends State<CardFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final List<FlashcardItem> _cards = [];

  bool get _isEditing => widget.cardId != null;

  @override
  void initState() {
    super.initState();
    // Thêm 2 card mặc định
    _addCard();
    _addCard();
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

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // TODO: Save flashcard set with multiple cards
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu bộ thẻ học'),
        backgroundColor: Colors.green,
      ),
    );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
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
            TextButton(
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
                  separatorBuilder: (context, index) => const SizedBox(height: AppSizes.s16),
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
                  icon: Icon(Icons.delete_outline, color: Colors.grey.shade400, size: 20),
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

