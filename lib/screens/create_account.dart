// create_account.dart
// -------------------
// Implements the create account screen.
import "package:blackjack/firestore_controller.dart";
import "package:blackjack/screens/home.dart";
import "package:email_validator/email_validator.dart";
import "package:flutter/material.dart";
import "package:flutter_pw_validator/flutter_pw_validator.dart";
import "package:firebase_auth/firebase_auth.dart";

class CreateAccountScreen extends StatelessWidget {
  CreateAccountScreen({super.key});

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirestoreController readWrite = FirestoreController();
  late final emailController = TextEditingController();
  late final confirmEmailController = TextEditingController();
  late final passwordController = TextEditingController();
  late final confrimPasswordController = TextEditingController();
  late final List<TextEditingController> controllerList = [
    emailController,
    confirmEmailController,
    passwordController,
    confrimPasswordController
  ];

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void clear() {
    for (int i = 0; i < 4; i++) {
      controllerList[i].clear();
    }
  }

  bool passwordChecker(String? pw) {
    if (pw != null) {
      bool upperCase = pw.contains(RegExp(r'[A-Z]'));
      bool length = pw.length >= 8;
      bool numeric = pw.contains(RegExp(r'[0-9]'));
      bool special = pw.contains(RegExp(r'[$&+,:;=?@#|<>.^*()%!-]'));
      return length && numeric && upperCase && special;
    }
    return false;
  }

  void registerCreateUserEntry(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Creating Account...")));
      try {
        await auth
            .createUserWithEmailAndPassword(
                email: controllerList[0].text, password: controllerList[2].text)
            .then((UserCredential userCred) async {
          User? user = userCred.user;
          if (user != null) {
            readWrite.createUser(user.uid, controllerList[1].text);
            await auth
                .signInWithEmailAndPassword(
                    email: controllerList[0].text,
                    password: controllerList[2].text)
                .then((UserCredential credential) async {
              MaterialPageRoute(builder: (context) => HomeScreen());
            });
          }
          return userCred;
        });
      } on FirebaseAuthException catch (e) {
        if (e.code == 'email-already-in-use') {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("An account with that email already exists!")));
        }
        clear();
      } catch (e) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Unknown Error")));
        clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black, title: const Text("Create Account")),
        body: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                          controller: controllerList[0],
                          validator: (String? email) {
                            if (email == null ||
                                email.isEmpty ||
                                !EmailValidator.validate(email)) {
                              return "Invalid Email Address!";
                            }
                            if (email != controllerList[1].text) {
                              return "Emails don't match!";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Email'))),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                          controller: controllerList[1],
                          validator: (String? email) {
                            if (email != controllerList[0].text) {
                              return "Emails don't match!";
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirm Email'))),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                          obscureText: true,
                          validator: (String? password) {
                            if (!passwordChecker(password)) {
                              return "Password does not meet requirements!";
                            }
                            if (password != controllerList[3].text) {
                              return "Passwords don't match!";
                            }
                            return null;
                          },
                          controller: controllerList[2],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Enter Password'))),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: FlutterPwValidator(
                        controller: controllerList[2],
                        minLength: 8,
                        uppercaseCharCount: 1,
                        numericCharCount: 1,
                        specialCharCount: 1,
                        width: 400,
                        height: 150,
                        onSuccess: () {}),
                  ),
                  Padding(
                      padding: const EdgeInsets.all(10),
                      child: TextFormField(
                          validator: (String? password) {
                            if (password != controllerList[2].text) {
                              return "Passwords dont match!";
                            }
                            return null;
                          },
                          obscureText: true,
                          controller: controllerList[3],
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confrim Password'))),
                  Center(
                      child: ElevatedButton(
                          onPressed: () => registerCreateUserEntry(context),
                          style: const ButtonStyle(
                              backgroundColor:
                                  MaterialStatePropertyAll<Color>(Colors.red)),
                          child: const Text("Create Account",
                              style: TextStyle(
                                  color: Colors.white, fontSize: 30))))
                ])));
  }
}
