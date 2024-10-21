class ReviewData {
  const ReviewData({
    required this.author,
    required this.date,
    required this.rating,
    required this.text,
  });

  final String author;
  final double rating;
  final String text;
  final DateTime date;
}
