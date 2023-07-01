// user.dart
// ---------
// Implements BlackJackUser class.
import "package:cloud_firestore/cloud_firestore.dart";

class BlackJackUser {
  final String? id;
  final String? email;
  final int? gamesPlayed;
  final int? gamesWon;
  final double? winRate;

  BlackJackUser({
    this.id,
    this.email,
    this.gamesPlayed,
    this.gamesWon,
    this.winRate,
  });

  factory BlackJackUser.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return BlackJackUser(
        id: snapshot.id,
        email: data?['email'],
        gamesWon: data?['gamesWon'],
        gamesPlayed: data?['gamesPlayed'],
        winRate: data?['winRate'].toDouble());
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (id != null) "id": id,
      if (email != null) "email": email,
      if (gamesWon != null) "gamesWon": gamesWon,
      if (gamesPlayed != null) "gamesPlayed": gamesPlayed,
      if (winRate != null) "winRate": winRate,
    };
  }
}
