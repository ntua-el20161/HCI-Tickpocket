import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tickpocket_app/components/textfield.dart';
import 'package:tickpocket_app/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //text controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPassController = TextEditingController();

  void signUp() async {
    if (passwordController.text != confirmPassController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Passwords do not match!')));
      return;
    }

    //get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailandPassword(
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
          title: const Text('Sign Up'),
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                    height: 20,
                  ),
                  MyTextField(
                      controller: confirmPassController,
                      obscureText: true,
                      hintText: 'Confirm Password'),
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 300,
                    child: ElevatedButton(
                        onPressed: () {
                          signUp();
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
