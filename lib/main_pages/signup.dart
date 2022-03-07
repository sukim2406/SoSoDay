import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart' as globals;
import '../controllers/auth_controller.dart';
import '../indiviual_widgets/sns_btns.dart';
import './login.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmController = TextEditingController();
  late String email;
  late String password;
  late String confirm;

  @override
  void initState() {
    email = '';
    password = '';
    confirm = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              width: globals.getwidth(context),
              height: globals.getHeight(context),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('img/title-temp2.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Center(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: globals.getHeight(context) * .3,
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: globals.getwidth(context) * .8,
                      child: TextFormField(
                        controller: emailController,
                        style: TextStyle(
                          color: globals.secondaryColor,
                        ),
                        cursorColor: globals.secondaryColor,
                        decoration: globals.textFieldDecoration('Email'),
                        onSaved: (String? val) {
                          setState(() {
                            email = val.toString();
                          });
                        },
                        validator: (String? val) {
                          return (val == '' || val!.isEmpty)
                              ? 'Email cannot be empty'
                              : null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: globals.getwidth(context) * .8,
                      child: TextFormField(
                        controller: passwordController,
                        style: TextStyle(
                          color: globals.secondaryColor,
                        ),
                        obscureText: true,
                        cursorColor: globals.secondaryColor,
                        decoration: globals.textFieldDecoration('Password'),
                        onSaved: (String? val) {
                          setState(
                            () {
                              password = val.toString();
                            },
                          );
                        },
                        validator: (String? val) {
                          return (val != passwordController.text)
                              ? 'Password does not match'
                              : null;
                        },
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: globals.getwidth(context) * .8,
                      child: TextFormField(
                        controller: confirmController,
                        style: TextStyle(
                          color: globals.secondaryColor,
                        ),
                        obscureText: true,
                        cursorColor: globals.secondaryColor,
                        decoration:
                            globals.textFieldDecoration('Password confirm'),
                        onSaved: (String? val) {
                          setState(() {
                            confirm = val.toString();
                          });
                        },
                        validator: (String? val) {
                          return (confirmController.text != val)
                              ? 'Password does not match'
                              : null;
                        },
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          AuthController.instance.register(
                              emailController.text, passwordController.text);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: globals.getHeight(context) * .03,
                          width: globals.getwidth(context) * .7,
                          child: const Image(
                            image: AssetImage('img/sign-up-btn.png'),
                          ),
                        ),
                      ),
                    ),
                    const Text('Or use following'),
                    const SnsBtns(),
                    RichText(
                      text: TextSpan(
                        text: 'Already have an account?',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 20,
                        ),
                        children: [
                          TextSpan(
                            text: 'Log in',
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => Get.to(
                                    () => const LogIn(),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
