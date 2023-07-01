import 'package:blackjack/game_controller.dart';
import 'package:blackjack/custom_widgets/card.dart';
import 'package:blackjack/custom_widgets/basic_strategy_modal.dart';
import 'package:flutter/material.dart';
import 'package:blackjack/custom_widgets/play_screen_exit_alert.dart';
import 'package:blackjack/custom_widgets/score_display.dart';
import 'package:blackjack/custom_widgets/play_again.dart';
import 'dart:math';

class PlayScreen extends StatefulWidget {
  PlayScreen(this.deckCount, {super.key});

  final int deckCount;

  /*
    Used to create "stacked" affect for the cards.
    See custom_widgets/card.dart for more details
  */
  static const double cardOffsetMult = 20;

  //Using a Queue of widgets to hold player and dealer cards

  // Used to tell blackjack card to hide its value
  String dealerFaceDownCardCode = 'backOfCard';
  SlideTransition? dealerFaceDownCard;

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen>
    with SingleTickerProviderStateMixin {
  // Used to control game flow and check game progess
  late BJGameController gameInstance;

  List<SlideTransition> playerCards = <SlideTransition>[];

  List<SlideTransition> playerSplitCards = <SlideTransition>[];

  List<SlideTransition> dealerCards = <SlideTransition>[];

  bool dealerDone = false;
  /* 
    The following are used to create animations for the playerHit, Dealer Hit,
  and split (in that order)
  */

  late AnimationController? control = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late Animation<double>? rot = Tween<double>(
    begin: .15,
    end: 2 * pi,
  ).animate(CurvedAnimation(parent: control!, curve: Curves.decelerate));

  // Giving the user and dealer two cards at the beginning of each game
  @override
  void initState() {
    gameInstance = BJGameController(widget.deckCount);
    _addCard();
    _addCard();

    _addDealerCard(isFaceDown: true);
    _addDealerCard();

    /* 
    Setting the method belows paramter to false ensures that the second card is
    revelaed.
    */
    widget.dealerFaceDownCard = addTrasl(
        offsetX: 0,
        offsetY: 0,
        isDealer: true,
        isFaceDown: false,
        key: widget.dealerFaceDownCardCode,
        isFlip: true,
        isSplit: false);

    super.initState();
  }

  String _getCardKey(bool isDealer, bool isFaceDown, bool isSplit) {
    if (isDealer & isFaceDown) {
      return 'FDC';
    }
    if ((isDealer)) {
      return gameInstance.dealerHand.removeAt(0);
    } else if (isSplit) {
      return gameInstance.playerSplitHand.removeAt(0);
    } else {
      gameInstance.splitSave = gameInstance.playerHand[0];
      return gameInstance.playerHand.removeAt(0);
    }
  }

  SlideTransition addTrasl(
      {required double offsetX,
      required double offsetY,
      required bool isDealer,
      required bool isFaceDown,
      required bool isSplit,
      String key = '',
      bool isFlip = false}) {
    if (isDealer & isFaceDown) {
      widget.dealerFaceDownCardCode = gameInstance.dealerHand.removeAt(0);
    }
    return SlideTransition(
        position: Tween<Offset>(
          begin: Offset(offsetX, offsetY),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: control!, curve: Curves.decelerate)),
        child: Transform(
            transform: Matrix4.rotationZ(0),
            alignment: Alignment.center,
            child: BlackjackCard(
                cardOffset: isFlip
                    ? 0
                    : isDealer
                        ? dealerCards.length * PlayScreen.cardOffsetMult
                        : isSplit
                            ? playerSplitCards.length *
                                PlayScreen.cardOffsetMult
                            : playerCards.length * PlayScreen.cardOffsetMult,
                cardKey: key.isNotEmpty
                    ? key
                    : _getCardKey(isDealer, isFaceDown, isSplit))));
  }

  // Adds blackjack cards to the player's hand
  void _addCard() {
    setState(() {
      // Adding the card to the queue
      playerCards.add(addTrasl(
          offsetX: 0,
          offsetY: -25,
          isDealer: false,
          isFaceDown: false,
          isSplit: false));
      control!.forward();
      if (gameInstance.dealerTurn) {
        _dealerDrawCards();
      }
    });
  }

