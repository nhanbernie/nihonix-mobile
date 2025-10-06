import 'dart:io';

Future<File> downloadToFile(String url, File out) async {
  final client = HttpClient();
  try {
    final uri = Uri.parse(url);
    final req = await client.getUrl(uri);
    final res = await req.close();

    if (res.statusCode != HttpStatus.ok) {
      throw HttpException('HTTP ${res.statusCode}', uri: uri);
    }

    final sink = out.openWrite(); // StreamSink<List<int>>
    // Uncomment below lines to enable progress tracking:
    // final total = res.contentLength; // có thể là -1 nếu server không báo
    // var received = 0;

    await for (final chunk in res) {
      // received += chunk.length;
      sink.add(chunk);
      // print progress
      // if (total > 0) {
      //   final p = ((received / total) * 100).toStringAsFixed(1);
      //   print('Progress: $p%');
      // }
    }
    await sink.flush();
    await sink.close();
    return out;
  } finally {
    client.close();
  }
}
