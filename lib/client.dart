import 'package:fluttertest/models.dart';

Map<int, Player> players = {
  1: Player(firstName: "Wayne", lastName: "Gretzky", goals: 894, assists: 1963),
  2: Player(firstName: "Alex", lastName: "Ovechkin", goals: 826, assists: 670),
  3: Player(firstName: "Gordie", lastName: "Howe", goals: 801, assists: 1049),
  4: Player(firstName: "Jaromir", lastName: "Jagr", goals: 766, assists: 1155),
};

Future<Player> fetchPlayer(int userId) async {
  return players[userId]!;
}

Future<List<Player>> fetchPlayers() async {
  return players.values.toList();
}
