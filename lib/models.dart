enum SortBy {
  goals,
  assists,
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
