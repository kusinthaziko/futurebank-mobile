import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

class _CloudinarySignature {
  final String signature;
  final String timestamp;
  final String apiKey;
  final String cloudName;
  final String folder;
  final String transformation;
  const _CloudinarySignature({
    required this.signature,
    required this.timestamp,
    required this.apiKey,
    required this.cloudName,
    required this.folder,
    this.transformation = '',
  });
}

class CloudinaryService {
  static const _baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://futurebank-api.onrender.com',
  );

  /// Upload an image with optional Cloudinary transformation.
  /// [transformation] e.g. "c_fill,w_800,h_600" for KYC docs
  static Future<String?> uploadImage(
    String imagePath, {
    String transformation = 'c_fill,w_800,h_600',
  }) async {
    final sign = await _getSignature(transformation: transformation);
    if (sign == null) return null;

    final bytes = File(imagePath).readAsBytesSync();
    final boundary = '----FormBoundary${DateTime.now().millisecondsSinceEpoch}';

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
    field('folder', sign.folder);
    if (sign.transformation.isNotEmpty) {
      field('transformation', sign.transformation);
    }

    w('--$boundary\r\n');
    w('Content-Disposition: form-data; name="file"; filename="kyc.jpg"\r\n');
    w('Content-Type: image/jpeg\r\n\r\n');
    buf.add(bytes);
    w('\r\n--$boundary--\r\n');

    final client = HttpClient();
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/${sign.cloudName}/image/upload',
      );
      final request = await client.postUrl(uri);
      request.headers.set(
        'Content-Type',
        'multipart/form-data; boundary=$boundary',
      );
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

  /// Upload an image and return the full secure URL.
  /// Used by the profile picture flow. Avatars get a square crop.
  static Future<String?> uploadImageAndGetUrl(
    String imagePath, {
    String transformation = 'c_fill,w_200,h_200',
  }) async {
    final sign = await _getSignature(transformation: transformation);
    if (sign == null) return null;

    final bytes = File(imagePath).readAsBytesSync();
    final boundary = '----FormBoundary${DateTime.now().millisecondsSinceEpoch}';

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
    field('folder', sign.folder);
    if (sign.transformation.isNotEmpty) {
      field('transformation', sign.transformation);
    }

    w('--$boundary\r\n');
    w('Content-Disposition: form-data; name="file"; filename="avatar.jpg"\r\n');
    w('Content-Type: image/jpeg\r\n\r\n');
    buf.add(bytes);
    w('\r\n--$boundary--\r\n');

    final client = HttpClient();
    try {
      final uri = Uri.parse(
        'https://api.cloudinary.com/v1_1/${sign.cloudName}/image/upload',
      );
      final request = await client.postUrl(uri);
      request.headers.set(
        'Content-Type',
        'multipart/form-data; boundary=$boundary',
      );
      request.contentLength = buf.length;
      request.add(buf.toBytes());
      final response = await request.close();
      final responseBody = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) return null;

      final data = jsonDecode(responseBody) as Map<String, dynamic>;
      return data['secure_url'] as String?;
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }

  static Future<_CloudinarySignature?> _getSignature({
    String transformation = '',
  }) async {
    final client = HttpClient();
    try {
      final uri = Uri.parse('$_baseUrl/api/cloudinary/sign');
      final request = await client.postUrl(uri);
      request.headers.set('Content-Type', 'application/json');
      request.write(
        jsonEncode({
          'folder': 'uploads',
          if (transformation.isNotEmpty) 'transformation': transformation,
        }),
      );
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();

      if (response.statusCode != 200) return null;

      final data = jsonDecode(body) as Map<String, dynamic>;
      return _CloudinarySignature(
        signature: data['signature'] as String,
        timestamp: data['timestamp'] as String,
        apiKey: data['api_key'] as String,
        cloudName: data['cloud_name'] as String? ?? 'futurebank',
        folder: data['folder'] as String? ?? 'uploads',
        transformation: data['transformation'] as String? ?? '',
      );
    } catch (_) {
      return null;
    } finally {
      client.close();
    }
  }
}
