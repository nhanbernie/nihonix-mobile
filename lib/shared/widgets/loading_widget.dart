import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/constants/app_sizes.dart';

/// Loading widget cơ bản
class LoadingWidget extends StatelessWidget {
  final String? message;
  final Color? color;
  final double size;

  const LoadingWidget({
    super.key,
    this.message,
    this.color,
    this.size = AppSizes.iconLarge,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                color ?? Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSizes.s16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Full screen loading overlay
class FullScreenLoading extends StatelessWidget {
  final String? message;
  final bool isVisible;

  const FullScreenLoading({
    super.key,
    this.message,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!isVisible) return const SizedBox.shrink();

    return Container(
      color: Colors.black54,
      child: LoadingWidget(
        message: message ?? AppStrings.loading,
      ),
    );
  }
}

/// Card loading với shimmer effect
class CardLoadingWidget extends StatefulWidget {
  final double? height;
  final double? width;

  const CardLoadingWidget({
    super.key,
    this.height,
    this.width,
  });

  @override
  State<CardLoadingWidget> createState() => _CardLoadingWidgetState();
}

class _CardLoadingWidgetState extends State<CardLoadingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Container(
            height: widget.height ?? 100,
            width: widget.width ?? double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSizes.cardRadius),
              color: AppColors.greyLight.withValues(alpha: _animation.value),
            ),
          );
        },
      ),
    );
  }
}

/// List loading với multiple cards
class ListLoadingWidget extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ListLoadingWidget({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      separatorBuilder: (context, index) => const SizedBox(height: AppSizes.s8),
      itemBuilder: (context, index) => CardLoadingWidget(height: itemHeight),
    );
  }
}

/// Button loading state
class ButtonLoadingWidget extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const ButtonLoadingWidget({
    super.key,
    required this.text,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Text(text),
    );
  }
}
