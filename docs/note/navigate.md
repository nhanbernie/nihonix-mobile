. Provider - Return result:
Future<VocabGenerateResult?> generateVocabularyItems(...) async {  try {    final result = await useCase(...);    state = state.copyWith(result: result, ...);    return result; // ← Return result!  } catch (e) {    return null; // ← Return null on error  }}
2. Form - Receive result và navigate:
// Lưu contexts trước khi popfinal navigator = Navigator.of(context);final router = GoRouter.of(context);final notifier = ref.read(vocabGenerateProvider.notifier);navigator.pop(); // Close dialog// Await và nhận resultfinal result = await notifier.generateVocabularyItems(...);if (result != null) {  // Success - có data!  final setId = result.setId;  final setTitle = result.getSetTitleByLanguage('en');    // Reload & navigate  await vocabNotifier.loadVocabSetsByTopic(topicId);  notifier.clearResult();    router.push('/vocab-detail?setId=$setId&...'); // ← Navigate!}
Tại sao cách này hoàn hảo:
✅ Có result để navigate - Method return result
✅ Không dùng ref sau unmount - Lưu notifiers trước
✅ Router context valid - Lưu trước khi pop
✅ Đơn giản - Straight-forward async flow
✅ Clean - Không listener, không polling, không callback
Bây giờ sẽ navigate được rồi! 🎉🚀