import 'package:companion/src/core/core.dart';
import 'package:companion/src/feature/auth/extension/secure_storage.dart';
import 'package:companion/src/feature/search/model/route/route.dart';
import 'package:companion/src/feature/user/data/user_repository.dart';
import 'package:companion/src/feature/user_routes/data/user_routes_exception.dart';
import 'package:companion_api/companion.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:yandex_mapkit_lite/yandex_mapkit_lite.dart' show Point;

abstract interface class IUserRoutesRepository {
  Future<List<Route>> getUserRoutes();
  Future<Route> changeRouteStatus({
    required int id,
    required RouteStatus status,
  });
  Future<bool> deleteRoute({required int id});
  Future<Route> postUserRoute({
    required int peopleAmount,
    required DateTime date,
    required String startPlace,
    required String endPlace,
    required Point startPoint,
    required Point endPoint,
  });
  Future<Route> updateRoute({
    required int routeId,
    required String startPlace,
    required String endPlace,
    required Point startPoint,
    required Point endPoint,
    required int peopleAmount,
    required DateTime date,
  });
}

final class UserRoutesRepository implements IUserRoutesRepository {
  UserRoutesRepository({
    required CompanionClient companionClient,
    required FlutterSecureStorage secureStorage,
  })  : _companionClient = companionClient,
        _secureStorage = secureStorage;

  final CompanionClient _companionClient;
  final FlutterSecureStorage _secureStorage;

  @override
  Future<List<Route>> getUserRoutes() async {
    try {
      final userId = await _secureStorage.userId;
      if (userId == null) {
        Error.throwWithStackTrace(
          UserException(
            message: 'Для просмотра необходимо авторизоваться',
          ),
          StackTrace.current,
        );
      }

      final response = await _companionClient.getUserRoutes(
        usersId: int.parse(userId),
      );
      return response.data.map(Route.fromResponse).toList();
    } on UserException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        UserRoutesException(error.message),
        stackTrace,
      );
    } on DioException catch (error, stackTrace) {
      error.throwCustom(
        stackTrace,
        unknowError: const UserRoutesException(),
        errorBuilder: UserRoutesException.new,
      );
    }
  }

  @override
  Future<Route> changeRouteStatus({
    required int id,
    required RouteStatus status,
  }) async {
    try {
      final response = await _companionClient.changeRouteStatus(
        id: id,
        status: status,
      );
      return Route.fromResponse(response.data);
    } on DioException catch (error, stackTrace) {
      error.throwCustom(
        stackTrace,
        unknowError: const UserRoutesException(),
        errorBuilder: UserRoutesException.new,
      );
    }
  }

  @override
  Future<bool> deleteRoute({required int id}) async {
    try {
      final response = await _companionClient.deleteRoute(
        id: id,
      );
      if (response.data is Map<String, dynamic>) {
        final successValue = (response.data as Map<String, dynamic>)['success'];
        if (successValue is bool) return successValue;
        return false;
      }
      return false;
    } on DioException catch (error, stackTrace) {
      error.throwCustom(
        stackTrace,
        unknowError: const UserRoutesException(),
        errorBuilder: UserRoutesException.new,
      );
    }
  }

  @override
  Future<Route> postUserRoute({
    required int peopleAmount,
    required DateTime date,
    required String startPlace,
    required String endPlace,
    required Point startPoint,
    required Point endPoint,
  }) async {
    try {
      final userId = await _secureStorage.userId;
      if (userId == null) {
        Error.throwWithStackTrace(
          UserException(message: 'Необходимо авторизоваться'),
          StackTrace.current,
        );
      }
      final response = await _companionClient.postUserRoute(
        usersId: int.parse(userId),
        peopleAmount: peopleAmount,
        date: date,
        startPlace: startPlace,
        endPlace: endPlace,
        latitudeA: startPoint.latitude,
        longitudeA: startPoint.longitude,
        latitudeB: endPoint.latitude,
        longitudeB: endPoint.longitude,
      );
      final routeResponse = RouteResponse.fromJson(
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
      );
      return Route.fromResponse(routeResponse);
    } on UserException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        UserRoutesException(error.message),
        stackTrace,
      );
    } on DioException catch (error, stackTrace) {
      error.throwCustom(
        stackTrace,
        unknowError: const UserRoutesException(),
        errorBuilder: UserRoutesException.new,
      );
    }
  }

  @override
  Future<Route> updateRoute({
    required int routeId,
    required String startPlace,
    required String endPlace,
    required Point startPoint,
    required Point endPoint,
    required int peopleAmount,
    required DateTime date,
  }) async {
    try {
      final userId = await _secureStorage.userId;
      if (userId == null) {
        Error.throwWithStackTrace(
          UserException(message: 'Необходимо авторизоваться'),
          StackTrace.current,
        );
      }
      final response = await _companionClient.updateRoute(
        routeId: routeId,
        startPlace: startPlace,
        endPlace: endPlace,
        latitudeA: startPoint.latitude,
        longitudeA: startPoint.longitude,
        latitudeB: endPoint.latitude,
        longitudeB: endPoint.longitude,
        peopleAmount: peopleAmount,
        date: date,
      );
      final routeResponse = RouteResponse.fromJson(
        (response.data as Map<String, dynamic>)['data'] as Map<String, dynamic>,
      );
      return Route.fromResponse(routeResponse);
    } on UserException catch (error, stackTrace) {
      Error.throwWithStackTrace(
        UserRoutesException(error.message),
        stackTrace,
      );
    } on DioException catch (error, stackTrace) {
      error.throwCustom(
        stackTrace,
        unknowError: const UserRoutesException(),
        errorBuilder: UserRoutesException.new,
      );
    }
  }
}
