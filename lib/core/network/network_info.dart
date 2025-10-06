import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nihonix/core/network/auth_interceptor.dart';

/// Implementation của NetworkInfo sử dụng connectivity_plus.
///
/// Kiểm tra kết nối mạng trước khi gửi request để:
/// - Tránh timeout không cần thiết
/// - Hiển thị thông báo lỗi rõ ràng cho user
/// - Tiết kiệm battery và data
class ConnectivityNetworkInfo implements NetworkInfo {
  final Connectivity _connectivity;

  ConnectivityNetworkInfo([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();

    // Trả về true nếu có bất kỳ kết nối nào (wifi, mobile, ethernet)
    return result.contains(ConnectivityResult.wifi) ||
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.ethernet);
  }

  /// Stream để lắng nghe thay đổi trạng thái mạng (optional)
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map((results) {
      return results.contains(ConnectivityResult.wifi) ||
          results.contains(ConnectivityResult.mobile) ||
          results.contains(ConnectivityResult.ethernet);
    });
  }
}
