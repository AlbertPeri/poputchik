import 'package:companion/src/feature/chat/models/links/links.dart';
import 'package:companion/src/feature/chat/models/message/message.dart';
import 'package:companion/src/feature/chat/models/messages/messages.dart';
import 'package:companion/src/feature/chat/models/messages_info/messages_info.dart';
import 'package:companion_api/companion.dart';

extension LinksResponseX on LinksResponse {
  Links toLinks() => Links(
        url: url,
        label: label,
        active: active,
      );
}

extension MessageResponseX on MessageResponse {
  Message toMessage() => Message(
        id: id,
        chatId: chatId,
        userId: userId,
        content: content,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

extension MessagesResponseX on MessagesResponse {
  Messages toInfo() => Messages(
        currentPage: currentPage,
        data: data.map((e) => e.toMessage()).toList(),
        firstPageUrl: firstPageUrl,
        from: from,
        lastPage: lastPage,
        lastPageUrl: lastPageUrl,
        links: links.map((e) => e.toLinks()).toList(),
        nextPageUrl: nextPageUrl,
        path: path,
        perPage: perPage,
        prevPageUrl: prevPageUrl,
        to: to,
        total: total,
      );
}

extension MessagesInfoResponseX on MessagesInfoResponse {
  MessagesInfo toMessagesInfo() => MessagesInfo(
        success: success,
        info: messages.toInfo(),
      );
}
