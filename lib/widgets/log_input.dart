import 'dart:ffi';

import 'package:flutter/material.dart';

class LogInput extends StatelessWidget {
  final String inputText;
  final Icon inputIcon;
  final TextEditingController controller;
  final bool obscure;

  const LogInput(
      {Key? key,
      required this.inputIcon,
      required this.inputText,
      required this.controller,
      required this.obscure})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
              blurRadius: 10,
              spreadRadius: 7,
              offset: const Offset(1, 1),
              color: Colors.grey.withOpacity(.2))
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
            hintText: inputText,
            prefixIcon: inputIcon,
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(color: Colors.white, width: 1.0)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: const BorderSide(
                  color: Colors.white,
                  width: 1.0,
                )),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(30))),
      ),
    );
  }
}
