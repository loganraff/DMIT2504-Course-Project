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
        "Todo",
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
                print(game);
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 20,
                  ),
                  child: ListTile(),
                );
              },
            );
          },
        ));
  }
}
