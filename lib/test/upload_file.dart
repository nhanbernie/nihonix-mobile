import 'dart:io';
import 'dart:convert';

Future<void> uploadAvatarRaw(
    File file, void Function(int sent, int total)? onProgress) async {
  final client = HttpClient();
  try {
    final uri = Uri.parse('https://api.example.com/upload');

    final req = await client.postUrl(uri);

    // Tự set boundary & content-type (viết tay multipart khá dài)
    final boundary =
        '----dartFormBoundary${DateTime.now().millisecondsSinceEpoch}';
    req.headers.set(HttpHeaders.contentTypeHeader,
        'multipart/form-data; boundary=$boundary');

    // Nếu biết trước kích thước, set contentLength để không dùng chunked
    // (không bắt buộc, nhưng server nào đó thích content-length)
    final fileBytes = await file.readAsBytes();
    final fields = <List<int>>[];

    // Phần field text (nếu có)
    void writeField(String name, String value) {
      fields.add(utf8.encode('--$boundary\r\n'));
      fields.add(
          utf8.encode('Content-Disposition: form-data; name="$name"\r\n\r\n'));
      fields.add(utf8.encode('$value\r\n'));
    }

    // Ví dụ thêm field
    writeField('userId', '123');

    // Phần file
    fields.add(utf8.encode('--$boundary\r\n'));
    fields.add(utf8.encode(
        'Content-Disposition: form-data; name="avatar"; filename="${file.uri.pathSegments.last}"\r\n'));
    fields.add(utf8.encode('Content-Type: image/jpeg\r\n\r\n'));
    fields.add(fileBytes);
    fields.add(utf8.encode('\r\n--$boundary--\r\n'));

    // Tính tổng bytes để báo progress
    final total = fields.fold<int>(0, (sum, chunk) => sum + chunk.length);
    var sent = 0;

    // Ghi từng chunk để báo tiến độ
    for (final chunk in fields) {
      req.add(chunk);
      sent += chunk.length;
      onProgress?.call(sent, total);
      // (tuỳ chọn) await Future<void>.delayed(Duration.zero); // nhường event loop
    }

    final res = await req.close();
    if (res.statusCode != HttpStatus.ok) {
      final err = await res.transform(utf8.decoder).join();
      throw HttpException('Upload fail ${res.statusCode}: $err', uri: uri);
    }
  } finally {
    client.close();
  }
}
