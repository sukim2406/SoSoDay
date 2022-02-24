/*
  background color #ffde9e, rgb(255,222,158)
  text color #ffdd9f, rgb(255,221,159)
*/

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soso_day/controllers/auth_controller.dart';

import './signup_page.dart';
import 'widgets/log_input.dart';
import 'widgets/log_btn.dart';
import 'widgets/sns_btns.dart';
import 'widgets/glassmorphism.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: width,
              height: height,
              decoration: BoxDecoration(
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
                    height: height * .3,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: width * .8,
                    child: TextField(
                      style: TextStyle(
                        color: Color.fromRGBO(85, 74, 53, 1),
                      ),
                      controller: emailController,
                      obscureText: false,
                      decoration: InputDecoration(
                          hintText: 'Email',
                          hintStyle:
                              TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(85, 74, 53, 1)))),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: width * .8,
                    child: TextField(
                      style: TextStyle(
                        color: Color.fromRGBO(85, 74, 53, 1),
                      ),
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle:
                              TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                          enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white)),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromRGBO(85, 74, 53, 1)))),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AuthController.instance
                          .login(emailController.text, passwordController.text);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: height * .03,
                        width: width * .7,
                        child: Image(
                          image: AssetImage('img/log-in-test.png'),
                        ),
                      ),
                    ),
                  ),
                  Container(child: Text('OR USE FOLLOWING')),
                  SnsBtns(),
                  Container(
                    child: RichText(
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
                                ..onTap =
                                    () => Get.to(() => const SignUpPage()))
                        ])),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
