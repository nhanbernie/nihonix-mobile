import 'package:flutter/material.dart';
import '../../core/constants/app_sizes.dart';

/// Custom button widget với loading state
class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final bool isLoading;
  final ButtonStyle? style;
  final bool isOutlined;

  const CustomButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.style,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isOutlined) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: style,
        child: _buildChild(),
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: style,
      child: _buildChild(),
    );
  }

  Widget _buildChild() {
    if (isLoading) {
      return const SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }
    return child;
  }
}

/// Custom elevated button với icon
class CustomElevatedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final bool isLoading;
  final ButtonStyle? style;

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.isLoading = false,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = ElevatedButton.styleFrom(
      minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
    );

    final finalStyle = style != null ? defaultStyle.merge(style) : defaultStyle;

    if (icon != null && !isLoading) {
      return ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: finalStyle,
      );
    }

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: finalStyle,
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

/// Custom outlined button
class CustomOutlinedButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final IconData? icon;
  final ButtonStyle? style;

  const CustomOutlinedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.icon,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, AppSizes.buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
      ),
    );

    final finalStyle = style != null ? defaultStyle.merge(style) : defaultStyle;

    if (icon != null) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(text),
        style: finalStyle,
      );
    }

    return OutlinedButton(
      onPressed: onPressed,
      style: finalStyle,
      child: Text(text),
    );
  }
}
