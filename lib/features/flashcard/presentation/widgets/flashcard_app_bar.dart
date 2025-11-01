import 'dart:ui';

import 'package:flutter/material.dart';

class FlashcardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onAddPressed;

  const FlashcardAppBar({
    super.key,
    required this.onAddPressed,
  });

  // giảm heigh so với status bar 
  // toolbarHeight: 80px → 64px
  // preferredSize: 80 → 64
  // Padding top/bottom: 12px → 8px
  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      toolbarHeight: 64,
      backgroundColor: Colors.transparent,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      forceMaterialTransparency: true,
      title: const Padding(
        padding: EdgeInsets.only(left: 20.0),
        child: Text(
          'Flashcard',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
              left: 12.0, top: 8.0, right: 36.0, bottom: 8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey.shade300),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: onAddPressed,
                    child: const Center(
                      child: Icon(Icons.add_rounded,
                          color: Colors.black, size: 20),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

