class ParsingException<From, To> implements Exception {
  ParsingException(this.from);

  final From from;

  @override
  // ignore: no_runtimetype_tostring
  String toString() => '$runtimeType  ocurred when parsing from $from';
}
