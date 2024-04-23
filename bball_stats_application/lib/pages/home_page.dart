import 'package:bball_stats_application/models/game.dart';
import 'package:bball_stats_application/pages/averages_page.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(context),
      body: _buildUI(),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayTextInputDialog,
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

 PreferredSizeWidget _appBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.orange,
    title: const Text(
      "Stats",
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    actions: [
      IconButton(
        icon: Icon(Icons.equalizer),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AveragesPage()),
          );
        },
      ),
    ],
  );
}


  Widget _buildUI() {
    return SafeArea(
        child: Column(
      children: [
        _messagesListView(),
      ],
    ));
  }

  Widget _messagesListView() {
    return SizedBox(
        height: MediaQuery.sizeOf(context).height * 0.80,
        width: MediaQuery.sizeOf(context).width,
        child: StreamBuilder(
          stream: _databaseService.getGames(),
          builder: (context, snapshot) {
            List games = snapshot.data?.docs ?? [];
            if (games.isEmpty) {
              return const Center(
                child: Text("No games found"),
              );
            }
            return ListView.builder(
              itemCount: games.length,
              itemBuilder: (context, index) {
                Game game = games[index].data();
                String gameID = games[index].id;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: ListTile(
                      tileColor: Colors.black,
                        title: Text(
                        "Game Stats",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                        subtitle: Text(
                        "Points: ${game.points}\n"
                        'Rebounds: ${game.rebounds}\n'
                        'Assists: ${game.assists}\n'
                        'Steals: ${game.steals}\n'
                        'Blocks: ${game.blocks}\n',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () async {
                              final _formKey = GlobalKey<FormState>();
                              Game updatedGame = Game(
                                points: game.points,
                                rebounds: game.rebounds,
                                assists: game.assists,
                                steals: game.steals,
                                blocks: game.blocks,
                              );
                              return showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Update Game Stats"),
                                    content: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: <Widget>[
                                          TextFormField(
                                            initialValue: '${game.points}',
                                            decoration: InputDecoration(
                                                labelText: 'Points'),
                                            keyboardType:
                                                TextInputType.number,
                                            onSaved: (value) {
                                              updatedGame.points =
                                                  int.parse(value!);
                                            },
                                          ),
                                          TextFormField(
                                            initialValue:
                                                '${game.rebounds}',
                                            decoration: InputDecoration(
                                                labelText: 'Rebounds'),
                                            keyboardType:
                                                TextInputType.number,
                                            onSaved: (value) {
                                              updatedGame.rebounds =
                                                  int.parse(value!);
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: '${game.assists}',
                                            decoration: InputDecoration(
                                                labelText: 'Assists'),
                                            keyboardType:
                                                TextInputType.number,
                                            onSaved: (value) {
                                              updatedGame.assists =
                                                  int.parse(value!);
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: '${game.steals}',
                                            decoration: InputDecoration(
                                                labelText: 'Steals'),
                                            keyboardType:
                                                TextInputType.number,
                                            onSaved: (value) {
                                              updatedGame.steals =
                                                  int.parse(value!);
                                            },
                                          ),
                                          TextFormField(
                                            initialValue: '${game.blocks}',
                                            decoration: InputDecoration(
                                                labelText: 'Blocks'),
                                            keyboardType:
                                                TextInputType.number,
                                            onSaved: (value) {
                                              updatedGame.blocks =
                                                  int.parse(value!);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                      child: Text("Cancel", style: TextStyle(color: Colors.black)),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      ),
                                      TextButton(
                                      child: Text("Update", style: TextStyle(color: Colors.black)),
                                      onPressed: () {
                                        _formKey.currentState!.save();
                                        _databaseService.updateGame(
                                          gameID, updatedGame);
                                        Navigator.of(context).pop();
                                      },
                                      ),
                                    ]
                                    
                                  );
                                }
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _databaseService.deleteGame(gameID);
                            },
                          ),
                        ],
                      )
                    ),
                );
              },
            );
          },
        )
      );
  }

 void _displayTextInputDialog() async {
  final _formKey = GlobalKey<FormState>();
  Game newGame = Game(
    points: 0,
    rebounds: 0,
    assists: 0,
    steals: 0,
    blocks: 0,
  );

  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Add a Game'),
        content: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(labelText: 'Points'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  newGame.points = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Rebounds'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  newGame.rebounds = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Assists'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  newGame.assists = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Steals'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  newGame.steals = int.parse(value!);
                },
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Blocks'),
                keyboardType: TextInputType.number,
                onSaved: (value) {
                  newGame.blocks = int.parse(value!);
                },
              ),
            ],
          ),
        ),
        actions: <Widget>[
          MaterialButton(
            color: Colors.black,
            textColor: Colors.white,
            child: const Text('Create'),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _formKey.currentState!.save();
                _databaseService.addGame(newGame);
                Navigator.pop(context);
              }
            },
          ),
        ],
      );
    },
  );
}
}