  void _addSplitCard() {
    setState(() {
      // Adding the card to the queue
      playerSplitCards.add(addTrasl(
          offsetX: 0,
          offsetY: -25,
          isDealer: false,
          isFaceDown: false,
          isSplit: true));
      control!.forward();
      // if (gameInstance.dealerTurn) {
      //   _dealerDrawCards();
      // }
    });
  }

  // Adds black jack cards to dealers hand
  // isFaceDown is used to hide one of the dealer intial cards
  void _addDealerCard({bool isFaceDown = false}) {
    if (isFaceDown) {
      setState(() {
        control!.forward();
        // Adding the card to the queue
        dealerCards.add(addTrasl(
            offsetX: 0,
            offsetY: -25,
            isDealer: true,
            isFaceDown: isFaceDown,
            isSplit: false));
      });
    } else {
      setState(() {
        control!.forward();
        // Adding the card to the queue
        dealerCards.add(addTrasl(
            offsetX: 0,
            offsetY: -25,
            isDealer: true,
            isFaceDown: isFaceDown,
            isSplit: false));
      });
    }
  }

  // Recursively draws the dealers cards with a delay of 1 second.
  void _dealerDrawCards() async {
    if (dealerCards[0] != widget.dealerFaceDownCard) {
      setState(() {});
      dealerDone = true;
      dealerCards[0] = widget.dealerFaceDownCard as SlideTransition;
    }
    if (gameInstance.dealerHand.isEmpty) {
      showDialog(
          context: context,
          builder: (context) => PlayAgainDialog(
              winCode: gameInstance.result, deckCount: widget.deckCount)).then((value) => null);
      return;
    } else {
      _addDealerCard();
      await Future.delayed(const Duration(seconds: 1))
          .then((value) => _dealerDrawCards());
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Play"),
            backgroundColor: Colors.black,
            leading: IconButton(
              icon: const Icon(Icons.door_back_door_rounded),
              onPressed: () => showDialog(
                context: context,
                // Using the ExitGameDialog widget to make sure
                // the user wants to return home
                builder: (context) => const ExitGameDialog(),
              ),
            )),
        //
        // Start of layout
        body: Center(
          /*
          Using container to house the background image 
          */
          child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image:
                          AssetImage("assets/images/playscreen_background.jpg"),
                      fit: BoxFit.fill)),
              child: Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Column(
                  // ignore: sort_child_properties_last
                  children: <Widget>[
                    //
                    // Creating Flex space to create first row in layout
                    // This row will contain two containers
                    // The first contianer will hold the dealers card widgets
                    // The second will be the score
                    //
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              //
                              // Container for the dealer card widgets
                              //

                              child: Container(
                                // This list will house the cards for the dealer
                                alignment: Alignment.center,
                                child: AnimatedBuilder(
                                  animation: control!,
                                  builder: (_, child) => Stack(
                                    children: dealerCards.toList(),
                                  ),
                                ),
                              )),

                          //
                          // Creating a sized box for spacing
                          //
                          const SizedBox(
                            width: 5,
                          ),
                          //
                          // Second item in row
                          //
                          Flexible(
                            flex: 1,
                            fit: FlexFit.tight,
                            //
                            // Container for the dealer score
                            //
                            child: dealerDone
                                ? BlackJackScoreDisplay(
                                    text:
                                        gameInstance.dealerScore.returnScore())
                                : Container(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 14,
                    ),
                    Flexible(
                      flex: 3,
                      fit: FlexFit.tight,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 2,
                            fit: FlexFit.tight,

                            // Player score drawn in this container
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                BlackJackScoreDisplay(
                                    text:
                                        gameInstance.playerScore.returnScore()),
                                BlackJackScoreDisplay(
                                    text: gameInstance.playerSplitScore
                                        .returnScore()),
                              ],
                            ),
                          ),

                          //divider
                          const SizedBox(
                            width: 5,
                          ),

                          // Start of player card container

