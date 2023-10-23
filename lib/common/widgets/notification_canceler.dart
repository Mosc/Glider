import 'package:flutter/material.dart';

class NotificationCanceler<T extends Notification> extends StatelessWidget {
  const NotificationCanceler({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<T>(
      onNotification: (notification) => true,
      child: child,
    );
  }
}
