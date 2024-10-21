import 'dart:io';

import 'package:companion/src/feature/user/model/user/user.dart';
import 'package:companion_api/companion.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:l/l.dart';

// ignore: one_member_abstracts
abstract interface class INotificationsRepository {
  Future<void> savePushToken({User? user, String? pushToken});
}

class NotificationRepository implements INotificationsRepository {
  NotificationRepository({
    required CompanionClient client,
  }) : _client = client;

  final CompanionClient _client;

  @override
  Future<void> savePushToken({User? user, String? pushToken}) async {
    final token = pushToken ?? (await FirebaseMessaging.instance.getToken());
    try {
      if (user != null) {
        await _client.savePushToken(
          userId: user.id,
          token: token,
          platform: Platform.operatingSystem,
        );
        l.s('Токен сохранен - $token');
      } else {
        l.s('Нет пользователя для сохранения токена');
      }
    } on Object catch (e) {
      l.e(e);
      rethrow;
    }
  }
}
