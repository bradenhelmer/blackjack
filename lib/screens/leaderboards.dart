import 'package:blackjack/firestore_controller.dart';
import 'package:blackjack/screens/home.dart';
import 'package:blackjack/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeaderboardScreen extends StatefulWidget {
  LeaderboardScreen({super.key, required this.docs});
  final List<DocumentSnapshot<BlackJackUser>> docs;

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final FirestoreController controller = FirestoreController();
  final TextEditingController editingController = TextEditingController();
  List<DocumentSnapshot<BlackJackUser>> searchDocs = [];

  @override
  void initState() {
    searchDocs.addAll(widget.docs);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Leaderboard"),
            backgroundColor: Colors.black,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_outlined),
                onPressed: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                })),
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/playscreen_background.jpg"),
                  fit: BoxFit.fill)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  onChanged: ((value) {
                    filterSearchResults(value);
                  }),
                  controller: editingController,
                  decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: "Search",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.all(Radius.circular(25.0)))),
                ),
              ),
              _createLeaderboard(),
            ],
          ),
        ));
  }

  void filterSearchResults(String query) {
    List<DocumentSnapshot<BlackJackUser>> dummySearchList = [];
    dummySearchList.addAll(widget.docs);

    if (query.isNotEmpty) {
      List<DocumentSnapshot<BlackJackUser>> dummyListData = [];
      dummySearchList.forEach((DocumentSnapshot<BlackJackUser> item) {
        if (item.data()!.email!.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        searchDocs.clear();
        searchDocs.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        searchDocs.clear();
        searchDocs.addAll(widget.docs);
      });
    }
  }

  Flexible _createLeaderboard() {
    return Flexible(
      flex: 1,
      child: SizedBox(
        height: 500,
        child: ListView.builder(
            itemCount: searchDocs.length,
            itemBuilder: (_, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 40.0, right: 40, top: 10),
                child: Card(
                  elevation: 4,
                  shadowColor: const Color.fromARGB(255, 255, 206, 222),
                  child: ListTile(
                    title: Text(
                        '${index + 1}. ${searchDocs[index].data()?.email?.substring(0, 4)}'),
                    subtitle:
                        Text('Win rate: ${searchDocs[index].data()?.winRate}%'),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
