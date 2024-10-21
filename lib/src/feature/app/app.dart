import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/app/bloc/initialization/initialization_bloc.dart';
import 'package:companion/src/feature/app/widget/app_configuration.dart';
import 'package:companion/src/feature/auth/scope/auth_scope.dart';
import 'package:companion/src/feature/chats/widget/scope/chats_scope.dart';
import 'package:companion/src/feature/create_route/scope/adress_list_scope.dart';
import 'package:companion/src/feature/create_route/scope/adress_map_scope.dart';
import 'package:companion/src/feature/create_route/scope/create_route_scope.dart';
import 'package:companion/src/feature/person_profile/widget/scope/person_scope.dart';
import 'package:companion/src/feature/search/scope/route_info_scope.dart';
import 'package:companion/src/feature/search/scope/search_scope.dart';
import 'package:companion/src/feature/settings/widget/scope/settings_scope.dart';
import 'package:companion/src/feature/user/scope/user_scope.dart';
import 'package:companion/src/feature/user_routes/scope/user_routes_scope.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class App extends StatelessWidget {
  const App({
    required this.initializationData,
    super.key,
  });

  final InitializationData initializationData;

  SharedPreferences get _sharedPreferences =>
      initializationData.sharedPreferences;

  @override
  Widget build(BuildContext context) {
    return DependenciesScope(
      create: (context) => DependenciesStorage(
        sharedPreferences: _sharedPreferences,
      ),
      child: RepositoryScope(
        create: (context) => RepositoryStorage(
          appDatabase: context.database,
          secureStorage: context.dependencies.secureStorage,
          sharedPreferences: _sharedPreferences,
          companionClient: context.dependencies.companionClient,
          yandexMapsClient: context.dependencies.yandexMapsClient,
          yandexGeocoder: context.dependencies.yandexGeocoder,
        ),
        child: const AuthScope(
          child: UserScope(
            child: ChatsScope(
              child: SettingsScope(
                child: PersonScope(
                  child: CreateRouteScope(
                    child: AdressMapScope(
                      child: AdressListScope(
                        child: UserRoutesScope(
                          child: SearchScope(
                            child: RouteInfoScope(
                              child: AppConfiguration(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
