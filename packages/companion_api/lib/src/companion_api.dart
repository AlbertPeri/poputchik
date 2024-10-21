import 'package:companion_api/src/model/model.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'companion_api.g.dart';

/// {@template companion_base}
/// A Dart API Client for traveling companion app.
/// {@endtemplate}
@RestApi(baseUrl: 'https://djigit-companion.ru/api/v1/')
abstract class CompanionClient {
  /// {@macro companion_base}
  factory CompanionClient(
    Dio dio, {
    String? baseUrl,
  }) {
    return _CompanionClient(dio, baseUrl: baseUrl);
  }

  /// Запрос получения смс кода
  @POST('/reg/sendCode')
  Future<HttpResponse<Map<String, String>>> sendPhone({
    @Query('phone_number') required String phone,
  });

  /// Проверка кода
  @POST('/reg/verifyCode')
  Future<HttpResponse<Map<String, String>>> checkCode({
    @Query('phone_number') required String phoneNumber,
    @Query('verification_code') required String verificationCode,
  });

  /// Выход из акка
  @POST('/reg/logout')
  Future<HttpResponse<Map<String, String>>> logOut({
    @Query('users_id') required int usersId,
  });

  /// Получение списка маршрутов пользователя
  @GET('/personalRoutes/getAll')
  Future<HttpResponse<List<RouteResponse>>> getUserRoutes({
    @Query('users_id') required int usersId,
  });

  /// Добавление маршрута пользователя
  @POST('/personalRoutes/post')
  Future<HttpResponse<dynamic>> postUserRoute({
    @Query('users_id') required int usersId,
    @Query('people_amount') required int peopleAmount,
    @Query('date') required DateTime date,
    @Query('start_place') required String startPlace,
    @Query('end_place') required String endPlace,
    @Query('latitude_A') required double latitudeA,
    @Query('longitude_A') required double longitudeA,
    @Query('latitude_B') required double latitudeB,
    @Query('longitude_B') required double longitudeB,
    @Query('name') String? name,
    @Query('description') String? description,
    @Query('status') RouteStatus? status,
  });

  /// Изменение статуса маршрута
  @PUT('/personalRoutes/statusChange')
  Future<HttpResponse<RouteResponse>> changeRouteStatus({
    @Query('id') required int id,
    @Query('status') required RouteStatus status,
  });

  /// Удаление маршрута
  /// {"success": true}
  // использую dynamic, т.к. компилятор ругается на Map<String, dynamic>
  @DELETE('/personalRoutes/delete')
  Future<HttpResponse<dynamic>> deleteRoute({
    @Query('id') required int id,
  });

  /// Получение пользователя
  @GET('/profile/show')
  Future<UserResponse> getUser({
    @Query('id') required String usersId,
  });

  /// Обновление пользователя
  @POST('/profile/update')
  Future<HttpResponse<Map<String, String>>> updateUser({
    @Body() required UserForEditResponse userForEdit,
  });

  /// Получение чатов по user id
  @GET('/chat/getChats')
  Future<HttpResponse<ChatsListResponse>> getChats({
    @Query('users_id') required String usersId,
  });

  @POST('/chat/getMessage')
  Future<HttpResponse<MessagesInfoResponse>> getMessages({
    @Part(name: 'chat_id') required String? chatId,
    @Part(name: 'reader_id') required int readerId,
    @Part(name: 'page') int? page,
  });

  @POST('/chat/getOrCreate')
  Future<CreatedChatResponse> createChat({
    @Part(name: 'creator_id') required String creatorId,
    @Part(name: 'target_id') required String targetId,
    @Part(name: 'reader_id') required int readerId,
    @Part(name: 'content') String? content,
  });

  @POST('/chat/sendMessage')
  Future<HttpResponse<Map<String, String>>> sendMessage({
    @Query('user_id') required String userId,
    @Query('chat_id') required String chatId,
    @Query('content') required String content,
  });

  @DELETE('/chat/deleteChat')
  Future<HttpResponse<Map<String, String>>> deleteChat({
    @Query('chat_id') required int chatId,
    @Query('deleted_by_id') required int deletedById,
  });

  /// Получение всех маршрутов
  @GET('/mainDisplay/getAllRoutes')
  Future<HttpResponse<AllRoutesResponse>> getAllRoutes();

  @POST('/reviews/post')
  Future<HttpResponse<Map<String, String>>> postReview({
    @Query('sender_id') required String senderId,
    @Query('receiver_id') required String receiverId,
    @Query('content') required String content,
    @Query('rating') required int rating,
  });

  @PUT('/personalRoutes/update')
  Future<HttpResponse<dynamic>> updateRoute({
    @Query('route_id') required int routeId,
    // @Query('name') String? name,
    // @Query('description') String? description,
    @Query('start_place') required String startPlace,
    @Query('end_place') required String endPlace,
    @Query('latitude_A') required double latitudeA,
    @Query('longitude_A') required double longitudeA,
    @Query('latitude_B') required double latitudeB,
    @Query('longitude_B') required double longitudeB,
    @Query('people_amount') required int peopleAmount,
    @Query('date') required DateTime date,
  });

  @PUT('/profile/savePushToken')
  Future<void> savePushToken({
    @Query('users_id') required int userId,
    @Query('platform') required String platform,
    @Query('push_token') String? token,
    @Query('user_agent') String? deviceId,
  });

  @POST('/chat/blockUser')
  Future<HttpResponse<Map<String, String>>> blockUser({
    @Query('sender_id') required String senderId,
    @Query('target_id') required String targetId,
  });

  @POST('/chat/unBlockUser')
  Future<HttpResponse<Map<String, String>>> unBlockUser({
    @Query('sender_id') required String senderId,
    @Query('target_id') required String targetId,
  });
}
