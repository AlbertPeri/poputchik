import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:companion/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:l/l.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.setupFlutterNotifications(
    message: message,
  );
  l.s('Handling a background message ${message.messageId}');
}

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  l.s('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    l.s(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

class NotificationService {
  static Future<void> setup() async {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    if (!kIsWeb) {
      await setupFlutterNotifications();
    }

    await _initialize();
  }

  static Future<void> _initialize() async {
    await NotificationService.flutterLocalNotificationsPlugin.cancelAll();

    final notificationAppLaunchDetails = !kIsWeb && Platform.isLinux
        ? null
        : await flutterLocalNotificationsPlugin
            .getNotificationAppLaunchDetails();

    if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
      selectedNotificationPayload =
          notificationAppLaunchDetails!.notificationResponse?.payload;
    }
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        final payload = notificationResponse.payload;
        if (payload != null) {
          final data = Map<String, Object?>.from(jsonDecode(payload) as Map);
          selectNotificationStream.add(data);
        }
      },
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('app_icon');

  static const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();

  static const InitializationSettings initializationSettings =
      InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );

  static final StreamController<Map<String, Object?>?>
      selectNotificationStream =
      StreamController<Map<String, Object?>?>.broadcast();

  static String? selectedNotificationPayload;

  /// Create a [AndroidNotificationChannel] for heads up notifications
  static late AndroidNotificationChannel channel;

  static bool isFlutterLocalNotificationsInitialized = false;

  /// Initialize the [FlutterLocalNotificationsPlugin] package.
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
    if (await FlutterAppBadger.isAppBadgeSupported()) {
      await FlutterAppBadger.removeBadge();
    }
  }

  static Future<void> setupFlutterNotifications({
    RemoteMessage? message,
  }) async {
    if (isFlutterLocalNotificationsInitialized) {
      return;
    }

    await FirebaseMessaging.instance.requestPermission(
      criticalAlert: true,
      carPlay: true,
    );

    final data = message?.data;
    final groupKey = data != null && data.containsKey('chat_id')
        ? data['chat_id']! as String
        : null;

    channel = AndroidNotificationChannel(
      'high_importance_channel',
      'Важные уведомления',
      importance: Importance.high,
      enableLights: true,
      groupId: groupKey,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    /// Create an Android Notification Channel.
    ///
    /// We use this channel in the `AndroidManifest.xml` file to override the
    /// default FCM channel to enable heads up notifications.
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    isFlutterLocalNotificationsInitialized = true;
  }

  static Future<void> showFlutterNotification(RemoteMessage message) async {
    final data = message.data;
    l.s(jsonEncode(message.toMap()));
    final groupKey =
        data.containsKey('chat_id') ? data['chat_id'] as String : null;

    final notification = message.notification;
    final android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      await flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        payload: jsonEncode(data),
        NotificationDetails(
          android: AndroidNotificationDetails(
            setAsGroupSummary: true,
            channel.id,
            groupKey: groupKey,
            channel.name,
            priority: Priority.max,
            channelDescription: channel.description,
            color: Colors.black,
            icon: 'app_icon',
          ),
        ),
      );
    }
  }

  static void close() {
    selectNotificationStream.close();
  }
}
