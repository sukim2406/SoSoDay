import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soso_day/controllers/auth_controller.dart';
import 'package:soso_day/controllers/user_controller.dart';

import './login_page.dart';
import 'widgets/log_input.dart';
import 'widgets/log_btn.dart';
import 'widgets/sns_btns.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var emailController = TextEditingController();
    var passwordController = TextEditingController();

    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              width: width,
              height: isKeyboardOpen ? 0 : height * .3,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('img/signup.png'), fit: BoxFit.cover),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: height * 0.15,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.white70,
                    radius: 60,
                    backgroundImage: AssetImage('img/profile1.png'),
                  )
                ],
              ),
            ),
            Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                width: width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    LogInput(
                      inputIcon: Icon(Icons.email, color: Colors.deepOrange),
                      inputText: 'Email',
                      controller: emailController,
                      obscure: false,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    LogInput(
                      inputIcon: Icon(Icons.password, color: Colors.deepOrange),
                      inputText: 'Password',
                      controller: passwordController,
                      obscure: true,
                    ),
                  ],
                )),
            const SizedBox(
              height: 70,
            ),
            GestureDetector(
                onTap: () {
                  AuthController.instance
                      .register(emailController.text, passwordController.text);
                },
                child: LogBtn(
                  btnText: 'Sign up',
                  btnHeight: height * .08,
                  btnWidth: width * .5,
                  btnFontSize: 36,
                )),
            const SizedBox(height: 20),
            RichText(
                text: TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () => Get.to(() => const LoginPage()),
              text: 'Have an account?',
              style: TextStyle(fontSize: 20, color: Colors.grey[500]),
            )),
            SizedBox(
              height: height * .05,
            ),
            RichText(
              text: TextSpan(
                  text: 'Sign up using following',
                  style: TextStyle(color: Colors.grey[500], fontSize: 20)),
            ),
            SnsBtns(),
          ],
        ));
  }
}
