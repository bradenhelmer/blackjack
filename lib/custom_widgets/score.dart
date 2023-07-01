import 'package:blackjack/constants.dart';
import "dart:math";

class BlackJackScore {
  int score1 = 0;
  int score2 = 0;
  int cardCount = 0;

  void resetScore() {
    score1 = 0;
    score2 = 0;
    cardCount = 0;
  }

  int getScore() {
    return min(score1, score2);
  }

  void updateSplitScore(String cardPointIdentifier) {
    if (cardPointIdentifier == "A") {
      score1 = 1;
      score2 = 11;
    } else if (faceCards.contains(cardPointIdentifier)) {
      score1 = 10;
      score2 = 10;
    } else {
      score1 += int.parse(cardPointIdentifier);
      score2 += int.parse(cardPointIdentifier);
    }
    cardCount = 1;
  }

  void setScore(String cardPointIdentifier) {
    // Ace handling
    if (cardPointIdentifier == "A") {
      score1 != score2 ? score2 += 1 : score2 += 11;
      score1 += 1;
    } else if (faceCards.contains(cardPointIdentifier)) {
      score1 += 10;
      score2 += 10;
    } else {
      score1 += int.parse(cardPointIdentifier);
      score2 += int.parse(cardPointIdentifier);
    }
    if (score2 >= 22) {
      score2 = score1;
    }
    cardCount += 1;
  }

  int getBestScore() {
    return (score1 != score2) && (score1 <= 21 && score2 <= 21)
        ? max(score1, score2)
        : score1;
  }

  String returnScore() {
    if (getScore() > 21) {
      return "Bust!";
    } else if (cardCount == 2 && score2 == 21) {
      return "Blackjack!";
    } else if (score1 != score2) {
      return "$score1/$score2";
    } else if (score1 == 0) {
      return "";
    } else {
      return "${getScore()}";
    }
  }
}
