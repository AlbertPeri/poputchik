import 'package:companion_api/src/model/chat/links/links.dart';
import 'package:companion_api/src/model/chat/message/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'messages.freezed.dart';
part 'messages.g.dart';

@freezed
class MessagesResponse with _$MessagesResponse {
  const factory MessagesResponse({
    required int currentPage,
    required List<MessageResponse> data,
    required String firstPageUrl,
    required int? from,
    required int lastPage,
    required String lastPageUrl,
    required List<LinksResponse> links,
    required String? nextPageUrl,
    required String path,
    required int perPage,
    required String? prevPageUrl,
    required int? to,
    required int total,
  }) = _MessagesResponse;

  factory MessagesResponse.fromJson(Map<String, Object?> json) =>
      _$MessagesResponseFromJson(json);
}
