import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:soso_day/controllers/auth_controller.dart';
// import '../stepper_page.dart';
import '../main_pages/connecting_step.dart';

class OnholdPage extends StatelessWidget {
  final String myUid;
  final user;
  const OnholdPage({
    Key? key,
    required this.myUid,
    required this.user,
  }) : super(key: key);

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
        leading: IconButton(
          icon: const Icon(Icons.skip_previous, color: Colors.black),
          onPressed: () {
            Get.to(
              () => ConnectingStep(user: myUid),
            );
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Colors.black,
            ),
            onPressed: () {
              AuthController.instance.logout();
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.refresh,
              color: Colors.black,
            ),
            onPressed: () {
              user.reload();
            },
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Waiting for him / her...',
                style: TextStyle(
                  fontSize: 25,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
