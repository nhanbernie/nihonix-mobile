import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

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

class _CardFormPageState extends State<CardFormPage> {
  final _formKey = GlobalKey<FormState>();
  final _frontController = TextEditingController();
  final _backController = TextEditingController();

  bool get _isEditing => widget.cardId != null;

  @override
  void dispose() {
    _frontController.dispose();
    _backController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // TODO: Save flashcard
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã lưu thẻ học'),
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
            _isEditing ? 'Chỉnh sửa thẻ' : 'Tạo thẻ mới',
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
          child: ListView(
            padding: const EdgeInsets.all(AppSizes.s24),
            children: [
              // Front Side
              _buildCardSection(
                title: 'Mặt trước',
                subtitle: 'Từ vựng hoặc câu hỏi',
                controller: _frontController,
                hintText: 'Ví dụ: 犬',
                maxLines: 3,
              ),

              const SizedBox(height: AppSizes.s32),

              // Divider with flip icon
              Row(
                children: [
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSizes.s16),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.flip,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: Colors.grey.shade300)),
                ],
              ),

              const SizedBox(height: AppSizes.s32),

              // Back Side
              _buildCardSection(
                title: 'Mặt sau',
                subtitle: 'Nghĩa hoặc câu trả lời',
                controller: _backController,
                hintText: 'Ví dụ: inu - con chó',
                maxLines: 5,
              ),

              const SizedBox(height: AppSizes.s40),

              // Tips
              Container(
                padding: const EdgeInsets.all(AppSizes.s16),
                decoration: BoxDecoration(
                  color: AppColors.accent4.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.lightbulb_outline,
                      size: 20,
                      color: AppColors.accent4.withValues(alpha: 0.8),
                    ),
                    const SizedBox(width: AppSizes.s12),
                    Expanded(
                      child: Text(
                        'Mẹo: Mặt trước nên ngắn gọn, mặt sau có thể chi tiết hơn với ví dụ và giải thích',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade700,
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
    );
  }

  Widget _buildCardSection({
    required String title,
    required String subtitle,
    required TextEditingController controller,
    required String hintText,
    required int maxLines,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: AppSizes.s4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 13,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: AppSizes.s12),

        // Input Field
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextFormField(
            controller: controller,
            maxLines: maxLines,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade400,
              ),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              contentPadding: const EdgeInsets.all(AppSizes.s16),
            ),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Vui lòng nhập nội dung';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}

