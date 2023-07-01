// reset_password.dart
// -------------------
// Implements the reset password screen.
import "package:flutter/material.dart";

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black, title: const Text("Reset Password")),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Padding(
                  padding: EdgeInsets.all(14),
                  child: TextField(
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: 'Email'))),
              Padding(
                  padding: EdgeInsets.all(14),
                  child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Old Password'))),
              Padding(
                  padding: EdgeInsets.all(14),
                  child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'New Password'))),
              Padding(
                  padding: EdgeInsets.all(14),
                  child: TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Confrim New Password'))),
              Center(
                  child: ElevatedButton(
                      onPressed: null,
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll<Color>(Colors.indigo)),
                      child: Text("Reset Password",
                          style: TextStyle(color: Colors.white, fontSize: 30))))
            ]));
  }
}
