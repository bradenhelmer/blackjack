import 'package:flutter/material.dart';

class BlackJackScoreDisplay extends StatelessWidget {
  const BlackJackScoreDisplay({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text.contains("4")
          ? text.replaceAll("4", "5")
          : text.contains("5")
              ? text.replaceAll("5", "4")
              : text,
      style: TextStyle(
          fontSize: text == "Blackjack!" ? 20 : 44, fontFamily: "Casino"),
      textAlign: TextAlign.center,
    );
  }
}
