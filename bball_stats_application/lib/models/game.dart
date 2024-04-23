class Game {
  int points;
  int assists;
  int rebounds;
  int steals;
  int blocks;

  Game({
    required this.points,
    required this.assists,
    required this.rebounds,
    required this.steals,
    required this.blocks,
  });

  Game.fromJson(Map<String, Object?> json)
      : this(
          points: json['points']! as int,
          assists: json['assists']! as int,
          rebounds: json['rebounds']! as int,
          steals: json['steals']! as int,
          blocks: json['blocks']! as int,
        );

  Game copyWith({
    int? points,
    int? assists,
    int? rebounds,
    int? steals,
    int? blocks,
  }) {
    return Game(
        points: points ?? this.points,
        assists: assists ?? this.assists,
        rebounds: rebounds ?? this.rebounds,
        steals: steals ?? this.steals,
        blocks: blocks ?? this.blocks);
  }

  Map<String, Object?> toJson() {
    return {
      'points': points,
      'assists': assists,
      'rebounds': rebounds,
      'steals': steals,
      'blocks': blocks,
    };
  }
}
