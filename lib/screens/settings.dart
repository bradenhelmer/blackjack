import 'package:flutter/material.dart';
import 'package:blackjack/screens/home.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen(this.prefs, {super.key});

  final SharedPreferences prefs;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // variable to access user input
  TextEditingController? userText;
  int? initialCount;

  @override
  void initState() {
    initialCount = widget.prefs.getInt('deckCount');
    userText = TextEditingController(text: initialCount.toString());
    super.initState();
  }

  @override
  void dispose() {
    userText!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Blackjack!"),
        backgroundColor: Colors.black,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_outlined),
            onPressed: () {
              int postCount = int.parse(userText!.text);
              if (postCount != initialCount) {
                widget.prefs.setInt("deckCount", postCount);
              }
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => HomeScreen()));
            }),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Dealer Deck Count'),
                const SizedBox(
                  width: 100,
                  height: 10,
                ),
                SizedBox(
                  width: 50,
                  height: 20,
                  child: TextField(
                    //assigning user text controller
                    controller: userText,
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(1),
                      LimitRange(2, 6),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

// This class serves as a means to limit the user input
// to 2-6 for the dealer deck count.
// The source for this code can be found at the following link
// https://stackoverflow.com/questions/71507522/flutter-text-field-allow-user-to-insertion-of-a-number-within-a-given-range-only

class LimitRange extends TextInputFormatter {
  LimitRange(
    this.minRange,
    this.maxRange,
  ) : assert(
          minRange < maxRange,
        );

  final int minRange;
  final int maxRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    var value = int.parse(newValue.text);
    if (value < minRange) {
      return TextEditingValue(text: minRange.toString());
    } else if (value > maxRange) {
      return TextEditingValue(text: maxRange.toString());
    }
    return newValue;
  }
}
