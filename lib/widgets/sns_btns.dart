import 'package:flutter/material.dart';

class SnsBtns extends StatelessWidget {
  const SnsBtns({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const snsImages = ['g.png', 'f.png', 't.png'];
    return Wrap(
      children: List<Widget>.generate(3, (index) {
        return Padding(
            padding: const EdgeInsets.all(10.0),
            child: CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[500],
                child: CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('img/' + snsImages[index]),
                )));
      }),
    );
  }
}
