import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/flashcard.dart';
import 'flashcard_di.dart';

/// Provider to fetch cards for a specific set
/// Uses GetCardsInSetUseCase following Clean Architecture
final setCardsProvider = FutureProvider.family<List<Flashcard>, String>(
  (ref, setId) async {
    final useCase = ref.watch(getCardsInSetUseCaseProvider);
    return await useCase(setId);
  },
);

