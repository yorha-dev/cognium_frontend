import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:cognium_frontend/objects.dart';
import 'package:cognium_frontend/services.dart';

class ChatController extends ChangeNotifier {
  final List<Chat> _chatList = [];
  int _chatIndex = 0;
  String _selectedModel = '';

  ChatController() {
    updateChatList();
    getSelectedModel();
  }

  @override
  void dispose() {
    // _sub.cancel();

    super.dispose();
  }

  List<Chat> get chatList => _chatList;
  int get chatIndex => _chatIndex;
  String get selectedModel => _selectedModel;

  void setSelectedModel(String model) {
    _selectedModel = model;

    notifyListeners();
  }

  void generating(int chatId) {
    final result = _chatList.where((chat) => chat.id == chatId);
    if (result.isNotEmpty) {
      result.first.isGenerating = true;
      notifyListeners();
    }
  }

  void stopGenerating(int chatId) {
    final result = _chatList.where((chat) => chat.id == chatId);
    if (result.isNotEmpty) {
      result.first.isGenerating = false;
      notifyListeners();
    }
  }

  Future<void> getSelectedModel() async {
    try {
      final result = await fetchData('/config', 'GET') as Map;

      if (!result.containsKey('detail')) {
        _selectedModel = result['llm_model'];
        notifyListeners();
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateChatList() async {
    try {
      final result = await fetchData('/chat', 'GET');

      if (result is List && _chatList.length < result.length) {
        final slice = _chatList.isEmpty
            ? result
            : result.sublist(_chatList.length);

        for (final item in slice) {
          if (item.containsKey('id') &&
              item.containsKey('title') &&
              item.containsKey('timestamp')) {
            _chatList.add(
              Chat(
                id: item['id'],
                title: item['title'],
                timestamp: item['timestamp'],
                isGenerating: false,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('Error: $e'); // Show it on UI
    }

    notifyListeners();
  }

  void modifyIndex(int index) {
    if (_chatIndex == index) return;

    _chatIndex = index;

    notifyListeners();
  }
}
