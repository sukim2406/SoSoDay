import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../globals.dart' as globals;
import '../controllers/user_controller.dart';

class ConnectingStep extends StatefulWidget {
  final user;
  const ConnectingStep({
    Key? key,
    required this.user,
  }) : super(key: key);

  @override
  State<ConnectingStep> createState() => _ConnectingStepState();
}

class _ConnectingStepState extends State<ConnectingStep> {
  int currentStep = 0;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  List<Step> getSteps() => [
        Step(
          state: (currentStep > 0) ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text(
            'Name',
            style: TextStyle(
              fontSize: 10,
              color: globals.secondaryColor,
            ),
          ),
          content: SizedBox(
            width: globals.getwidth(context),
            height: globals.getHeight(context) * .65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Your screen name?'),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  style: TextStyle(
                    color: globals.secondaryColor,
                  ),
                  controller: nameController,
                  obscureText: false,
                  decoration: globals.textFieldDecoration('Name'),
                ),
              ],
            ),
          ),
        ),
        Step(
          state: (currentStep > 1) ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 1,
          title: const Text(
            'Half\'s email',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          content: SizedBox(
            height: globals.getHeight(context) * .65,
            width: globals.getwidth(context),
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
                    color: globals.secondaryColor,
                  ),
                  controller: emailController,
                  obscureText: false,
                  decoration: globals.textFieldDecoration('Email'),
                ),
              ],
            ),
          ),
        ),
        Step(
          isActive: currentStep >= 2,
          title: const Text(
            'Complete',
            style: TextStyle(
              fontSize: 10,
            ),
          ),
          content: SizedBox(
            width: globals.getwidth(context),
            height: globals.getHeight(context) * .65,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                    text: 'Screen name',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    children: [
                      const TextSpan(
                        text: '\t\t\t\t\t',
                      ),
                      TextSpan(
                        text: nameController.text,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                RichText(
                  text: TextSpan(
                    text: 'Half\'s email',
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    children: [
                      const TextSpan(
                        text: '\t\t\t\t\t',
                      ),
                      TextSpan(
                        text: emailController.text,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('img/app-bar.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.light(
            primary: globals.primaryColor,
          ),
        ),
        child: Stepper(
          type: StepperType.horizontal,
          steps: getSteps(),
          currentStep: currentStep,
          onStepContinue: () {
            final isLastStep = (currentStep == getSteps().length - 1);
            if (isLastStep) {
              if (nameController.text.isEmpty || emailController.text.isEmpty) {
                Get.snackbar(
                  'Input',
                  'Empty field',
                  backgroundColor: Colors.redAccent,
                  snackPosition: SnackPosition.BOTTOM,
                  titleText: const Text(
                    'Empty field detected',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  messageText: const Text(
                    'Need to provide all informations',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              } else {
                Map<String, String> userInfo = {
                  'name': nameController.text,
                  'email': widget.user.email,
                  'halfEmail': emailController.text,
                };
                UserController.instance.createUserDocument(userInfo);

                widget.user.reload();
              }
            } else {
              setState(() {
                currentStep += 1;
              });
            }
          },
          onStepCancel: () {
            if (currentStep != 0) {
              setState(
                () {
                  currentStep -= 1;
                },
              );
            }
          },
          onStepTapped: (step) => setState(() => currentStep = step),
          controlsBuilder: (BuildContext context, ControlsDetails controls) {
            final isLastStep = (currentStep == getSteps().length - 1);
            return Container(
              margin: const EdgeInsets.only(top: 20),
              child: Row(
                children: [
                  if (currentStep != 0)
                    GestureDetector(
                      onTap: controls.onStepCancel,
                      child: SizedBox(
                        height: globals.getHeight(context) * .03,
                        width: globals.getwidth(context) * .4,
                        child: const Image(
                          image: AssetImage('img/backBtn.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  Expanded(
                    child: Container(),
                  ),
                  GestureDetector(
                    onTap: controls.onStepContinue,
                    child: SizedBox(
                      height: globals.getHeight(context) * .03,
                      width: globals.getwidth(context) * .4,
                      child: Image(
                        image: (isLastStep)
                            ? const AssetImage('img/confirmBtn.png')
                            : const AssetImage('img/nextBtn.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
