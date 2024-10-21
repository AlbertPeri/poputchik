import 'package:companion/src/core/database/shared_preferences/typed_preferences_dao.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsDao extends TypedPreferencesDao {
  ChatsDao({
    required SharedPreferences sharedPreferences,
  }) : super(sharedPreferences, name: 'chats');

  PreferencesEntry<List<String>> get unreadChatsIds =>
      stringListEntry('unread_chats_ids');
}
