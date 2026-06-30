import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/shared/widgets/common_app_bar.dart';
import 'package:nihonix/features/vocabulary/presentation/providers/vocab_set_detail_provider.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_set_detail/vocab_set_header.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_set_detail/vocab_set_item_list.dart';
import 'package:nihonix/features/vocabulary/presentation/widgets/vocab_set_detail/vocab_set_error_state.dart';

class VocabSetDetailPage extends ConsumerWidget {
  final String setId;
  final String setName;

  const VocabSetDetailPage({
    super.key,
    required this.setId,
    required this.setName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vocabSetAsync = ref.watch(vocabSetDetailProvider(setId));

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        systemNavigationBarColor:
            isDark ? const Color(0xFF1A1A1A) : Colors.white,
        systemNavigationBarIconBrightness:
            isDark ? Brightness.light : Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF1A1A1A) : Colors.white,
        appBar: const CommonAppBar(),
        body: vocabSetAsync.when(
          data: (vocabSet) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: VocabSetHeader(
                    vocabSet: vocabSet,
                    isDark: isDark,
                  ),
                ),
                VocabSetItemList(
                  items: vocabSet.items,
                  isDark: isDark,
                ),
              ],
            );
          },
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
          error: (error, stack) => VocabSetErrorState(
            error: error,
            setId: setId,
            isDark: isDark,
          ),
        ),
      ),
    );
  }
}
