class UserRoutesException implements Exception {
  const UserRoutesException([
    this.message = 'Неизвестная ошибка, попробуйте позже',
  ]);

  final String? message;

  @override
  String toString() => message ?? 'UserRoutesException';
}
