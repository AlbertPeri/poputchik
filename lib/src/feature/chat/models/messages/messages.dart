import 'package:companion/src/feature/chat/models/links/links.dart';
import 'package:companion/src/feature/chat/models/message/message.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'messages.freezed.dart';
part 'messages.g.dart';

@freezed
class Messages with _$Messages {
  const factory Messages({
    required int currentPage,
    required List<Message> data,
    required String firstPageUrl,
    required int? from,
    required int lastPage,
    required String lastPageUrl,
    required List<Links> links,
    required String? nextPageUrl,
    required String path,
    required int perPage,
    required String? prevPageUrl,
    required int? to,
    required int total,
  }) = _Messages;

  factory Messages.fromJson(Map<String, Object?> json) =>
      _$MessagesFromJson(json);

  const Messages._();

  bool get isLastPage => currentPage == lastPage;
}
