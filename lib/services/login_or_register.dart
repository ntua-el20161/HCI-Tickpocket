import 'package:flutter/material.dart';
import 'package:tickpocket_app/screens/login.dart';
import 'package:tickpocket_app/screens/registerpage.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegister();
}

class _LoginOrRegister extends State<LoginOrRegister> {
  //initially show the login screen
  bool signedUp = true;

  //toggle between login and register page
  void togglePages() {
    setState(() {
      signedUp = !signedUp;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (signedUp) {
      return LoginPage(
        notRegistered: () {
          setState(() {
            signedUp = false;
          });
        },
      );
    } else {
      return const RegisterPage();
    }
  }
}
