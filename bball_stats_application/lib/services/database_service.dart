import 'package:bball_stats_application/models/game.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const String GAME_COLLECTION = 'games';

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _gamesRef;

  DatabaseService() {
    _gamesRef = _firestore.collection(GAME_COLLECTION).withConverter<Game>(
        fromFirestore: (snapshots, _) => Game.fromJson(
              snapshots.data()!,
            ),
        toFirestore: (game, _) => game.toJson());
  }

  Stream<QuerySnapshot> getGames() {
    return _gamesRef.snapshots();
  }

  void addGame(Game game) async {
    _gamesRef.add(game);
  }

  
  void updateGame(String gameId, Game game) {
    _gamesRef.doc(gameId).update(game.toJson());
  }

  void deleteGame(String gameId) {
    _gamesRef.doc(gameId).delete();
  }
}
