import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/data/authentication_repository.dart';
import 'package:companion/src/feature/chat/data/chat_repository.dart';
import 'package:companion/src/feature/chats/data/chats_repository.dart';
import 'package:companion/src/feature/create_route/data/adresses_repository.dart';
import 'package:companion/src/feature/notification/data/notification_repository.dart';
import 'package:companion/src/feature/person_profile/data/person_repository.dart';
import 'package:companion/src/feature/search/data/search_repository.dart';
import 'package:companion/src/feature/settings/database/settings_dao.dart';
import 'package:companion/src/feature/settings/repository/settings_repository.dart';
import 'package:companion/src/feature/user/data/user_repository.dart';
import 'package:companion/src/feature/user_routes/data/user_routes_repository.dart';
import 'package:companion_api/companion.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yandex_geocoder/yandex_geocoder.dart';
import 'package:yandex_maps_api/yandex_maps.dart';

abstract class IRepositoryStorage {
  ISettingsRepository get settingsRepository;
  IAuthRepository get authRepository;
  IUserRepository get userRepository;
  IChatsRepository get chatsRepository;
  IChatRepository get chatRepository;
  ISearchRepository get searchRepository;
  IUserRoutesRepository get userRoutesRepository;
  IAdressesRepository get adressesRepository;
  IPersonRepository get personRepository;
  INotificationsRepository get notificationsRepository;
}

class RepositoryStorage implements IRepositoryStorage {
  RepositoryStorage({
    required AppDatabase appDatabase,
    required SharedPreferences sharedPreferences,
    required FlutterSecureStorage secureStorage,
    required CompanionClient companionClient,
    required YandexMapsClient yandexMapsClient,
    required YandexGeocoder yandexGeocoder,
  })  : _appDatabase = appDatabase,
        _sharedPreferences = sharedPreferences,
        _secureStorage = secureStorage,
        _companionClient = companionClient,
        _yandexMapsClient = yandexMapsClient,
        _yandexGeocoder = yandexGeocoder;

  final AppDatabase _appDatabase;

  final SharedPreferences _sharedPreferences;

  final FlutterSecureStorage _secureStorage;

  final CompanionClient _companionClient;

  final YandexMapsClient _yandexMapsClient;

  final YandexGeocoder _yandexGeocoder;

  @override
  ISettingsRepository get settingsRepository => SettingsRepository(
        settingsDao: SettingsDao(sharedPreferences: _sharedPreferences),
      );

  @override
  IAuthRepository get authRepository => AuthRepository(
        usersDao: _appDatabase.usersDao,
        client: _companionClient,
        secureStorage: _secureStorage,
      );

  @override
  IUserRepository get userRepository => UserRepository(
        usersDao: _appDatabase.usersDao,
        client: _companionClient,
        secureStorage: _secureStorage,
      );

  @override
  IChatsRepository get chatsRepository => ChatsRepository(
        client: _companionClient,
        secureStorage: _secureStorage,
      );

  @override
  IChatRepository get chatRepository => ChatRepository(
        client: _companionClient,
      );

  @override
  ISearchRepository get searchRepository => SearchRepository(
        companionClient: _companionClient,
        secureStorage: _secureStorage,
      );
  @override
  IUserRoutesRepository get userRoutesRepository => UserRoutesRepository(
        companionClient: _companionClient,
        secureStorage: _secureStorage,
      );

  @override
  IAdressesRepository get adressesRepository => AdressesRepository(
        yandexGeocoder: _yandexGeocoder,
        yandexMapsClient: _yandexMapsClient,
      );

  @override
  IPersonRepository get personRepository => PersonRepository(
        client: _companionClient,
      );

  @override
  INotificationsRepository get notificationsRepository =>
      NotificationRepository(client: _companionClient);
}
