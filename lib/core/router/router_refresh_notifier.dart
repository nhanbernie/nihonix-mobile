import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';

/// Notifier that listens to auth state changes and notifies GoRouter to refresh
class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this._ref) {
    // Listen to auth state changes
    _ref.listen(authProvider, (previous, next) {
      // Notify listeners (GoRouter) when auth state changes
      notifyListeners();
    });
  }

  final WidgetRef _ref;
}
