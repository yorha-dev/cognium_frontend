import 'dart:async';
import 'dart:js_interop';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:web/web.dart' as web;
import 'package:record/record.dart' as rec;

import 'package:cognium_frontend/error/error_handler.dart';

class TTSPlayer extends ChangeNotifier {
  final ErrorHandler errorHandler = ErrorHandler();

  web.HTMLAudioElement? _audio;
  String? _url;
  bool _state = false;
  int _id = 0;

  bool get isPlaying => _state;
  int get id => _id;

  void _cleanUp() {
    if (_url != null) {
      web.URL.revokeObjectURL(_url!);
    }

    _audio?.remove();

    _audio = null;
    _url = null;
    _id = 0;
  }

  Future<void> play(Uint8List data, int msgId) async {
    if (_state) stop();

    _id = msgId;

    final blob = web.Blob(
      [data.toJS].toJS,
      web.BlobPropertyBag(type: 'audio/wav'),
    );

    _url = web.URL.createObjectURL(blob);

    _audio = web.HTMLAudioElement()
      ..src = _url!
      ..controls = false;

    web.document.body!.append(_audio!);

    _audio!.onPlay.listen((_) {
      _state = true;
      notifyListeners();
    });

    _audio!.onError.listen((_) {
      errorHandler.register(
        AppError(
          category: ErrorCategory.internal,
          severity: ErrorSeverity.warning,
          code: 'AUDIO_PLAYER_ERROR',
          detail: 'Code: ${_audio!.error?.code}\n${_audio!.error?.message}',
          userMessage:
              "An error has ocurred on TTSPlayer; Code: ${_audio!.error?.code}.",
          source: 'TTSPlayer.play',
        ),
      );
    });

    _audio!.onPause.listen((_) {
      _state = false;
      notifyListeners();
    });

    _audio!.onEnded.listen((_) {
      _state = false;
      notifyListeners();

      _cleanUp();
    });

    await _audio!.play().toDart;
  }

  void stop() {
    _audio?.pause();
    _cleanUp();

    if (_state) {
      _state = false;
      notifyListeners();
    }
  }
}

class STTRecorder extends ChangeNotifier {
  final ErrorHandler errorHandler = ErrorHandler();

  rec.AudioRecorder? _recorder;
  StreamSubscription<Uint8List>? _subscription;
  bool _isRecording = false;
  final BytesBuilder _buffer = BytesBuilder();

  bool get isRecording => _isRecording;
  Uint8List? get data => _buffer.toBytes();

  Future<void> record() async {
    _recorder ??= rec.AudioRecorder();

    if (!await _recorder!.hasPermission()) {
      errorHandler.register(
        AppError(
          category: ErrorCategory.internal,
          severity: ErrorSeverity.warning,
          code: 'PERMISSION_DENIED',
          detail: 'Microphone permission denied',
          userMessage: "Microphone permission denied.",
          source: 'STTRecorder.record',
        ),
      );
      return;
    }

    _buffer.clear();

    final stream = await _recorder!.startStream(
      rec.RecordConfig(
        encoder: rec.AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
      ),
    );

    _isRecording = true;
    notifyListeners();

    _subscription = stream.listen(_buffer.add);
  }

  Future<void> stop() async {
    if (_recorder == null || !await _recorder!.isRecording()) {
      return;
    }

    await _recorder!.stop();

    await _subscription?.cancel();
    _subscription = null;

    _isRecording = false;
    notifyListeners();
  }

  @override
  void dispose() async {
    if (_recorder == null) {
      return;
    }

    if (await _recorder!.isRecording()) {
      stop();
    }

    await _recorder!.dispose();
    super.dispose();
  }
}
