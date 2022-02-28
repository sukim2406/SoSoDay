import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool isMyMessage;
  final matchDocData;
  final userId;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.isMyMessage,
      required this.matchDocData,
      required this.userId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var profilePicture;
    matchDocData['couple'].forEach((user) {
      if (user != userId) {
        profilePicture = user;
      }
    });
    print('testing');
    print(profilePicture);
    print(matchDocData['userMaps'][profilePicture]['profilePicture']);
    return Row(
      children: [
        !isMyMessage
            ? Container(
                padding: EdgeInsets.only(left: 12),
                child: CircleAvatar(
                    backgroundImage: NetworkImage(matchDocData['userMaps']
                        [profilePicture]['profilePicture'])
                    // backgroundImage: AssetImage('img/profile.png'),
                    ),
              )
            : Container(child: SizedBox.shrink()),
        Container(
          padding: EdgeInsets.only(
              left: isMyMessage ? 0 : 12, right: isMyMessage ? 24 : 0),
          margin: EdgeInsets.symmetric(vertical: 8),
          width: isMyMessage
              ? MediaQuery.of(context).size.width
              : MediaQuery.of(context).size.width * .8,
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
        ),
      ],
    );
  }
}
