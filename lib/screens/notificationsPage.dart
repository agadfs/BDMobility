import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  final List<String> notifications;
  static const String routeName = '/notificationPage';

  final String? payload;

  NotificationPage({required this.notifications, this.payload});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(notifications[index]),
          );
        },
      ),
    );
  }
}
