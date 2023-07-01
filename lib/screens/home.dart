// home.dart
// ---------
// Implements the home screen.
import 'package:blackjack/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:blackjack/screens/settings.dart';
import 'package:flutter/material.dart';
import 'package:blackjack/screens/about.dart';
import 'package:blackjack/firestore_controller.dart';
import 'package:blackjack/screens/play.dart';
import 'package:blackjack/screens/leaderboards.dart';
import 'package:blackjack/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  FirestoreController controller = FirestoreController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blackjack!"),
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: const Icon(Icons.question_mark),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()));
            }),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(top: 25),
                child: Image.asset(
                  "assets/images/home_picture.jpeg",
                  width: 125,
                  height: 150,
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 45),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await SharedPreferences.getInstance()
                        .then((SharedPreferences prefs) {
                      int? deckCount = prefs.getInt('deckCount');
                      if (deckCount == null) {
                        prefs.setInt("deckCount", 2);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  PlayScreen(prefs.getInt("deckCount")!)));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    minimumSize: const Size(250, 60),
                  ),
                  child: const Text("Play"),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    controller
                        .getUsersForLeaderboards()
                        .then((QuerySnapshot<BlackJackUser> users) {
                      List<DocumentSnapshot<BlackJackUser>> docs = users.docs;
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LeaderboardScreen(docs: docs)));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    minimumSize: const Size(250, 60),
                  ),
                  child: const Text(
                    "Leaderboard",
                    style: TextStyle(),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await SharedPreferences.getInstance()
                        .then((SharedPreferences prefs) {
                      int? deckCount = prefs.getInt('deckCount');
                      if (deckCount == null) {
                        prefs.setInt("deckCount", 2);
                      }
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingsScreen(prefs)));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    minimumSize: const Size(250, 60),
                  ),
                  child: const Text("Settings"),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().then(
                      (value) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()));
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32)),
                    minimumSize: const Size(250, 60),
                  ),
                  child: const Text("Log out"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
