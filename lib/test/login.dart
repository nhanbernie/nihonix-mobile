import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> loginRaw(String email, String password) async {
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
  try {
    final uri = Uri.parse('https://api.example.com/auth/login');

    // POST
    final req = await client.postUrl(uri);

    // BẮT BUỘC khi gửi JSON: content-type + accept
    req.headers
        .set(HttpHeaders.contentTypeHeader, 'application/json; charset=utf-8');
    req.headers.set(HttpHeaders.acceptHeader, 'application/json');

    // Viết body: add() nhận bytes → encode chuỗi JSON sang UTF8
    final body = jsonEncode({'email': email, 'password': password});
    req.add(utf8.encode(body));

    // Kết thúc ghi & nhận response
    final res = await req.close();

    if (res.statusCode != HttpStatus.ok &&
        res.statusCode != HttpStatus.created) {
      final err = await res.transform(utf8.decoder).join();
      throw HttpException('HTTP ${res.statusCode}: $err', uri: uri);
    }

    final text = await res.transform(utf8.decoder).join();
    return jsonDecode(text) as Map<String, dynamic>;
  } finally {
    client.close();
  }
}
