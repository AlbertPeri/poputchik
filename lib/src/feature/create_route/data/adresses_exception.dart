class AdressesException implements Exception {
  const AdressesException([
    this.message = 'Неизвестная ошибка, попробуйте позже',
  ]);

  final String? message;

  @override
  String toString() => message ?? 'AdressesException';
}
