import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soso_day/controllers/auth_controller.dart';

import './signup_page.dart';
import 'widgets/log_input.dart';
import 'widgets/log_btn.dart';
import 'widgets/sns_btns.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: width,
              height: isKeyboardOpen ? height * 0 : height * .3,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('img/loginimg.png'),
                      fit: BoxFit.cover)),
            ),
            Container(
              margin: const EdgeInsets.only(left: 20, right: 20),
              width: width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  !isKeyboardOpen
                      ? const Text(
                          'Hello',
                          style: TextStyle(
                            fontSize: 70,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : const Text(''),
                  !isKeyboardOpen
                      ? Text('Sign into your account',
                          style:
                              TextStyle(fontSize: 20, color: Colors.grey[500]))
                      : const Text(''),
                  SizedBox(
                    height: 30,
                  ),
                  LogInput(
                    inputIcon: Icon(Icons.email, color: Colors.deepOrange),
                    inputText: 'Email',
                    controller: emailController,
                    obscure: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  LogInput(
                    inputIcon: Icon(Icons.password, color: Colors.deepOrange),
                    inputText: 'Password',
                    controller: passwordController,
                    obscure: true,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(),
                      ),
                      TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      title: Text('In development'),
                                      content:
                                          Text('In development! Coming soon'),
                                      actions: [
                                        TextButton(
                                          child: Text('Got it'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ]));
                        },
                        child: Text("Forgot your password?",
                            style: TextStyle(
                                fontSize: 20, color: Colors.grey[500])),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
                onTap: () {
                  AuthController.instance
                      .login(emailController.text, passwordController.text);
                },
                child: LogBtn(
                  btnText: 'Sign In',
                  btnHeight: height * .08,
                  btnWidth: width * .5,
                  btnFontSize: 36,
                )),
            RichText(
                text: TextSpan(
                    text: 'or',
                    style: TextStyle(color: Colors.grey[500], fontSize: 20))),
            RichText(
                text: TextSpan(
                    text: 'Sign in using following',
                    style: TextStyle(color: Colors.grey[500], fontSize: 20))),
            SnsBtns(),
            SizedBox(height: height * .01),
            RichText(
                text: TextSpan(
                    text: "Don\'t have an account?",
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
                          fontWeight: FontWeight.bold),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.to(() => const SignUpPage()))
                ]))
          ],
        ));
  }
}
