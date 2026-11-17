import 'package:flutter/material.dart';

import 'package:cognium_frontend/error/error_handler.dart';

class AlertOverlay extends StatelessWidget {
  final AppError notification;
  final VoidCallback onDismiss;

  const AlertOverlay({super.key, required this.notification, required this.onDismiss});

  Color get accentColor {
    switch (notification.severity) {
      case ErrorSeverity.info:
        return const Color(0xFF60A5FA);

      case ErrorSeverity.warning:
        return const Color(0xFFFBBF24);

      case ErrorSeverity.error:
        return const Color(0xFFF87171);

      case ErrorSeverity.critical:
        return const Color(0xFFFB7185);
    }
  }

  IconData get icon {
    switch (notification.severity) {
      case ErrorSeverity.info:
        return Icons.info_outline;

      case ErrorSeverity.warning:
        return Icons.warning_amber_rounded;

      case ErrorSeverity.error:
        return Icons.error_outline;

      case ErrorSeverity.critical:
        return Icons.gpp_bad_outlined;
    }
  }

  String get title {
    switch (notification.category) {
      case ErrorCategory.database:
        return 'DATABASE';

      case ErrorCategory.file:
        return 'FILE';

      case ErrorCategory.inference:
        return 'INFERENCE';

      case ErrorCategory.internal:
        return 'INTERNAL';

      case ErrorCategory.network:
        return 'NETWORK';

      case ErrorCategory.unknow:
        return 'UNKNOW';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 250),
      builder: (context, value, child) {
        return Opacity(
          opacity: value.toDouble(),
          child: Transform.translate(
            offset: Offset((20 * (1 - value)).toDouble(), 0),
            child: child,
          ),
        );
      },
      child: Container(
        width: 300,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF171B24),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: Colors.black,
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(icon, size: 21),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFFF1F5F9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    notification.userMessage,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 12,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            SizedBox(
              width: 28,
              height: 28,
              child: IconButton(
                padding: EdgeInsets.zero,
                tooltip: 'Dismiss notification',
                onPressed: onDismiss,
                icon: const Icon(
                  Icons.close,
                  size: 17,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
