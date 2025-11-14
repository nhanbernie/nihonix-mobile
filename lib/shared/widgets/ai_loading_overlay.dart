import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AILoadingOverlay extends StatefulWidget {
  final String message;
  final bool isVisible;
  final String? lottieUrl; // Optional custom Lottie URL

  const AILoadingOverlay({
    super.key,
    this.message = 'AI đang tạo flashcard...',
    this.isVisible = false,
    this.lottieUrl,
  });

  @override
  State<AILoadingOverlay> createState() => _AILoadingOverlayState();
}

class _AILoadingOverlayState extends State<AILoadingOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
    
    // Start animation if initially visible
    if (widget.isVisible) {
      _fadeController.forward();
    }
  }

  @override
  void didUpdateWidget(AILoadingOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible != oldWidget.isVisible) {
      if (widget.isVisible) {
        _fadeController.forward();
      } else {
        _fadeController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible && _fadeController.isDismissed) {
      return const SizedBox.shrink();
    }
    // NOTE: hiệu ứng modal
    // Only block interaction when visible
    return AbsorbPointer(
      absorbing: widget.isVisible,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          color: widget.isVisible ? Colors.black.withOpacity(0.7) : Colors.transparent,
          child: Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Lottie Animation - AI Robot or custom
              Lottie.network(
                widget.lottieUrl ?? 
                'https://assets2.lottiefiles.com/packages/lf20_xyadoh9h.json',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
                repeat: true,
                animate: true,
                errorBuilder: (context, error, stackTrace) {
                  // Fallback to custom animated widget
                  return const _AILoadingAnimation();
                },
              ),
              const SizedBox(height: 24),
              // Message
              Text(
                widget.message,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Vui lòng đợi trong giây lát...',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
        ),
        ),
      ),
    );
  }
}

// Fallback animated widget khi Lottie không load được
class _AILoadingAnimation extends StatefulWidget {
  const _AILoadingAnimation();

  @override
  State<_AILoadingAnimation> createState() => _AILoadingAnimationState();
}

class _AILoadingAnimationState extends State<_AILoadingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Rotating circles
          RotationTransition(
            turns: _controller,
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF6C63FF).withOpacity(0.3),
                  width: 3,
                ),
              ),
            ),
          ),
          RotationTransition(
            turns: Tween<double>(begin: 0, end: -1).animate(_controller),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF6C63FF).withOpacity(0.5),
                  width: 3,
                ),
              ),
            ),
          ),
          // AI Icon
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF6C63FF),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 28,
            ),
          ),
        ],
      ),
    );
  }
}
