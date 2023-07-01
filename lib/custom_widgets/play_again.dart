import 'package:flutter/material.dart';
import 'package:blackjack/screens/play.dart';
import 'package:blackjack/screens/home.dart';

class PlayAgainDialog extends StatelessWidget {
  const PlayAgainDialog(
      {super.key, required this.winCode, required this.deckCount});
  final String winCode;
  final int deckCount;

  String craftMessage() {
    String message = "";

    for (int i = 0; i < winCode.length; i++) {
      switch (winCode[i]) {
        case "W":
          message += "Win";
          break;
        case "P":
          message += "Push";
          break;
        case "L":
          message += "Lose";
          break;
      }
      message += " ";
    }
    return message;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Result: ${craftMessage()} '),
      content: const Text('Would you like to play again?'),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => PlayScreen(deckCount))),
            child: const Text('Yes')),
        TextButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen())),
            child: const Text('No')),
      ],
    );
  }
}
