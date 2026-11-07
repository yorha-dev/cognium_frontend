import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cognium_frontend/proxy_page.dart';
import 'package:cognium_frontend/chat_controller.dart';
import 'package:cognium_frontend/media.dart';
import 'package:cognium_frontend/socket_controller.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ChatController()),
        ChangeNotifierProvider(create: (context) => TTSPlayer()),
        ChangeNotifierProvider(create: (context) => STTRecorder()),
        ChangeNotifierProxyProvider<ChatController, SocketController>(
          lazy: false,
          create: (context) =>
              SocketController(chatController: context.read<ChatController>()),
          update: (_, chat, socket) {
            return socket ?? SocketController(chatController: chat);
          },
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ProxyPage());
  }
}
