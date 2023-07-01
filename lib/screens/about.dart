// about.dart
// ----------
// Implements the about page.
import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("About Page"),
          backgroundColor: Colors.black,
        ),
        body: const Center(
            child: Text(
                "This app was created by Cullin Capps and Braden Helmer",
                style: TextStyle(fontSize: 55),
                textAlign: TextAlign.center)));
  }
}
