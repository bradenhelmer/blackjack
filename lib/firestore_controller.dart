// firestore_controller.dart
// -------------------------
// Implements the FirestoreController class for read/write operations.
import "package:blackjack/user.dart";
import "package:cloud_firestore/cloud_firestore.dart";

class FirestoreController {
  final db = FirebaseFirestore.instance;
  String collectionName = "Users";

  void createUser(String uId, String email) {
    final user = <String, dynamic>{
      "id": uId,
      "email": email,
      "gamesPlayed": 0,
      "gamesWon": 0,
      "winRate": 0,
    };
    db.collection(collectionName).doc(uId).set(user);
  }

  Future<QuerySnapshot<BlackJackUser>> getUsersForLeaderboards() async {
    final queryDocRef = db
        .collection(collectionName)
        .orderBy("winRate", descending: true)
        .limit(50)
        .withConverter(
            fromFirestore: BlackJackUser.fromFirestore,
            toFirestore: (BlackJackUser user, _) =>
                BlackJackUser().toFirestore());
    return await queryDocRef.get();
  }

  void updateUser(String? id, int games, int wins) {
    db.collection(collectionName).doc(id).update({
      "gamesPlayed": FieldValue.increment(games),
      "gamesWon": FieldValue.increment(wins)
    });
  }

  Future<DocumentSnapshot<BlackJackUser>> getUserById(String? id) async {
    final docRef = db.collection(collectionName).doc(id).withConverter(
        fromFirestore: BlackJackUser.fromFirestore,
        toFirestore: (BlackJackUser user, _) => BlackJackUser().toFirestore());
    return await docRef.get();
  }
}
