import 'package:flutter/material.dart';
import 'package:fluttertest/client.dart';
import 'package:fluttertest/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _favPlayersKey = 'favPlayers';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Highest Scoring NHL Players',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Highest Scoring NHL Players'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SharedPreferences? _prefs;

  final _favPlayers = <String>{};

  SortBy sortBy = SortBy.goals;
  List<Player> players = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _prefs = await SharedPreferences.getInstance();

      _getFavPlayers();

      setState(() {
        fetchPlayers().then((List<Player> newPlayers) => players = newPlayers);
      });
    });
  }

  void _changeSort() {
    switch (sortBy) {
      case SortBy.goals:
        sortBy = SortBy.assists;
        break;
      case SortBy.assists:
        sortBy = SortBy.points;
        break;
      case SortBy.points:
        sortBy = SortBy.goals;
        break;
    }

    final newPlayers = List.of(players);

    switch (sortBy) {
      case SortBy.goals:
        newPlayers.sort((a, b) => b.goals.compareTo(a.goals));
        break;
      case SortBy.assists:
        newPlayers.sort((a, b) => b.assists.compareTo(a.assists));
        break;
      case SortBy.points:
        newPlayers.sort((a, b) => b.points.compareTo(a.points));
        break;
    }

    setState(() => players = newPlayers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            playerList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _changeSort,
        tooltip: 'Change sort',
        child: const Icon(Icons.change_circle),
      ),
    );
  }

  Widget playerList() {
    List<DataRow> rows = [];
    // headers
    var columns = <DataColumn>[
      const DataColumn(
        label: Expanded(
          child: Text(
            'Name',
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Goals',
            style: TextStyle(
              fontWeight: sortBy == SortBy.goals ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Assists',
            style: TextStyle(
              fontWeight: sortBy == SortBy.assists ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Points',
            style: TextStyle(
              fontWeight: sortBy == SortBy.points ? FontWeight.bold : null,
            ),
          ),
        ),
      ),
      const DataColumn(
        label: Expanded(
          child: Text('Favorite'),
        ),
      ),
    ];
    for (var player in players) {
      final isActive = _favPlayers.contains(player.name);

      rows.add(DataRow(cells: [
        DataCell(Text(player.name)),
        DataCell(Text("${player.goals}")),
        DataCell(Text("${player.assists}")),
        DataCell(Text("${player.points}s")),
        DataCell(Checkbox(
          value: isActive,
          onChanged: (o) {
            setState(() {
              if (isActive) {
                _favPlayers.remove(player.name);
              } else {
                _favPlayers.add(player.name);
              }
            });

            _storeFavPlayers();
          },
        )),
      ]));
    }
    return DataTable(
      border: TableBorder.all(color: Colors.black),
      columns: columns,
      rows: rows,
    );
  }

  Future<void> _storeFavPlayers() async {
    if (_prefs != null) {
      await _prefs!.setStringList(_favPlayersKey, _favPlayers.toList());
    }
  }

  Future<void> _getFavPlayers() async {
    if (_prefs != null) {
      final favPlayers = _prefs!.getStringList(_favPlayersKey);

      if (favPlayers?.isNotEmpty ?? false) {
        _favPlayers
          ..clear()
          ..addAll(favPlayers!);
      }
    }
  }
}
