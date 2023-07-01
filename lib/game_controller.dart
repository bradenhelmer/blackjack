// game_controller.dart
// --------------------
// Backend blackjack game engine.
import "package:blackjack/constants.dart";
import "package:firebase_auth/firebase_auth.dart";
import "package:blackjack/firestore_controller.dart";
import "package:blackjack/custom_widgets/score.dart";

class BJGameController {
  FirestoreController rw = FirestoreController();
  User? currentUser = FirebaseAuth.instance.currentUser;
  List<String> playerHand = [];
  List<String> playerSplitHand = [];
  List<String> dealerHand = [];
  List<String> deck = [];
  BlackJackScore playerScore = BlackJackScore();
  BlackJackScore playerSplitScore = BlackJackScore();
  BlackJackScore dealerScore = BlackJackScore();
  bool playerSplitTurn = false;
  bool playerTurn = false;
  bool dealerTurn = false;
  bool canSplit = false;
  int deckCount;
  String result = "";
  String splitSave = "";
  Map<String, dynamic> winCodes = {
    "WW": 2,
    "WL": 1,
    "LL": 0,
    "WP": 1,
    "PL": 0,
    "PP": 0,
    "W": 1,
    "L": 0,
    "P": 0,
  };

  BJGameController(this.deckCount) {
    shuffleDeck();
    deal();
  }

  // Checks game states and crafts result code for drawing controller and firebase update.
  void gameCheck() {
    String craftResult = "";
    bool dealerBust = dealerScore.getBestScore() > 21;
    bool playerSplitBust = playerSplitScore.getBestScore() > 21;
    bool playerBust = playerScore.getBestScore() > 21;

    // Gets player split hand result if split in play
    if (playerSplitHand.isNotEmpty) {
      if (playerSplitBust && dealerBust) {
        craftResult += "L";
      } else if (dealerBust && !playerSplitBust) {
        craftResult += "W";
      } else if (!dealerBust && !playerSplitBust) {
        playerSplitScore.getBestScore() == dealerScore.getBestScore()
            ? craftResult += "P"
            : playerSplitScore.getBestScore() > dealerScore.getBestScore()
                ? craftResult += "W"
                : craftResult += "L";
      }
    }
    // Gets player main hand result
    if (playerBust && dealerBust) {
      craftResult += "L";
    } else if (playerBust && !dealerBust) {
      craftResult += "L";
    } else if (dealerBust && !playerBust) {
      craftResult += "W";
    } else if (!dealerBust && !playerBust) {
      playerScore.getBestScore() == dealerScore.getBestScore()
          ? craftResult += "P"
          : playerScore.getBestScore() > dealerScore.getBestScore()
              ? craftResult += "W"
              : craftResult += "L";
    }
    result = craftResult;
  }

  void gamePushResult() {
    rw.updateUser(currentUser?.uid, result.length, winCodes[result]);
  }

  void resetGame() {
    playerHand = [];
    playerSplitHand = [];
    dealerHand = [];
    playerScore.resetScore();
    playerSplitScore.resetScore();
    dealerScore.resetScore();
    playerTurn = false;
    playerSplitTurn = false;
    dealerTurn = false;
    shuffleDeck();
  }

  void shuffleDeck() {
    deck = [];
    for (int i = 0; i < deckCount; i++) {
      cardIds.shuffle();
      deck.addAll(cardIds);
    }
    deck.shuffle();
  }

  void startGame() {
    resetGame();
    deal();
  }

  void deal() {
    playerTurn = true;
    hit();
    hit();
    playerTurn = false;
    dealerTurn = true;
    _dealerHit();
    _dealerHit();
    dealerTurn = false;
    playerTurn = true;
    canSplit = playerSplitHand.isEmpty &&
        playerHand.length == 2 &&
        playerHand[0][0] == playerHand[1][0] &&
        !playerSplitTurn;
  }

  // Starts dealer turn
  void _dealerDraw() {
    while (dealerScore.getScore() < 17) {
      _dealerHit();
    }
    gameCheck();
  }

  // Dealer plays, stands at 16.
  void _dealerHit() {
    String card = deck.removeAt(0);
    dealerHand.add(card);
    dealerScore.setScore(card[0]);
  }

  // Player draws hard into split hand or normal hand
  // Goes in onPressed for hit button
  void hit() {
    String card = deck.removeAt(0);

    if (playerSplitTurn) {
      playerSplitHand.add(card);
      playerSplitScore.setScore(card[0]);
    } else {
      // playerHand.add(card);
      playerHand.add(card);
      playerScore.setScore(card[0]);
    }

    if (playerSplitTurn && (playerSplitScore.getScore() > 21)) {
      playerSplitTurn = false;
      playerTurn = true;
    }
    if (playerScore.getScore() > 21) {
      playerTurn = false;
      dealerTurn = true;
      _dealerDraw();
    }
  }

  // Goes in onPressed for stand button
  void stand() {
    if (playerSplitTurn) {
      playerSplitTurn = false;
      playerTurn = true;
    } else {
      playerTurn = false;
      dealerTurn = true;
      _dealerDraw();
    }
  }

  // Goes in onPressed for the split button
  void split() {
    playerTurn = false;
    playerSplitTurn = true;
    playerSplitHand.add(splitSave);
    playerScore.updateSplitScore(splitSave[0]);
    playerSplitScore.updateSplitScore(splitSave[0]);
  }
}
