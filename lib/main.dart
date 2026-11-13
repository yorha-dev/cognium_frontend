import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cognium_frontend/pages/proxy_page.dart';
import 'package:cognium_frontend/chat_controller.dart';
import 'package:cognium_frontend/media.dart';
import 'package:cognium_frontend/websocket/socket_controller.dart';
import 'package:cognium_frontend/error_handler.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ErrorHandler()),
        ChangeNotifierProvider(create: (context) => ChatController()),
        ChangeNotifierProvider(create: (context) => TTSPlayer()),
        ChangeNotifierProvider(create: (context) => STTRecorder()),
        ChangeNotifierProxyProvider2<
          ChatController,
          ErrorHandler,
          SocketController
        >(
          lazy: false,
          create: (context) =>
              SocketController(
                chatController: context.read<ChatController>(),
                errorHandler: context.read<ErrorHandler>()
              ),
          update: (_, chat, error, socket) {
            return socket ?? SocketController(
              chatController: chat,
              errorHandler: error
            );
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
