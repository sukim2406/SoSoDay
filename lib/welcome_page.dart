import 'package:flutter/material.dart';
import 'package:soso_day/controllers/auth_controller.dart';

import './widgets/log_btn.dart';

class WelcomePage extends StatelessWidget {
  final user;
  const WelcomePage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Container(
          width: width,
          height: height * .35,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('img/signup.png'), fit: BoxFit.cover)),
          child: Column(
            children: [
              SizedBox(
                height: height * .15,
              ),
              CircleAvatar(
                backgroundColor: Colors.white70,
                radius: 60,
                backgroundImage: AssetImage('img/profile.png'),
              )
            ],
          ),
        ),
        SizedBox(
          height: 70,
        ),
        Container(
            width: width,
            margin: const EdgeInsets.only(left: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    )),
                Text(
                  user.email,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[500],
                  ),
                )
              ],
            )),
        SizedBox(height: 200),
        GestureDetector(
            onTap: () {
              AuthController.instance.logout();
            },
            child: LogBtn(
              btnText: 'SignOut',
              btnHeight: height * .08,
              btnWidth: width * .5,
              btnFontSize: 36,
            ))
      ],
    );
  }
}
