import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:cognium_frontend/websocket.dart';
import 'package:cognium_frontend/chat_controller.dart';

class SocketController extends ChangeNotifier {
  final WebSocket _soc = WebSocket();
  final ChatController chatController;
  late final StreamSubscription _sub;
  int _chatId = 0;

  SocketController({required this.chatController}) {
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
              print('Unknow event type: ${data['type']}');
          }
        } catch (e) {
          print("Error: SocketController -> $e");
        }
      },
      onError: (error) {
        print('Error: SocketController -> WebSocket error: $error');
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

  // When ErrorHandler was implemented
  void _errorReceiver(Map<String, dynamic> data) {
    null;
  }
}
