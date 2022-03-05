import 'package:flutter/material.dart';

import '../globals.dart' as globals;
import './circle_profile_picture.dart';

class Message extends StatelessWidget {
  final Map matchDoc;
  final Map messageData;
  final String myUid;

  const Message({
    Key? key,
    required this.messageData,
    required this.myUid,
    required this.matchDoc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: !(messageData['sender'] == myUid)
          ? (messageData['sender'] == 'System')
              ? [
                  Container(
                    width: globals.getwidth(context),
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      messageData['message'],
                      style: TextStyle(color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ]
              : [
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    child: CircleProfilePicture(
                      backgroundImage: matchDoc['userMaps'][myUid]
                          ['profilePicture'],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 12),
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    width: globals.getwidth(context) * .6,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: globals.secondaryColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomRight: Radius.circular(23),
                        ),
                      ),
                      child: Text(
                        messageData['message'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5),
                    width: globals.getwidth(context) * .2,
                    child: Text(
                      messageData['time'].toDate().toString().substring(5, 16),
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                ]
          : [
              Container(
                padding: const EdgeInsets.only(left: 15),
                width: globals.getwidth(context) * .2,
                child: Text(
                  messageData['time'].toDate().toString().substring(5, 16),
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 0, right: 24),
                margin: const EdgeInsets.symmetric(vertical: 8),
                width: globals.getwidth(context) * .8,
                alignment: Alignment.centerRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  decoration: BoxDecoration(
                    color: globals.primaryColor,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(23),
                      topRight: Radius.circular(23),
                      bottomLeft: Radius.circular(23),
                    ),
                  ),
                  child: Text(
                    messageData['message'],
                    style: TextStyle(
                      color: globals.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
    );
  }
}
