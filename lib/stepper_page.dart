import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soso_day/controllers/auth_controller.dart';
import 'package:soso_day/controllers/match_controller.dart';
import 'package:soso_day/controllers/user_controller.dart';

import './widgets/log_input.dart';
import './widgets/log_btn.dart';

class StepperPage extends StatefulWidget {
  final user;
  const StepperPage({Key? key, required this.user}) : super(key: key);

  @override
  _StepperPageState createState() => _StepperPageState();
}

class _StepperPageState extends State<StepperPage> {
  var _currentStep = 0;
  var usernameController = TextEditingController();
  var halfEmailController = TextEditingController();
  var halfUsernameController = TextEditingController();

  List<Step> _getSteps() => [
        Step(
          state: _currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 0,
          title: const Text(
            'Username',
            style: TextStyle(fontSize: 10),
          ),
          content: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('How Should We Call You?'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(
                    color: Color.fromRGBO(85, 74, 53, 1),
                  ),
                  controller: usernameController,
                  obscureText: false,
                  decoration: InputDecoration(
                      hintText: 'Screen Name',
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(85, 74, 53, 1))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(85, 74, 53, 1)))),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: _currentStep > 1 ? StepState.complete : StepState.indexed,
          isActive: _currentStep >= 1,
          title: const Text(
            'Your half\'s email',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          content: Container(
            // margin: const EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Whats your half\'s email?'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(
                    color: Color.fromRGBO(85, 74, 53, 1),
                  ),
                  controller: halfEmailController,
                  obscureText: false,
                  decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle:
                          TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                      enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color.fromRGBO(85, 74, 53, 1))),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromRGBO(85, 74, 53, 1)))),
                ),
                // const SizedBox(
                //   height: 30,
                // ),
              ],
            ),
          ),
        ),
        Step(
          isActive: _currentStep >= 2,
          title: const Text(
            'Complete',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          content: Container(
            // margin: const EdgeInsets.only(left: 20, right: 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                    text: TextSpan(
                        text: 'Your Screen name',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        children: [
                      const TextSpan(text: '\t\t\t\t\t'),
                      TextSpan(
                          text: usernameController.text,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal))
                    ])),
                const SizedBox(height: 30),
                RichText(
                    text: TextSpan(
                        text: 'Your half\'s Email',
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                        children: [
                      const TextSpan(text: '\t\t\t\t\t'),
                      TextSpan(
                          text: halfEmailController.text,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.normal))
                    ])),
                // const SizedBox(height: 30),
                // RichText(
                //     text: TextSpan(
                //         text: 'Your half\'s Screen name',
                //         style: const TextStyle(
                //           color: Colors.black,
                //           fontWeight: FontWeight.bold,
                //           fontSize: 15,
                //         ),
                //         children: [
                //       const TextSpan(text: '\t\t\t\t\t'),
                //       TextSpan(
                //           text: halfUsernameController.text,
                //           style: const TextStyle(
                //               fontSize: 20, fontWeight: FontWeight.normal))
                //     ]))
              ],
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('img/app-bar.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // title: const Text('Before we start...'),
          // centerTitle: true,
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: const ColorScheme.light(
            primary: Colors.black,
          )),
          child: Stepper(
            type: StepperType.horizontal,
            steps: _getSteps(),
            currentStep: _currentStep,
            onStepContinue: () {
              final isLastStep = _currentStep == _getSteps().length - 1;
              if (isLastStep) {
                if (usernameController.text.isEmpty ||
                    halfEmailController.text.isEmpty) {
                  print('Empty field detected');
                  Get.snackbar('Input', 'Empty Field',
                      backgroundColor: Colors.redAccent,
                      snackPosition: SnackPosition.BOTTOM,
                      titleText: const Text('Empty Field Detected',
                          style: TextStyle(color: Colors.white)),
                      messageText: const Text(
                        'You need to provide all informations',
                        style: TextStyle(color: Colors.white),
                      ));
                } else {
                  Map<String, String> userInfoMap = {
                    'name': usernameController.text,
                    'email': widget.user.email,
                    'halfEmail': halfEmailController.text,
                    // 'halfname': halfUsernameController.text,
                  };
                  UserController.instance.createUserDocument(userInfoMap);

                  widget.user.reload();
                }
                // send data to server
              } else {
                setState(() => _currentStep += 1);
              }
            },
            onStepCancel: () {
              if (_currentStep == 0) {
                print('0 step');
                null;
              } else {
                setState(() => _currentStep -= 1);
              }
            },
            onStepTapped: (step) => setState(() => _currentStep = step),
            controlsBuilder: (BuildContext context, ControlsDetails controls) {
              final isLastStep = _currentStep == _getSteps().length - 1;

              return Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  children: [
                    if (_currentStep != 0)
                      GestureDetector(
                        onTap: controls.onStepCancel,
                        child: Container(
                          // padding: EdgeInsets.all(5),
                          child: Container(
                              child: Image(
                                  image: AssetImage('img/backBtn.png'),
                                  fit: BoxFit.fill),
                              height: MediaQuery.of(context).size.height * .03,
                              width: MediaQuery.of(context).size.width * .4),
                        ),
                      ),
                    Expanded(
                      child: Container(),
                    ),
                    GestureDetector(
                      onTap: controls.onStepContinue,
                      child: Container(
                        child: Container(
                          child: Image(
                            image: isLastStep
                                ? AssetImage('img/confirmBtn.png')
                                : AssetImage('img/nextBtn.png'),
                            fit: BoxFit.fill,
                          ),
                          height: MediaQuery.of(context).size.height * .03,
                          width: _currentStep == 0
                              ? MediaQuery.of(context).size.width * .4
                              : MediaQuery.of(context).size.width * .4,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));
  }
}
