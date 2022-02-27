import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool isMyMessage;

  const MessageTile(
      {Key? key, required this.message, required this.isMyMessage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: isMyMessage ? 0 : 24, right: isMyMessage ? 24 : 0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isMyMessage
                  ? [
                      const Color.fromRGBO(255, 222, 158, 1),
                      const Color.fromRGBO(255, 222, 158, 1)
                    ]
                  : [
                      const Color.fromRGBO(85, 74, 53, 1),
                      const Color.fromRGBO(85, 74, 53, 1)
                    ],
            ),
            borderRadius: isMyMessage
                ? BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomLeft: Radius.circular(23))
                : BorderRadius.only(
                    topLeft: Radius.circular(23),
                    topRight: Radius.circular(23),
                    bottomRight: Radius.circular(23))),
        child: isMyMessage
            ? Text(
                message,
                style: TextStyle(
                    color: Color.fromRGBO(85, 74, 53, 1),
                    fontWeight: FontWeight.bold),
              )
            : Text(message,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                )),
      ),
    );
  }
}
