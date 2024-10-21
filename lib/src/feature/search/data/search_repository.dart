// ignore_for_file: one_member_abstracts

import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/extension/secure_storage.dart';
import 'package:companion/src/feature/search/data/search_exception.dart';
import 'package:companion/src/feature/search/model/all_routes/all_routes.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion_api/companion.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract interface class ISearchRepository {
  Future<AllRoutes> getAllRoutes();
}

final class SearchRepository implements ISearchRepository {
  const SearchRepository({
    required CompanionClient companionClient,
    required FlutterSecureStorage secureStorage,
  })  : _companionClient = companionClient,
        _secureStorage = secureStorage;

  final CompanionClient _companionClient;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<AllRoutes> getAllRoutes() async {
    try {
      final response = await _companionClient.getAllRoutes();
      final allRoutes = AllRoutes.fromResponse(response.data);
      final userId = await _secureStorage.userId;
      if (userId == null) {
        return allRoutes;
      }

      final routesCopy = List<Route>.from(allRoutes.routes);
      return allRoutes.copyWith(
        routes: routesCopy
            .map(
              (route) => route.copyWith(
                isMine: route.usersId == int.parse(userId),
              ),
            )
            .toList()
          ..removeWhere(
            (route) => route.isMine && route.status == RouteStatus.completed,
          ),
      );
    } on DioException catch (error, stackTrace) {
      error.throwCustom(
        stackTrace,
        unknowError: const SearchException(),
        errorBuilder: SearchException.new,
      );
    }
  }
}
