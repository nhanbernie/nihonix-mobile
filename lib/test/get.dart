import 'dart:async';
import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> getUserRaw() async {
  // 1) Tạo client cấp app (nên tái sử dụng, đừng tạo mỗi lần 1 cái)
  final client = HttpClient()
    ..connectionTimeout = const Duration(seconds: 10) // timeout cho kết nối TCP
    ..idleTimeout = const Duration(seconds: 15) // giữ kết nối rảnh tối đa
    ..autoUncompress = true; // giải nén nếu server gửi gzip

  try {
    // 2) Tạo Uri với query params "đúng chuẩn" (tránh nối chuỗi thủ công)
    final uri = Uri.https('api.example.com', '/users/1', {
      'include': 'profile,settings',
    });

    // 3) Mở request GET tới uri → trả về HttpClientRequest
    final HttpClientRequest req = await client.getUrl(uri);

    // 4) Gắn header (dùng constants để tránh sai chính tả)
    req.headers.set(HttpHeaders.acceptHeader, 'application/json');
    req.headers.set(HttpHeaders.userAgentHeader, 'MyApp/1.0 (Flutter)');

    // 5) Gửi request đi: close() sẽ "kết thúc ghi" và bắt đầu nhận response
    final HttpClientResponse res = await req
        .close()
        .timeout(const Duration(seconds: 20)); // timeout nhận phản hồi

    // 6) Kiểm tra mã trạng thái chuẩn (dùng HttpStatus constants cho dễ đọc)
    if (res.statusCode != HttpStatus.ok) {
      // Có thể đọc body lỗi để log/debug
      final errorText = await res.transform(utf8.decoder).join();
      throw HttpException('HTTP ${res.statusCode}: $errorText', uri: uri);
    }

    // 7) res là Stream<List<int>> → decode UTF8 → join về String
    final String text = await res.transform(utf8.decoder).join();

    // 8) Parse JSON
    final data = jsonDecode(text) as Map<String, dynamic>;
    return data;
  } on TimeoutException {
    throw Exception('Timeout khi gọi API');
  } on SocketException catch (e) {
    // Lỗi network/DNS
    throw Exception('Lỗi mạng: $e');
  } finally {
    // 9) Đóng client khi KHÔNG còn dùng nữa (nếu bạn giữ client dùng chung app thì đừng close ở đây)
    client.close(force: false);
  }
}
