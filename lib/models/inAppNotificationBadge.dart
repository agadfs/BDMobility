import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;


class NotificationBadge extends StatelessWidget {
  final int notificationCount;

  NotificationBadge({required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.all(5.0),
      child: badges.Badge(
        showBadge: true,
        ignorePointer: false,
        badgeContent: Text(
          notificationCount.toString(),
          style: TextStyle(fontSize: 10, color: Colors.white),
        ),
        child: Icon(
          Icons.notifications,
          size: 20.0,
          color: Colors.blue,
        ),
      ),
    );
  }
}
