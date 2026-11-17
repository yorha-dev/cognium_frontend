import 'dart:async';

import 'package:flutter/material.dart';

import 'package:cognium_frontend/error/error_handler.dart';
import 'package:cognium_frontend/widgets/overlay.dart';
import 'package:cognium_frontend/keys.dart';

class NotificationData {
  final int id;
  final AppError notification;

  NotificationData({required this.id, required this.notification});
}

class ErrorPresenter {
  static final ErrorPresenter _instance = ErrorPresenter._();
  final GlobalKey<NavigatorState> _navKey = AppKeys.navigationKey;
  final ValueNotifier<List<NotificationData>> _notifications = ValueNotifier(
    [],
  );
  final Map<int, Timer> _timers = {};

  OverlayEntry? _overlayEntry;

  int _nextId = 0;

  static const int maxNotifications = 4;

  factory ErrorPresenter() {
    return _instance;
  }

  ErrorPresenter._();

  bool showError(
    AppError notification, {
    Duration? duration = const Duration(seconds: 5),
  }) {
    final overlay = _navKey.currentState?.overlay;

    if (overlay == null) return false;

    _ensureOverlay(overlay);

    final notify = NotificationData(id: _nextId++, notification: notification);

    if (_notifications.value.length >= maxNotifications) {
      _remove(_notifications.value.first.id);
    }

    _notifications.value = [..._notifications.value, notify];

    if (duration != null) {
      _timers[notify.id] = Timer(duration, () => dismiss(notify.id));
    }

    return true;
  }

  void _ensureOverlay(OverlayState overlay) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: ValueListenableBuilder<List<NotificationData>>(
                  valueListenable: _notifications,
                  builder: (context, notifications, _) {
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: notifications.map((notification) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: AlertOverlay(
                            key: ValueKey(notification.id),
                            notification: notification.notification,
                            onDismiss: () {
                              dismiss(notification.id);
                            },
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  void dismiss(int id) {
    _remove(id);
  }

  void _remove(int id) {
    _timers.remove(id)?.cancel();

    _notifications.value = _notifications.value
        .where((n) => n.id != id)
        .toList();

    if (_notifications.value.isEmpty) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    }
  }

  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }

    _timers.clear();

    _overlayEntry?.remove();
    _overlayEntry = null;

    _notifications.dispose();
  }
}
