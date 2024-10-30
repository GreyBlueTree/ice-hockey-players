import 'package:flutter/material.dart';
import 'package:fluttertest/client.dart';
import 'package:fluttertest/models.dart';

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
  SortBy sortBy = SortBy.goals;
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    fetchPlayers().then((List<Player> newPlayers) {
      players = newPlayers;
    });
  }

  void _changeSort() {
    switch (sortBy) {
      case SortBy.goals:
        sortBy = SortBy.assists;
        break;
      case SortBy.assists:
        sortBy = SortBy.goals;
        break;
    }
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
    var columns = const <DataColumn>[
      DataColumn(
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
          ),
        ),
      ),
      DataColumn(
        label: Expanded(
          child: Text(
            'Assists',
          ),
        ),
      ),
    ];
    for (var player in players) {
      rows.add(DataRow(cells: [
        DataCell(Text(player.name)),
        DataCell(Text("${player.goals}")),
        DataCell(Text("${player.assists}")),
      ]));
    }
    return DataTable(
      border: TableBorder.all(color: Colors.black),
      columns: columns,
      rows: rows,
    );
  }
}
