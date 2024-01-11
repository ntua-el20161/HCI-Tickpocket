import 'package:flutter/material.dart';
import 'package:tickpocket_app/routes/login.dart';
import 'package:tickpocket_app/routes/registerpage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegister();
}

class _LoginOrRegister extends State<LoginOrRegister> {
  //initially show the login screen
  bool SignedUp = true;

  //toggle between login and register page
  void togglePages() {
    setState(() {
      SignedUp = !SignedUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (SignedUp) {
      return LoginPage(
        notRegistered: () {
          setState(() {
            SignedUp = false;
          });
        },
      );
    } else {
      return const RegisterPage();
    }
  }
}
