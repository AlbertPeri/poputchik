class ChatsItemData {
  const ChatsItemData({
    required this.name,
    required this.lastMessage,
    this.avatarUrl,
  });

  final String name;
  final String lastMessage;
  final String? avatarUrl;
}
