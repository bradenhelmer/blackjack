// login.dart
// ----------
// Implements the login screen.
import "package:flutter/material.dart";
import "package:blackjack/screens/home.dart";
import "package:blackjack/screens/about.dart";
import "package:blackjack/screens/create_account.dart";
import "package:blackjack/screens/reset_password.dart";
import "package:firebase_auth/firebase_auth.dart";

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;
  late final emailController = TextEditingController();
  late final passwordController = TextEditingController();
  late final List<TextEditingController> controllerList = [
    emailController,
    passwordController
  ];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void clear() {
    for (int i = 0; i < 2; i++) {
      controllerList[i].clear();
    }
  }

  void login(BuildContext context) async {
    try {
      await auth
          .signInWithEmailAndPassword(
              email: controllerList[0].text.replaceAll(" ", ""), password: controllerList[1].text)
          .then((UserCredential credential) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomeScreen()));
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content:
                Text("No account was found associated with that account")));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text("Invalid password for that account!")));
      }
      clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Login"),
        leading: IconButton(
            icon: const Icon(Icons.question_mark),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AboutScreen()));
            }),
      ),
      resizeToAvoidBottomInset: false,
      body: Form(
          key: _formKey,
          child: Column(children: [
            Image.asset('assets/images/home_picture.jpeg',
                width: 125, height: 200),
            const Text("BLACKJACK TRAINER", style: TextStyle(fontSize: 30)),
            Padding(
                padding: const EdgeInsets.all(14),
                child: TextFormField(
                    autofocus: true,
                    controller: controllerList[0],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Email'))),
            Padding(
                padding: const EdgeInsets.all(14),
                child: TextField(
                    obscureText: true,
                    controller: controllerList[1],
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Password'))),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              ElevatedButton(
                  onPressed: () => login(context),
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.black)),
                  child: const Text("Login",
                      style: TextStyle(color: Colors.white, fontSize: 30))),
              ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CreateAccountScreen()));
                  },
                  style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.red)),
                  child: const Text("Create Account",
                      style: TextStyle(color: Colors.white, fontSize: 30)))
            ]),
            Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ResetPasswordScreen()));
                    },
                    child: const Text("Reset Password",
                        style: TextStyle(color: Colors.indigo)))),
          ])),
    );
  }
}
