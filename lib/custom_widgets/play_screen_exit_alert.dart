import 'package:flutter/material.dart';
import 'package:blackjack/screens/home.dart';

class ExitGameDialog extends StatelessWidget {
  const ExitGameDialog({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('RETURN TO HOME'),
      content: const Text('Are you sure you want to exit?'),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HomeScreen())),
            child: const Text('Yes')),
        TextButton(
            onPressed: () => Navigator.pop(context, 'no'),
            child: const Text('No'))
      ],
    );
  }
}
