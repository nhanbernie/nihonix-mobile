import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:lottie/lottie.dart';

class LevelSuccessDialog extends StatelessWidget {
  final String levelCode;
  final String levelName;
  final Color levelColor;

  const LevelSuccessDialog({
    super.key,
    required this.levelCode,
    required this.levelName,
    required this.levelColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Lottie success animation
          Lottie.asset(
            'assets/animations/success.json',
            width: 120,
            height: 120,
            repeat: false,
            animate: true,
            // Fallback to network if local asset not found
            errorBuilder: (context, error, stackTrace) {
              return Lottie.network(
                'https://assets3.lottiefiles.com/packages/lf20_touohxv0.json',
                width: 120,
                height: 120,
                repeat: false,
                animate: true,
                errorBuilder: (context, error, stackTrace) {
                  // Final fallback to icon
                  return Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: levelColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 80,
                      color: levelColor,
                    ),
                  );
                },
              );
            },
          ),

          const SizedBox(height: 16),

          // Success text
          Text(
            'Cập nhật thành công!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 20),

          // Level badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  levelColor,
                  levelColor.withValues(alpha: 0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: levelColor.withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Text(
                  '$levelCode - $levelName',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Close button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () => SmartDialog.dismiss(),
              style: ElevatedButton.styleFrom(
                backgroundColor: levelColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: const Text(
                'Đóng',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
