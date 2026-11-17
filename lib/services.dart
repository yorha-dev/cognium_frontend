import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import 'package:cognium_frontend/objects.dart';
import 'package:cognium_frontend/error/error_handler.dart';

Future<dynamic> fetchData(
  String endpoint,
  String method, {
  Map<String, dynamic>? data,
}) async {
  final request = http.Request(
    method.toUpperCase(),
    Uri.base.resolve(endpoint),
  );

  if (data != null) {
    request.bodyBytes = utf8.encode(jsonEncode(data));
    request.headers['content-type'] = "application/json";
  }

  try {
    final response = await request.send();

    if (response.statusCode == 200 || response.statusCode == 201) {
      await for (final data in response.stream.transform(utf8.decoder)) {
        return jsonDecode(data);
      }
    } else {
      return {'detail': "Failed to fetch data\nCode: ${response.statusCode}"};
    }
  } catch (e) {
    ErrorHandler().register(
      AppError(
        category: ErrorCategory.network,
        severity: ErrorSeverity.error,
        code: 'DATA_FETCH_ERROR',
        detail: '$e',
        userMessage: "An error has ocurred while fetching data.",
        source: 'fetchData',
      ),
    );

    return {'detail': 'Failed to connect to the server. Error: $e'};
  }
}

Future<dynamic> uploadAudio(Uint8List data) async {
  final request = http.MultipartRequest('POST', Uri.base.resolve('/stt'));

  request.files.add(
    http.MultipartFile.fromBytes('audio', data, filename: 'audio.pcm'),
  );

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.bytesToString();
      return jsonDecode(body);
    } else {
      return {'detail': "Audio upload has failed\nCode ${response.statusCode}"};
    }
  } catch (e) {
    ErrorHandler().register(
      AppError(
        category: ErrorCategory.network,
        severity: ErrorSeverity.error,
        code: 'AUDIO_UPLOAD_ERROR',
        detail: '$e',
        userMessage: "An error has ocurred while uploading audio data.",
        source: 'uploadAudio',
      ),
    );

    return {'detail': "Failed to send audio -> $e"};
  }
}

Future<dynamic> uploadFile(List<AttachmentLocal> files) async {
  final request = http.MultipartRequest('POST', Uri.base.resolve('/uploads'));

  for (final file in files) {
    request.files.add(
      http.MultipartFile(
        'data',
        http.ByteStream(Stream.value(file.data!)),
        file.size,
        filename: file.name,
      ),
    );
  }

  try {
    final response = await request.send();
    if (response.statusCode == 200) {
      final body = await response.stream.transform(utf8.decoder).join();
      return jsonDecode(body);
    } else {
      return {'detail': "File upload has failed\nCode ${response.statusCode}"};
    }
  } catch (e) {
    ErrorHandler().register(
      AppError(
        category: ErrorCategory.network,
        severity: ErrorSeverity.error,
        code: 'FILE_UPLOAD_ERROR',
        detail: '$e',
        userMessage: "An error has ocurred while file(s) data.",
        source: 'uploadFile',
      ),
    );

    return {'detail': "Failed to send archives -> $e"};
  }
}

Future<AttachmentRemote> getFile(String fileName) async {
  final request = http.Request('GET', Uri.base.resolve('/uploads/$fileName'));

  final response = await request.send();

  if (response.statusCode != 200) {
    throw Exception("Failed to get data: Code => ${response.statusCode}");
  }

  final bytes = await response.stream.toBytes();

  return AttachmentRemote(
    id: int.parse(response.headers['attachment-id']!),
    name: response.headers['file-name']!,
    size: int.parse(response.headers['content-length']!),
    data: bytes,
  );
}

Future<Uint8List?> fetchTTSData({
  required int chatId,
  required int msgId,
}) async {
  final request = http.Request('POST', Uri.base.resolve('/tts'));

  request.headers['content-type'] = 'application/json';

  request.body = jsonEncode({'chat_id': chatId, 'msg_id': msgId});

  try {
    final response = await request.send();

    if (response.statusCode == 200) {
      return await response.stream.toBytes();
    }

    return null;
  } catch (e) {
    ErrorHandler().register(
        AppError(
          category: ErrorCategory.network,
          severity: ErrorSeverity.warning,
          code: 'DATA_FETCH_ERROR',
          detail: '$e',
          userMessage:
              "An error has ocurred while retrieving TTS data.",
          source: 'fetchTTSData',
        )
      );

    return null;
  }
}
