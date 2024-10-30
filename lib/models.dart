enum SortBy {
  goals,
  assists,
  points;
}

class Player {
  String firstName;
  String lastName;
  int goals;
  int assists;

  Player({
    required this.firstName,
    required this.lastName,
    required this.goals,
    required this.assists,
  });

  String get name {
    return "$firstName $lastName";
  }
}

extension PlayerExt on Player {
  int get points => goals + assists;
}