                          Flexible(
                            flex: 4,
                            fit: FlexFit.loose,

                            // Container to hold animated list of Blackjack cards

                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  alignment: Alignment.center,
                                  child: AnimatedBuilder(
                                      animation: control!,
                                      builder: (_, child) => Stack(
                                            children: playerCards.toList(),
                                          )),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  child: AnimatedBuilder(
                                      animation: control!,
                                      builder: (_, child) => Stack(
                                            children: playerSplitCards.toList(),
                                          )),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15, right: 15, bottom: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(36, 255, 255, 255),
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: const [
                                BoxShadow(
                                    spreadRadius: 25,
                                    color: Color.fromARGB(143, 0, 0, 0),
                                    blurRadius: 25)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                // Start of the Hit Button

                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,

                                  // container for hit button

                                  child: Container(
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(73, 0, 0, 0),
                                          spreadRadius: 4,
                                          blurRadius: 10),
                                    ]),
                                    height: 50, //BoxDecoration
                                    child: ElevatedButton(
                                      // Calling method to draw card on screen
                                      onPressed: (gameInstance.dealerTurn
                                          ? null
                                          : (() {
                                              if (gameInstance.playerTurn) {
                                                gameInstance.hit();
                                                _addCard();
                                              } else {
                                                gameInstance.hit();
                                                _addSplitCard();
                                              }
                                            })),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 45, 177, 50),
                                        textStyle:
                                            const TextStyle(fontSize: 16),
                                        shadowColor:
                                            const Color.fromARGB(227, 0, 0, 0),
                                        elevation: 7,
                                      ),
                                      child: const Text('HIT'),
                                    ),
                                  ), //Container
                                ), //Flexible
                                const SizedBox(
                                  width: 20,
                                ), //SizedBox
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(73, 0, 0, 0),
                                          spreadRadius: 4,
                                          blurRadius: 10),
                                    ]),
                                    height: 50, //BoxDecoration
                                    child: ElevatedButton(
                                      // Calling method to draw card on screen
                                      onPressed: (gameInstance.dealerTurn
                                          ? null
                                          : (() {
                                              gameInstance.stand();
                                              gameInstance.dealerTurn
                                                  ? _dealerDrawCards()
                                                  : null;
                                            })),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 45, 177, 50),
                                        textStyle: const TextStyle(fontSize: 9),
                                        shadowColor:
                                            const Color.fromARGB(227, 0, 0, 0),
                                        elevation: 7,
                                      ),
                                      child: const Text('STAND'),
                                    ),
                                  ), //Container
                                ),
                                const SizedBox(width: 20),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    decoration: const BoxDecoration(boxShadow: [
                                      BoxShadow(
                                          color: Color.fromARGB(73, 0, 0, 0),
                                          spreadRadius: 4,
                                          blurRadius: 10),
                                    ]),
                                    height: 50, //BoxDecoration
                                    child: ElevatedButton(
                                      // Calling method to draw card on screen
                                      onPressed: (!gameInstance.canSplit
                                          ? null
                                          : (() {
                                              gameInstance.split();
                                              playerCards.removeAt(1);
                                              _addSplitCard();
                                            })),

                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 45, 177, 50),
                                        textStyle: const TextStyle(fontSize: 9),
                                        shadowColor:
                                            const Color.fromARGB(227, 0, 0, 0),
                                        elevation: 7,
                                      ),
                                      child: const Text('SPLIT'),
                                    ),
                                  ), //Container
                                ),
                                const SizedBox(width: 20),
                                Flexible(
                                  flex: 1,
                                  fit: FlexFit.tight,
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(400),
                                      color: Colors.black54,
                                    ), //BoxDecoration
                                    child: ElevatedButton(
                                      // Calling method to draw card on screen
                                      onPressed: () async {
                                        await showDialog(
                                            context: context,
                                            builder: (_) =>
                                                const BasicStrategyDialog());
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color.fromARGB(
                                            255, 45, 177, 50),
                                        textStyle: const TextStyle(fontSize: 9),
                                        shadowColor:
                                            const Color.fromARGB(227, 0, 0, 0),
                                        elevation: 7,
                                      ),
                                      child: const Text('BASIC'),
                                    ),
                                  ), //Container
                                ),
                                //Flexible
                              ], //<Widget>[]
                            ),
                          ),
                        ),
                      ), //Row
                    ), //Flexible
                  ], //<Widget>[]
                ), //Column
              ) //Padding
              ), //Container
        ) //Container
        ); //Scaffold
  }
}
