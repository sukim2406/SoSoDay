import 'package:flutter/material.dart';
import '../globals.dart' as globals;

class CircleProfilePicture extends StatelessWidget {
  final backgroundImage;
  var radius;
  CircleProfilePicture({Key? key, required this.backgroundImage, this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: globals.tertiaryColor,
      backgroundImage: (backgroundImage == '')
          ? const AssetImage('img/profile.png')
          : NetworkImage(backgroundImage) as ImageProvider,
      radius: (radius != null) ? radius : null,
    );
  }
}
