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
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                            title: const Text('In development'),
                            content: const Text('In development! Coming soon'),
                            actions: [
                              TextButton(
                                child: const Text('Got it'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ]));
              },
              child: CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.amber.shade100,
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage('img/' + snsImages[index]),
                  )),
            ));
      }),
    );
  }
}
