import 'sport_type.dart';

class League {
  const League({
    required this.id,
    required this.name,
    required this.country,
    required this.season,
    this.sportType = SportType.football,
  });

  final String id;
  final String name;
  final String country;
  final int season;
  final SportType sportType;
}
