import 'package:chat_app/services/auth_service/auth_service.dart';
import 'package:chat_app/components/my_button.dart';
import 'package:chat_app/components/my_textfield.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  final Function()? login;

  const RegisterPage({super.key, required this.login});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Email and password controllers
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  void _register(BuildContext context) {
    //auth service register function
    final AuthService auth = AuthService();

    //passwrod match check -> create user
    if (_passwordController.text == _confirmPasswordController.text) {
      try {
        auth.registerWithEmailAndPassword(
            _emailController.text, _passwordController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Passwords do not match"),
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
            Text("Let's Create an Account for You",
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
            SizedBox(height: 10),
            //confirm password textfield
            MyTextfield(
              hintText: "Confirm Password",
              obbscureText: true,
              controller: _confirmPasswordController,
            ),
            SizedBox(height: 25),
            //login button
            MyButton(
              buttonText: "Register",
              buttonFunction: () => _register(context),
            ),
            SizedBox(height: 25),

            //register button

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an accounts? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    )),
                GestureDetector(
                  onTap: widget.login,
                  child: Text(
                    "Login Now!",
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
