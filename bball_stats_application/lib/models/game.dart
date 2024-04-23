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
        points: json['points'] != null ? json['points']! as int : 0,
        assists: json['assists'] != null ? json['assists']! as int : 0,
        rebounds: json['rebounds'] != null ? json['rebounds']! as int : 0,
        steals: json['steals'] != null ? json['steals']! as int : 0,
        blocks: json['blocks'] != null ? json['blocks']! as int : 0,
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
