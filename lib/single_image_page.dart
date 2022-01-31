import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './main_page.dart';

class SingleImagePage extends StatelessWidget {
  final image;
  final matchDocId;
  final user;
  const SingleImagePage(
      {Key? key,
      required this.image,
      required this.matchDocId,
      required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
              onPressed: () {},
              child: const Text('Set as Profile'),
              style: TextButton.styleFrom(
                  primary: Theme.of(context).colorScheme.onPrimary))
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height * .7,
        width: MediaQuery.of(context).size.width,
        child: image,
      ),
    );
  }
}
