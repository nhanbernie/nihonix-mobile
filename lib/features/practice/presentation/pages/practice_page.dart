import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nihonix/core/constants/app_colors.dart';
import 'package:nihonix/core/constants/app_sizes.dart';
import 'package:nihonix/core/router/route_constants.dart';
import 'package:nihonix/features/practice/presentation/widgets/practice_mode_card.dart';
import 'package:nihonix/shared/widgets/common_app_bar.dart';

class PracticePage extends ConsumerWidget {
  const PracticePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: const CommonAppBar(
        title: 'Luyện tập',
      ),
      body: ListView(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top +
              kToolbarHeight +
              AppSizes.s12,
          left: AppSizes.s16,
          right: AppSizes.s16,
          bottom: MediaQuery.of(context).padding.bottom + 100,
        ),
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSizes.s20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFFF8A3D), // Primary
                  Color(0xFFFF6B35), // Darker orange
                  Color(0xFFFF4500), // Deep orange
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.psychology_rounded,
                  size: 48,
                  color: Colors.white,
                ),
                SizedBox(height: AppSizes.s12),
                Text(
                  'Luyện tập hàng ngày',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: AppSizes.s8),
                Text(
                  'Rèn luyện kỹ năng với các bài tập đa dạng',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSizes.s24),

          // Practice modes - 2x2 Grid
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PracticeModeCard(
                    title: 'Quiz nhanh',
                    subtitle: 'Trắc nghiệm từ vựng',
                    icon: Icons.quiz_rounded,
                    color: AppColors.accent1,
                    onTap: () {
                      context.push(AppRoutes.quizTopicSelection);
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PracticeModeCard(
                    title: 'Nghe và viết',
                    subtitle: 'Luyện kỹ năng nghe',
                    icon: Icons.headphones_rounded,
                    color: AppColors.primary,
                    onTap: () {
                      // TODO: Navigate to listening
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSizes.s12),
          Row(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PracticeModeCard(
                    title: 'Ghép câu',
                    subtitle: 'Luyện ngữ pháp',
                    icon: Icons.extension_rounded,
                    color: AppColors.accent3,
                    onTap: () {
                      // TODO: Navigate to sentence matching
                    },
                  ),
                ),
              ),
              const SizedBox(width: AppSizes.s12),
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: PracticeModeCard(
                    title: 'Viết Kanji',
                    subtitle: 'Luyện viết chữ Hán',
                    icon: Icons.draw_rounded,
                    color: AppColors.accent2,
                    onTap: () {
                      // TODO: Navigate to kanji writing
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
