import 'package:companion/src/feature/search/model/map_point.dart';

class TripInfo {
  const TripInfo({
    required this.departurePoint,
    required this.arrivalPoint,
    required this.personName,
    required this.personRating,
    required this.arrivalDate,
    required this.numberOfParticipants,
  });

  final MapPoint departurePoint;
  final MapPoint arrivalPoint;
  final String personName;
  final double personRating;
  final DateTime arrivalDate;
  final int numberOfParticipants;
}
