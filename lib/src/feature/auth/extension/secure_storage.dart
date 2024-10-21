import 'package:flutter_secure_storage/flutter_secure_storage.dart';

extension SecureStorageX on FlutterSecureStorage {
  void setUserId(String userId) => write(key: 'userId', value: userId);

  Future<String?> get userId => read(key: 'userId');

  Future<void> clearUserId() => delete(key: 'userId');
}
