import 'package:flutter/material.dart';
import 'package:get/get.dart';

// colors
var primaryColor = const Color.fromRGBO(255, 222, 158, 1);
var secondaryColor = const Color.fromRGBO(85, 74, 53, 1);
var tertiaryColor = const Color.fromRGBO(242, 236, 217, 1);

// welcome page user names
var welcomeUserNameStyle =
    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold);

textFieldDecoration(text) {
  return InputDecoration(
    labelText: text,
    labelStyle: TextStyle(color: secondaryColor),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: secondaryColor,
      ),
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: secondaryColor,
      ),
    ),
  );
}

getHeight(context) {
  return MediaQuery.of(context).size.height;
}

getwidth(context) {
  return MediaQuery.of(context).size.width;
}

printErrorSnackBar(title, e) {
  Get.snackbar(
    title,
    'error',
    backgroundColor: Colors.redAccent,
    snackPosition: SnackPosition.BOTTOM,
    titleText: Text(
      e.toString(),
      style: const TextStyle(color: Colors.white),
    ),
    messageText: Text(
      e.toString(),
      style: const TextStyle(color: Colors.white),
    ),
  );
}
