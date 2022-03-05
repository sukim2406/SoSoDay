import 'package:flutter/material.dart';

import '../globals.dart' as globals;

class ShowDialog extends StatelessWidget {
  final String title;
  final Future function;
  final IconData icon;

  const ShowDialog({
    Key? key,
    required this.title,
    required this.function,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(title),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  await function;
                  Navigator.pop(context);
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
      child: Icon(icon, color: globals.secondaryColor),
    );
  }
}
