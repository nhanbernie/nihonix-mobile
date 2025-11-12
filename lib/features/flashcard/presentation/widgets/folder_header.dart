import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class FolderHeader extends StatefulWidget {
  final String folderName;
  final String? folderDescription;
  final bool isEditable;
  final TextEditingController? nameController;
  final TextEditingController? descriptionController;

  const FolderHeader({
    super.key,
    required this.folderName,
    this.folderDescription,
    this.isEditable = false,
    this.nameController,
    this.descriptionController,
  });

  @override
  State<FolderHeader> createState() => _FolderHeaderState();
}

class _FolderHeaderState extends State<FolderHeader> {
  bool _isEditingName = false;
  bool _isEditingDescription = false;
  late FocusNode _nameFocusNode;
  late FocusNode _descriptionFocusNode;

  @override
  void initState() {
    super.initState();
    if (widget.isEditable) {
      _nameFocusNode = FocusNode();
      _descriptionFocusNode = FocusNode();

      _nameFocusNode.addListener(_handleNameFocusChange);
      _descriptionFocusNode.addListener(_handleDescriptionFocusChange);
    }
  }

  void _handleNameFocusChange() {
    if (!_nameFocusNode.hasFocus && _isEditingName) {
      setState(() => _isEditingName = false);
    }
  }

  void _handleDescriptionFocusChange() {
    if (!_descriptionFocusNode.hasFocus && _isEditingDescription) {
      setState(() => _isEditingDescription = false);
    }
  }

  @override
  void dispose() {
    if (widget.isEditable) {
      _nameFocusNode.removeListener(_handleNameFocusChange);
      _descriptionFocusNode.removeListener(_handleDescriptionFocusChange);
      _nameFocusNode.dispose();
      _descriptionFocusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSizes.s24),
      child: Column(
        children: [
          const SizedBox(height: AppSizes.s16),
          // Folder Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF5F5F5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.folder_rounded,
              size: 40,
              color: AppColors.primary.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: AppSizes.s16),
          
          // Folder Name (Editable or Static)
          _buildNameField(),
          
          const SizedBox(height: AppSizes.s12),

          // Folder Description (Editable or Static)
          if (widget.isEditable) _buildDescriptionField(),
          
          const SizedBox(height: AppSizes.s24),
        ],
      ),
    );
  }

  Widget _buildNameField() {
    if (widget.isEditable && _isEditingName) {
      return TextField(
        controller: widget.nameController,
        focusNode: _nameFocusNode,
        textAlign: TextAlign.center,
        autofocus: true,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'Nhập tên folder',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s12,
          ),
        ),
        onSubmitted: (_) {
          setState(() => _isEditingName = false);
        },
      );
    }

    return GestureDetector(
      onTap: widget.isEditable
          ? () {
              setState(() => _isEditingName = true);
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _nameFocusNode.requestFocus();
              });
            }
          : null,
      child: Container(
        padding: widget.isEditable
            ? const EdgeInsets.symmetric(
                horizontal: AppSizes.s12,
                vertical: AppSizes.s8,
              )
            : null,
        decoration: widget.isEditable
            ? BoxDecoration(
                border: Border.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.nameController?.text ?? widget.folderName,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (widget.isEditable) ...[
              const SizedBox(width: AppSizes.s8),
              Icon(
                Icons.edit,
                size: 18,
                color: Colors.grey.shade600,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDescriptionField() {
    if (_isEditingDescription) {
      return TextField(
        controller: widget.descriptionController,
        focusNode: _descriptionFocusNode,
        textAlign: TextAlign.center,
        autofocus: true,
        maxLines: 3,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade600,
        ),
        decoration: InputDecoration(
          hintText: 'Nhập mô tả (tùy chọn)',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.primary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSizes.s16,
            vertical: AppSizes.s12,
          ),
        ),
        onSubmitted: (_) {
          setState(() => _isEditingDescription = false);
        },
      );
    }

    return GestureDetector(
      onTap: () {
        setState(() => _isEditingDescription = true);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _descriptionFocusNode.requestFocus();
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.s12,
          vertical: AppSizes.s8,
        ),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(
                widget.descriptionController?.text.isEmpty ?? true
                    ? 'Thêm mô tả'
                    : widget.descriptionController!.text,
                style: TextStyle(
                  fontSize: 14,
                  color: widget.descriptionController?.text.isEmpty ?? true
                      ? Colors.grey.shade400
                      : Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: AppSizes.s8),
            Icon(
              Icons.edit,
              size: 16,
              color: Colors.grey.shade600,
            ),
          ],
        ),
      ),
    );
  }
}
