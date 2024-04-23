import 'package:flutter/material.dart';
import 'package:bball_stats_application/models/game.dart'; // Import your Game model
import '../services/database_service.dart'; // Import your DatabaseService

class AveragesPage extends StatefulWidget {
  @override
  _AveragesPageState createState() => _AveragesPageState();
}

class _AveragesPageState extends State<AveragesPage> {
  final DatabaseService _databaseService = DatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Averages'),
      ),
      body: StreamBuilder(
        stream: _databaseService.getGames(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          List games = snapshot.data?.docs ?? [];
          if (games.isEmpty) {
            return Center(
              child: Text('No games found'),
            );
          }

          // Calculate averages
          double totalPoints = 0;
          double totalRebounds = 0;
          double totalAssists = 0;
          double totalSteals = 0;
          double totalBlocks = 0;

          for (var game in games) {
            Game gameData = game.data();
            totalPoints += gameData.points;
            totalRebounds += gameData.rebounds;
            totalAssists += gameData.assists;
            totalSteals += gameData.steals;
            totalBlocks += gameData.blocks;
          }

          double averagePoints = totalPoints / games.length;
          double averageRebounds = totalRebounds / games.length;
          double averageAssists = totalAssists / games.length;
          double averageSteals = totalSteals / games.length;
          double averageBlocks = totalBlocks / games.length;

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Averages across all games:',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 10),
                Text('Average Points: ${averagePoints.toStringAsFixed(2)}ppg'),
                Text('Average Rebounds: ${averageRebounds.toStringAsFixed(2)}rpg'),
                Text('Average Assists: ${averageAssists.toStringAsFixed(2)}apg'),
                Text('Average Steals: ${averageSteals.toStringAsFixed(2)}spg'),
                Text('Average Blocks: ${averageBlocks.toStringAsFixed(2)}bpg'),
              ],
            ),
          );
        },
      ),
    );
  }
}
