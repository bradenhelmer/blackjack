import 'package:blackjack/constants.dart';
import "package:flutter/material.dart";
import 'dart:math';

class BlackjackCard extends StatefulWidget {
  const BlackjackCard(
      {required this.cardOffset, required this.cardKey, super.key});
  final String cardKey;
  final double cardOffset;

  @override
  State<BlackjackCard> createState() => BlackjackCardState();
}

class BlackjackCardState extends State<BlackjackCard>
    with SingleTickerProviderStateMixin {
  AnimationController? control;
  Animation<double>? rot;
  Animation<Offset>? trasl;

  @override
  void initState() {
    super.initState();

    control = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    rot = Tween<double>(
      begin: .15,
      end: 2 * pi,
    ).animate(CurvedAnimation(parent: control!, curve: Curves.easeInOut));

    control!.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: SizedBox(
        height: 125,
        width: 110 + widget.cardOffset,
        child: Container(
          alignment: Alignment.topRight,
          decoration: BoxDecoration(
              border: Border.all(width: 1),
              borderRadius: BorderRadius.circular(4)),
          child: Image.asset(
            'assets/images/playing_cards/${playingCards[widget.cardKey]}',
            width: 110,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
