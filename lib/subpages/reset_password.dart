import 'package:flutter/material.dart';

import '../globals.dart' as globals;
import '../controllers/auth_controller.dart';

class ResetPassword extends StatefulWidget {
  final Map matchDoc;
  final String myUid;

  const ResetPassword({
    Key? key,
    required this.matchDoc,
    required this.myUid,
  }) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  late TextEditingController currentPasswordController;

  @override
  void initState() {
    newPasswordController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    confirmPasswordController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    currentPasswordController = TextEditingController()
      ..addListener(() {
        setState(() {});
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          child: Text(
            'Reset Password',
            style: TextStyle(
              fontSize: 25,
              color: globals.secondaryColor,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'New Password',
                style: TextStyle(
                  color: globals.secondaryColor,
                ),
              ),
              TextField(
                style: TextStyle(
                  color: globals.secondaryColor,
                ),
                controller: newPasswordController,
                obscureText: true,
                decoration: globals.textFieldDecoration(''),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Confirm password',
                style: TextStyle(
                  color: globals.secondaryColor,
                ),
              ),
              TextField(
                style: TextStyle(
                  color: globals.secondaryColor,
                ),
                controller: confirmPasswordController,
                obscureText: true,
                decoration: globals.textFieldDecoration(''),
              ),
            ],
          ),
        ),
        Visibility(
          child: Container(
            margin: const EdgeInsets.all(15),
            child: const Text(
              'Password not matching',
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
          visible:
              (newPasswordController.text != confirmPasswordController.text),
        ),
        Visibility(
          child: Container(
            margin: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Reauthenticate with current password',
                  style: TextStyle(
                    color: globals.secondaryColor,
                  ),
                ),
                TextField(
                  style: TextStyle(
                    color: globals.secondaryColor,
                  ),
                  controller: currentPasswordController,
                  obscureText: true,
                  decoration: globals.textFieldDecoration(''),
                ),
              ],
            ),
          ),
          visible: (newPasswordController.text.isNotEmpty &&
              (newPasswordController.text == confirmPasswordController.text)),
        ),
        Visibility(
          child: GestureDetector(
            onTap: () {
              AuthController.instance.updatePassword(
                  widget.matchDoc['userMaps'][widget.myUid]['email'],
                  currentPasswordController.text,
                  newPasswordController.text);
            },
            child: Container(
              margin: const EdgeInsets.all(30),
              alignment: Alignment.center,
              child: SizedBox(
                height: globals.getHeight(context) * .04,
                width: globals.getwidth(context) * .4,
                child: const Image(
                  image: AssetImage('img/reset-btn.png'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
