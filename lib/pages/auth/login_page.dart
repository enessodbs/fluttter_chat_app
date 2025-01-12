// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/auth_service/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final Function()? register;

  const LoginPage({
    Key? key,
    required this.register,
  }) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Email and password controllers
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  void _login(BuildContext context) {
    //Auth service login function
    final AuthService _auth = AuthService();

    try {
      _auth.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(e.toString()),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //logo
            Icon(Icons.message,
                size: 60, color: Theme.of(context).colorScheme.primary),
            SizedBox(height: 50),
            //welcome message
            Text("Welcome to the Chat App",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 16)),
            SizedBox(height: 25),
            //email textfield
            MyTextfield(
              hintText: "Email",
              obbscureText: false,
              controller: _emailController,
            ),
            SizedBox(height: 10),
            //password textfield
            MyTextfield(
              hintText: "Password",
              obbscureText: true,
              controller: _passwordController,
            ),
            SizedBox(height: 25),
            //login button
            MyButton(
              buttonText: "Login",
              buttonFunction: () => _login(context),
            ),
            SizedBox(height: 25),

            //register button

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Not a member? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                GestureDetector(
                  onTap: widget.register,
                  child: Text(
                    "Register Now!",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
