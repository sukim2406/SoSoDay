import 'package:flutter/material.dart';

import '../widgets/log_input.dart';
import '../widgets/log_btn.dart';
import '../controllers/auth_controller.dart';

class ResetPasswordPage extends StatefulWidget {
  final user;
  const ResetPasswordPage({Key? key, required this.user}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.all(30),
          child: Text('Reset Password',
              style: TextStyle(
                fontSize: 25,
              )),
        ),
        Container(
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('New Password'),
              LogInput(
                  inputIcon: Icon(Icons.password),
                  inputText: 'new password',
                  controller: newPasswordController,
                  obscure: true),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Confirm password'),
              LogInput(
                inputIcon: Icon(Icons.password),
                inputText: 'confirm new password',
                controller: confirmPasswordController,
                obscure: true,
              )
            ],
          ),
        ),
        Visibility(
          child: Container(
              margin: EdgeInsets.all(15),
              child: Text(
                'Password Not Matching',
                style: TextStyle(color: Colors.redAccent),
              )),
          visible:
              (newPasswordController.text != confirmPasswordController.text),
        ),
        Visibility(
          child: Container(
            margin: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Re authenticate with current password'),
                LogInput(
                    inputIcon: Icon(Icons.password),
                    inputText: 'current password',
                    controller: currentPasswordController,
                    obscure: true)
              ],
            ),
          ),
          visible: (newPasswordController.text.isNotEmpty &&
              (newPasswordController.text == confirmPasswordController.text)),
        ),
        Visibility(
            child: GestureDetector(
              onTap: () {
                AuthController.instance.updatePassword(widget.user.email,
                    currentPasswordController.text, newPasswordController.text);
              },
              child: Container(
                  margin: EdgeInsets.all(30),
                  alignment: Alignment.center,
                  child: LogBtn(
                    btnText: 'Reset',
                    btnWidth: MediaQuery.of(context).size.width * .7,
                    btnHeight: MediaQuery.of(context).size.height * .05,
                    btnFontSize: 20,
                  )),
            ),
            visible: (newPasswordController.text ==
                    confirmPasswordController.text) &&
                (currentPasswordController.text.isNotEmpty))
      ],
    ));
  }
}

// class ResetPasswordPage extends StatelessWidget {

//   var newPasswordController = new TextEditingController();
//   var confrimPasswordController = new TextEditingController();
//   ResetPasswordPage({Key? key}) : super(key: key);
  

//   @override
//   void initState(){
//     newPasswordController.addListener(() {
      
//     })
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Container(
//         child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           margin: EdgeInsets.all(30),
//           child: Text('Reset Password',
//               style: TextStyle(
//                 fontSize: 25,
//               )),
//         ),
//         Container(
//           margin: EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('New Password'),
//               LogInput(
//                   inputIcon: Icon(Icons.password),
//                   inputText: 'new password',
//                   controller: newPasswordController,
//                   obscure: true),
//             ],
//           ),
//         ),
//         Container(
//           margin: EdgeInsets.all(15),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text('Confirm password'),
//               LogInput(
//                 inputIcon: Icon(Icons.password),
//                 inputText: 'confirm new password',
//                 controller: confrimPasswordController,
//                 obscure: true,
//               )
//             ],
//           ),
//         ),
//         Visibility(
//           child: Container(
//               margin: EdgeInsets.all(15),
//               child: Text(
//                 'Password Not Matching',
//                 style: TextStyle(color: Colors.redAccent),
//               )),
//           visible:
//               (newPasswordController.text != confrimPasswordController.text),
//         )
//       ],
//     ));
//   }
// }
