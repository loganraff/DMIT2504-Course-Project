import 'package:bball_stats_application/models/game.dart';
import 'package:flutter/material.dart';
import '../services/database_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: _appBar(),
      body: _buildUI(),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: _displayTextInputDialog,
      //   backgroundColor: Theme.of(context).colorScheme.primary,
      //   child: const Icon(
      //     Icons.add,
      //     color: Colors.white,
      //   ),
      // ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: const Text(
        "Stats",
        style: TextStyle(
          color: Colors.white,
        ),
      ),
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
                    tileColor: Theme.of(context).colorScheme.primaryContainer,
                    title: Text("Game Stats"),
                    subtitle: Text("Points: ${game.points}\n"
                        'Rebounds: ${game.rebounds}\n'
                        'Assists: ${game.assists}\n'
                        'Steals: ${game.steals}\n'
                        'Blocks: ${game.blocks}\n'),
                    trailing: IconButton(
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
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            updatedGame.points =
                                                int.parse(value!);
                                          },
                                        ),
                                        TextFormField(
                                          initialValue: '${game.rebounds}',
                                          decoration: InputDecoration(
                                              labelText: 'Rebounds'),
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            updatedGame.rebounds =
                                                int.parse(value!);
                                          },
                                        ),
                                        TextFormField(
                                          initialValue: '${game.assists}',
                                          decoration: InputDecoration(
                                              labelText: 'Assists'),
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            updatedGame.assists =
                                                int.parse(value!);
                                          },
                                        ),
                                        TextFormField(
                                          initialValue: '${game.steals}',
                                          decoration: InputDecoration(
                                              labelText: 'Steals'),
                                          keyboardType: TextInputType.number,
                                          onSaved: (value) {
                                            updatedGame.steals =
                                                int.parse(value!);
                                          },
                                        ),
                                        TextFormField(
                                          initialValue: '${game.blocks}',
                                          decoration: InputDecoration(
                                              labelText: 'Blocks'),
                                          keyboardType: TextInputType.number,
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
                                      child: Text("Cancel"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text("Update"),
                                      onPressed: () {
                                        _formKey.currentState!.save();
                                        _databaseService.updateGame(
                                            gameID, updatedGame);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ]);
                            });
                      },
                    ),
                  ),
                );
              },
            );
          },
        ));
  }
}
