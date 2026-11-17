import 'package:flutter/foundation.dart';

import 'package:cognium_frontend/error/error_presenter.dart';

enum ErrorSeverity { info, warning, error, critical }

enum ErrorCategory { network, database, inference, file, internal, unknow }

class AppError {
  final String code;
  final ErrorCategory category;
  final ErrorSeverity severity;
  final String detail;
  final String userMessage;
  final DateTime timestamp;

  final String? source;
  final StackTrace? stackTrace;

  AppError({
    required this.code,
    required this.category,
    required this.severity,
    required this.detail,
    required this.userMessage,
    this.source,
    this.stackTrace,
  }) : timestamp = DateTime.now();
}

class ErrorHandler extends ChangeNotifier {
  static final ErrorHandler _instance = ErrorHandler._();
  final ErrorPresenter presenter = ErrorPresenter();
  final List<AppError> _queue = [];

  factory ErrorHandler() {
    return _instance;
  }

  ErrorHandler._();

  List<AppError> get queue => List.unmodifiable(_queue);

  bool get hasErrors => _queue.isNotEmpty;

  void register(AppError error) {
    _queue.add(error);

    debugPrint(
      '[${error.timestamp}] '
      '[${error.severity}] '
      '[${error.code}] '
      '${error.detail}',
    );

    if (presenter.showError(error, duration: Duration(seconds: 10))) {
      unregister();
    }

    notifyListeners();
  }

  void unregister() {
    if (_queue.isEmpty) return;

    _queue.removeAt(0);
    notifyListeners();
  }
}
