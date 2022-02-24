import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soso_day/controllers/auth_controller.dart';
import 'package:soso_day/controllers/user_controller.dart';

import './login_page.dart';
import 'widgets/log_input.dart';
import 'widgets/log_btn.dart';
import 'widgets/sns_btns.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var _email;
  var _password;
  var _passwordConfirm;
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _passwordConfirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _email = '';
    _password = '';
    _passwordConfirm = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: SingleChildScrollView(
          child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('img/title-temp2.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(height: MediaQuery.of(context).size.height * .3),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * .8,
                    child: TextFormField(
                      controller: _emailController,
                      style: const TextStyle(
                        color: Color.fromRGBO(85, 74, 53, 1),
                      ),
                      cursorColor: Color.fromRGBO(85, 74, 53, 1),
                      decoration: const InputDecoration(
                        labelText: 'EMAIL',
                        labelStyle:
                            TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(85, 74, 53, 1)),
                        ),
                      ),
                      onSaved: (String? val) {
                        setState(
                          () {
                            _email = val;
                          },
                        );
                      },
                      validator: (String? val) {
                        return (val == '' || val!.isEmpty)
                            ? 'Email cannot be empty'
                            : null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * .8,
                    child: TextFormField(
                      controller: _passwordController,
                      style: const TextStyle(
                        color: Color.fromRGBO(85, 74, 53, 1),
                      ),
                      obscureText: true,
                      cursorColor: Color.fromRGBO(85, 74, 53, 1),
                      decoration: const InputDecoration(
                        labelText: 'PASSWORD',
                        labelStyle:
                            TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(85, 74, 53, 1)),
                        ),
                      ),
                      onSaved: (String? val) {
                        setState(
                          () {
                            _password = val;
                          },
                        );
                      },
                      validator: (String? val) {
                        return (val != _passwordConfirmController.text)
                            ? 'Password does not match'
                            : null;
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * .8,
                    child: TextFormField(
                      controller: _passwordConfirmController,
                      style: const TextStyle(
                        color: Color.fromRGBO(85, 74, 53, 1),
                      ),
                      obscureText: true,
                      cursorColor: Color.fromRGBO(85, 74, 53, 1),
                      decoration: const InputDecoration(
                        labelText: 'PASSWORD CONFIRM',
                        labelStyle:
                            TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(85, 74, 53, 1)),
                        ),
                      ),
                      onSaved: (String? val) {
                        setState(
                          () {
                            _passwordConfirm = val;
                          },
                        );
                      },
                      validator: (String? val) {
                        return (_passwordController.text != val)
                            ? 'Password does not match'
                            : null;
                      },
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_formKey.currentState!.validate()) {
                        AuthController.instance.register(
                            _emailController.text, _passwordController.text);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .03,
                        width: MediaQuery.of(context).size.width * .7,
                        child: Image(
                          image: AssetImage('img/sign-up-btn.png'),
                        ),
                      ),
                    ),
                  ),
                  Container(child: Text('OR USE FOLLOWING')),
                  SnsBtns(),
                  Container(
                    child: RichText(
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
                                  fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Get.to(() => const LoginPage()))
                        ])),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    ));
  }
}

// class SignUpPage extends StatelessWidget {
//   const SignUpPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom != 0;
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;
//     var emailController = TextEditingController();
//     var passwordController = TextEditingController();

    // return Scaffold(
    //     body: Container(
    //   child: SingleChildScrollView(
    //       child: Stack(
    //     children: [
    //       Container(
    //         width: MediaQuery.of(context).size.width,
    //         height: MediaQuery.of(context).size.height,
    //         decoration: BoxDecoration(
    //           image: DecorationImage(
    //             image: AssetImage('img/title-temp2.png'),
    //             fit: BoxFit.fill,
    //           ),
    //         ),
    //       ),
    //       Center(
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             Container(
    //               padding: EdgeInsets.all(10),
    //               width: MediaQuery.of(context).size.width * .8,
    //               child: TextFormField(
    //                 decoration: InputDecoration(
    //                   labelText: 'Email',
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   )),
    // ));
    // return Scaffold(
    //     backgroundColor: Colors.white,
    //     body: Column(
    //       children: [
    //         Container(
    //           width: width,
    //           height: isKeyboardOpen ? 0 : height * .3,
    //           decoration: BoxDecoration(
    //             image: DecorationImage(
    //                 image: AssetImage('img/signup.png'), fit: BoxFit.cover),
    //           ),
    //           child: Column(
    //             children: [
    //               SizedBox(
    //                 height: height * 0.15,
    //               ),
    //               CircleAvatar(
    //                 backgroundColor: Colors.white70,
    //                 radius: 60,
    //                 backgroundImage: AssetImage('img/profile1.png'),
    //               )
    //             ],
    //           ),
    //         ),
    //         Container(
    //             margin: const EdgeInsets.only(left: 20, right: 20),
    //             width: width,
    //             child: Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               children: [
    //                 SizedBox(
    //                   height: 50,
    //                 ),
    //                 LogInput(
    //                   inputIcon: Icon(Icons.email, color: Colors.deepOrange),
    //                   inputText: 'Email',
    //                   controller: emailController,
    //                   obscure: false,
    //                 ),
    //                 SizedBox(
    //                   height: 10,
    //                 ),
    //                 LogInput(
    //                   inputIcon: Icon(Icons.password, color: Colors.deepOrange),
    //                   inputText: 'Password',
    //                   controller: passwordController,
    //                   obscure: true,
    //                 ),
    //               ],
    //             )),
    //         const SizedBox(
    //           height: 70,
    //         ),
    //         GestureDetector(
    //             onTap: () {
    //               AuthController.instance
    //                   .register(emailController.text, passwordController.text);
    //             },
    //             child: LogBtn(
    //               btnText: 'Sign up',
    //               btnHeight: height * .08,
    //               btnWidth: width * .5,
    //               btnFontSize: 36,
    //             )),
    //         const SizedBox(height: 20),
    //         RichText(
    //             text: TextSpan(
    //           recognizer: TapGestureRecognizer()
    //             ..onTap = () => Get.to(() => const LoginPage()),
    //           text: 'Have an account?',
    //           style: TextStyle(fontSize: 20, color: Colors.grey[500]),
    //         )),
    //         SizedBox(
    //           height: height * .05,
    //         ),
    //         RichText(
    //           text: TextSpan(
    //               text: 'Sign up using following',
    //               style: TextStyle(color: Colors.grey[500], fontSize: 20)),
    //         ),
    //         SnsBtns(),
    //       ],
    //     ));
//   }
// }
