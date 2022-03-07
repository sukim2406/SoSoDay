import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart' as globals;
import '../controllers/auth_controller.dart';
import '../indiviual_widgets/sns_btns.dart';
import './signup.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: globals.getHeight(context),
              width: globals.getwidth(context),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/title-temp2.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: globals.getHeight(context) * .3,
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: globals.getwidth(context) * .8,
                    child: TextField(
                      style: TextStyle(
                        color: globals.secondaryColor,
                      ),
                      controller: emailController,
                      obscureText: false,
                      decoration: globals.textFieldDecoration('Email'),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: globals.getwidth(context) * .8,
                    child: TextField(
                      style: TextStyle(
                        color: globals.secondaryColor,
                      ),
                      controller: passwordController,
                      obscureText: true,
                      decoration: globals.textFieldDecoration('Password'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthController.instance
                          .login(emailController.text, passwordController.text);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      child: SizedBox(
                        height: globals.getHeight(context) * .03,
                        width: globals.getwidth(context) * .7,
                        child: const Image(
                          image: AssetImage('img/log-in-test.png'),
                        ),
                      ),
                    ),
                  ),
                  const Text('OR USE FOLLOWING'),
                  const SnsBtns(),
                  RichText(
                    text: TextSpan(
                      text: 'Don\'t have an account?',
                      style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 20,
                      ),
                      children: [
                        TextSpan(
                          text: 'Create',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => Get.to(
                                  () => const SignUp(),
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
