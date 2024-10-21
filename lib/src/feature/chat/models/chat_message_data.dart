class ChatMessageData {
  const ChatMessageData({
    required this.id,
    required this.userId,
    required this.sendDate,
    required this.message,
    this.isRead,
  });

  final String id;
  final String userId;
  final DateTime sendDate;
  final String message;
  final bool? isRead;
}
