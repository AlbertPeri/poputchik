import 'dart:io';

import 'package:companion/src/feature/chat/scope/chat_scope.dart';
import 'package:companion/src/feature/chats/widget/scope/chats_scope.dart';
import 'package:companion/src/feature/notification/notification_service.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// {@template notification_reciever}
///  Обработчик уведомлений
/// {@endtemplate}
class NotificationReciever extends StatefulWidget {
  /// {@macro notification_reciever}
  const NotificationReciever({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<NotificationReciever> createState() => _NotificationRecieverState();
}

class _NotificationRecieverState extends State<NotificationReciever>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed) {
      NotificationService.cancelAllNotifications();
      _handleActiveNotifications();
    }
  }

  void _handleActiveNotifications() {
    NotificationService.flutterLocalNotificationsPlugin
        .getActiveNotifications()
        .then(
      (list) {
        ChatsScope.updateChatList(context, UserScope.userOf(context).id);
        for (final activeNotification in list) {
          ChatsScope.addUnreadChatId(
            RemoteMessage(
              data: {
                'chat_id': activeNotification.title,
              },
            ),
          );
        }
      },
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureSelectNotificationSubject();
    _handleActiveNotifications();
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      await NotificationService.flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.areNotificationsEnabled();
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS) {
      await NotificationService.flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final androidImplementation = NotificationService
          .flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      await androidImplementation?.requestNotificationsPermission();
    }
  }

  void _configureSelectNotificationSubject() {
    NotificationService.selectNotificationStream.stream.listen(
      (data) {
        ChatScope.openChat(context, data);
      },
    );

    FirebaseMessaging.instance.getInitialMessage().then(_selectNotification);

    FirebaseMessaging.onMessage.listen(
      (message) =>
          ChatsScope.updateChatList(context, UserScope.userOf(context).id),
    );

    FirebaseMessaging.onMessageOpenedApp.listen(_selectNotification);
  }

  void _selectNotification(RemoteMessage? message) {
    final data = message?.data;

    if (data != null) {
      ChatsScope.addUnreadChatId(message!);

      NotificationService.selectNotificationStream.add(data);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    NotificationService.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
