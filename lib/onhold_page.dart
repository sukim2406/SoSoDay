import 'package:flutter/material.dart';

class OnholdPage extends StatelessWidget {
  final user;
  const OnholdPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: <Widget>[
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
                style: TextStyle(fontSize: 25),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
