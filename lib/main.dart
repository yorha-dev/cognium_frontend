import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:cognium_frontend/pages/proxy_page.dart';
import 'package:cognium_frontend/chat_controller.dart';
import 'package:cognium_frontend/media.dart';
import 'package:cognium_frontend/websocket/socket_controller.dart';
import 'package:cognium_frontend/error/error_handler.dart';
import 'package:cognium_frontend/keys.dart';

import 'package:cognium_frontend/themes/theme_manager.dart';
import 'package:cognium_frontend/themes/theme_registry.dart';
import 'package:cognium_frontend/themes/default_theme.dart';
import 'package:cognium_frontend/themes/app_theme.dart';

void main() {
  final themeRegistry = ThemeRegistry();
  themeRegistry.register(DefaultTheme());

  final themeManager = ThemeManager(registry: themeRegistry);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManager>.value(value: themeManager),
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
          create: (context) => SocketController(
            chatController: context.read<ChatController>(),
            errorHandler: context.read<ErrorHandler>(),
          ),
          update: (_, chat, error, socket) {
            return socket ??
                SocketController(chatController: chat, errorHandler: error);
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
    return Consumer<ThemeManager>(
      builder: (context, manager, child) {
        return MaterialApp(
          navigatorKey: AppKeys.navigationKey,
          home: const ProxyPage(),
          theme: manager.themes[ThemeVariants.light]!.themeData,
          darkTheme: manager.themes[ThemeVariants.dark]!.themeData,
          themeMode: manager.themeMode
        );
      },
    );
  }
}
