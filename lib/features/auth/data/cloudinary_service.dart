import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class _CloudinarySignature {
  final String signature;
  final String timestamp;
  final String apiKey;
  final String cloudName;
  const _CloudinarySignature({
    required this.signature,
    required this.timestamp,
    required this.apiKey,
    required this.cloudName,
  });
}

class CloudinaryService {
  static const _baseUrl = String.fromEnvironment('API_URL',
      defaultValue: 'http://localhost:4000');

  static Future<String?> uploadImage(String imagePath) async {
    final sign = await _getSignature();
    if (sign == null) return null;

    final bytes = File(imagePath).readAsBytesSync();
    final boundary =
        '----FormBoundary${DateTime.now().millisecondsSinceEpoch}';

    final buf = BytesBuilder();
    void w(String s) => buf.add(utf8.encode(s));
    void field(String name, String value) {
      w('--$boundary\r\n');
      w('Content-Disposition: form-data; name="$name"\r\n\r\n');
      w('$value\r\n');
    }

    field('api_key', sign.apiKey);
    field('timestamp', sign.timestamp);
    field('signature', sign.signature);

    w('--$boundary\r\n');
    w('Content-Disposition: form-data; name="file"; filename="kyc.jpg"\r\n');
    w('Content-Type: image/jpeg\r\n\r\n');
    buf.add(bytes);
    w('\r\n--$boundary--\r\n');

    final client = HttpClient();
    try {
      final uri = Uri.parse(
          'https://api.cloudinary.com/v1_1/${sign.cloudName}/image/upload');
      final request = await client.postUrl(uri);
      request.headers.set(
          'Content-Type', 'multipart/form-data; boundary=$boundary');
      request.contentLength = buf.length;
      request.add(buf.toBytes());
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) return null;

      final data = jsonDecode(responseBody) as Map<String, dynamic>;
      return data['public_id'] as String?;
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }

  static Future<_CloudinarySignature?> _getSignature() async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('$_baseUrl/api/cloudinary/sign');
      final request = await client.postUrl(uri);
      request.headers.set('Content-Type', 'application/json');
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) return null;

      final data = jsonDecode(body) as Map<String, dynamic>;
      return _CloudinarySignature(
        signature: data['signature'] as String,
        timestamp: data['timestamp'] as String,
        apiKey: data['api_key'] as String,
        cloudName: data['cloud_name'] as String? ?? 'futurebank',
      );
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }
}
