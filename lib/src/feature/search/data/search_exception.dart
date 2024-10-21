class SearchException implements Exception {
  const SearchException([
    this.message = 'Неизвестная ошибка, попробуйте позже',
  ]);

  final String? message;

  @override
  String toString() => message ?? 'SearchException';
}
