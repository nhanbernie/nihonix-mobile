import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nihonix/core/constants/env_config.dart';
import 'package:nihonix/core/network/api_client.dart';
import 'package:nihonix/core/network/network_info.dart';
import 'package:nihonix/core/storage/token_store.dart';

/// Provider cho TokenStore
final tokenStoreProvider = Provider<TokenStore>((ref) {
  return SecureTokenStore();
});

/// Provider cho NetworkInfo
final networkInfoProvider = Provider<ConnectivityNetworkInfo>((ref) {
  return ConnectivityNetworkInfo();
});

final apiClientProvider = Provider<ApiClient>((ref) {
  final baseUrl = EnvConfig.apiBaseUrl;

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
