enum SportType { football, basketball, esports }

extension SportTypeX on SportType {
  String get label => switch (this) {
    SportType.football => '足球',
    SportType.basketball => '篮球',
    SportType.esports => '电竞',
  };
}
