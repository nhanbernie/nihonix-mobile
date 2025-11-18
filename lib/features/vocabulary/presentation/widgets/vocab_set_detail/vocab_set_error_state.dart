import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/features/vocabulary/presentation/providers/vocab_set_detail_provider.dart';

/// Error state widget for vocabulary set detail page
class VocabSetErrorState extends ConsumerWidget {
  final Object error;
  final String setId;
  final bool isDark;

  const VocabSetErrorState({
    super.key,
    required this.error,
    required this.setId,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[300],
          ),
          const SizedBox(height: AppSizes.s16),
          Text(
            'Error loading vocabulary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: AppSizes.s8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.s32),
            child: Text(
              error.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ),
          const SizedBox(height: AppSizes.s24),
          ElevatedButton.icon(
            onPressed: () {
              ref.invalidate(vocabSetDetailProvider(setId));
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
