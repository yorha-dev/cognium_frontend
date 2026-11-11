import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cognium_frontend/websocket.dart';
import 'package:cognium_frontend/chat_controller.dart';
import 'package:cognium_frontend/error_handler.dart';

class SocketController extends ChangeNotifier {
  final WebSocket _soc = WebSocket();
  final ErrorHandler errorHandler;
  final ChatController chatController;
  late final StreamSubscription _sub;
  int _chatId = 0;

  SocketController({required this.chatController, required this.errorHandler}) {
    _sub = _soc.events.listen(
      (event) {
        try {
          final data = jsonDecode(event);

          if (data is! Map<String, dynamic>) {
            return;
          }

          final content = data['content'];

          if (content is! Map<String, dynamic>) {
            return;
          }

          switch (data['type']) {
            case 'content':
              _chatCtrlReceiver(content);
              break;
            case 'error':
              _errorReceiver(content);
              break;
            default:
              errorHandler.register(
                AppError(
                  category: ErrorCategory.unknow,
                  severity: ErrorSeverity.warning,
                  code: 'UNKNOW_EVENT_TYPE',
                  detail: 'Unknow event type: ${data['type']}',
                  userMessage: 'Unknow event type received.',
                  source: 'SocketController',
                ),
              );
          }
        } catch (e) {
          errorHandler.register(
            AppError(
              category: ErrorCategory.internal,
              severity: ErrorSeverity.error,
              code: 'DATA_PROCESS_ERROR',
              detail: '$e',
              userMessage: 'Something went wrong.',
              source: 'SocketController',
              stackTrace: StackTrace.current,
            ),
          );
        }
      },
      onError: (error) {
        errorHandler.register(
          AppError(
            category: ErrorCategory.network,
            severity: ErrorSeverity.error,
            code: 'WEBSOCKET_CONNECTION_ERROR',
            detail: '$error',
            userMessage: 'An error ocurred on WebSocket comunication',
            source: 'SocketController',
            stackTrace: StackTrace.current,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _sub.cancel();
    _soc.dispose();

    super.dispose();
  }

  void setChatIdToServe(int id) {
    if (id == _chatId) return;

    _chatId = id;
  }

  void _chatCtrlReceiver(Map<String, dynamic> data) {
    if (data.containsKey('chat_id') && data.containsKey('new_id')) {
      chatController.updateChatList();

      if (data['chat_id'] == chatController.chatIndex) {
        chatController.modifyIndex(data['new_id']);

        chatController.generating(data['new_id']);
      }
    }

    if (data.containsKey('status')) {
      final chat = chatController.chatList
          .where((e) => e.id == data['chat_id'])
          .first;

      if (data['status'] == 'generating' && chat.isGenerating == false) {
        chatController.generating(chat.id!);
      }

      if (data['status'] == 'completed') {
        chatController.stopGenerating(chat.id!);
      }
    }
  }

  void _errorReceiver(Map<String, dynamic> data) {
    errorHandler.register(AppError(
      category: switch (data['category']) {
        'network' => ErrorCategory.network,
        'database' => ErrorCategory.database,
        'inference' => ErrorCategory.inference,
        'file' => ErrorCategory.file,
        'internal' => ErrorCategory.internal,
        _ => ErrorCategory.unknow
      },
      severity: switch (data['severity']) {
        'info' => ErrorSeverity.info,
        'warning' => ErrorSeverity.warning,
        'error' => ErrorSeverity.error,
        'critical' => ErrorSeverity.critical,
        _ => ErrorSeverity.info
      },
      code: data['code'] ?? 'UNKNOW',
      detail: data['detail'] ?? '',
      userMessage: data['description'] ?? '',
      source: data['source'] ?? '',
      stackTrace: data['traceback']
    ));
  }
}
