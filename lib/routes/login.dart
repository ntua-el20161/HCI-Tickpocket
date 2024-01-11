import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickpocket_app/components/textfield.dart';
import 'package:tickpocket_app/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback notRegistered;

  const LoginPage({super.key, required this.notRegistered});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  Future<void> login() async {
    //get the auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailandPassword(
          emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 255, 131, 78),
          title: const Text('TICKPOCKET'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 100,
                  ),
                  MyTextField(
                      controller: emailController,
                      obscureText: false,
                      hintText: 'Email'),
                  const SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                      controller: passwordController,
                      obscureText: true,
                      hintText: 'Password'),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () {
                          login();
                        },
                        child: const Text('Login')),
                  ),
                  const Text('or'),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () {
                          widget.notRegistered();
                        },
                        child: const Text('Sign Up')),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
