import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/network/api_client.dart';
import 'package:nihonix/core/network/network_info.dart';
import 'package:nihonix/core/storage/token_store.dart';

/// Provider cho TokenStore
final tokenStoreProvider = Provider<HiveTokenStore>((ref) {
  return HiveTokenStore();
});

/// Provider cho NetworkInfo
final networkInfoProvider = Provider<ConnectivityNetworkInfo>((ref) {
  return ConnectivityNetworkInfo();
});

/// Provider cho ApiClient
/// 
/// Sử dụng:
/// ```dart
/// final apiClient = ref.read(apiClientProvider);
/// final response = await apiClient.dio.get('/users/me');
/// ```
final apiClientProvider = Provider<ApiClient>((ref) {
  // TODO: Thay đổi baseUrl theo environment
  const baseUrl = 'https://api.example.com';

  return ApiClient(
    baseUrl: baseUrl,
    tokenStore: ref.read(tokenStoreProvider),
    networkInfo: ref.read(networkInfoProvider),
    onUnauthorized: () async {
      // TODO: Navigate to login screen
      // ref.read(routerProvider).go('/login');
    },
  );
});

