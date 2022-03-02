import 'package:flutter/material.dart';

class MessageTile extends StatelessWidget {
  final String message;
  final bool isMyMessage;
  final matchDocData;
  final userId;
  final time;

  const MessageTile(
      {Key? key,
      required this.message,
      required this.isMyMessage,
      required this.matchDocData,
      required this.userId,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var profilePicture;
    matchDocData['couple'].forEach((user) {
      if (user != userId) {
        profilePicture = user;
      }
    });
    return Container(
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: !isMyMessage
              ? [
                  Container(
                    padding: EdgeInsets.only(left: 12),
                    child: CircleAvatar(
                        backgroundImage: NetworkImage(matchDocData['userMaps']
                            [profilePicture]['profilePicture'])
                        // backgroundImage: AssetImage('img/profile.png'),
                        ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 12, right: 0),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width * .6,
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(85, 74, 53, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomRight: Radius.circular(23),
                        ),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 5),
                    width: MediaQuery.of(context).size.width * .2,
                    child: Text(
                      time.toDate().toString().substring(5, 16),
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                ]
              : [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    width: MediaQuery.of(context).size.width * .2,
                    child: Text(
                      time.toDate().toString().substring(5, 16),
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 0, right: 24),
                    margin: EdgeInsets.symmetric(vertical: 8),
                    width: MediaQuery.of(context).size.width * .8,
                    alignment: Alignment.centerRight,
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(255, 222, 158, 1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(23),
                          topRight: Radius.circular(23),
                          bottomLeft: Radius.circular(23),
                        ),
                      ),
                      child: Text(
                        message,
                        style: TextStyle(
                            color: Color.fromRGBO(85, 74, 53, 1),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ]
          // children: [
          //   !isMyMessage
          //       ? Container(
          //           padding: EdgeInsets.only(left: 12),
          //           child: CircleAvatar(
          //               backgroundImage: NetworkImage(matchDocData['userMaps']
          //                   [profilePicture]['profilePicture'])
          //               // backgroundImage: AssetImage('img/profile.png'),
          //               ),
          //         )
          //       : Container(child: SizedBox.shrink()),
          //   Container(
          //     padding: EdgeInsets.only(
          //         left: isMyMessage ? 0 : 12, right: isMyMessage ? 24 : 0),
          //     margin: EdgeInsets.symmetric(vertical: 8),
          //     width: isMyMessage
          //         ? MediaQuery.of(context).size.width
          //         : MediaQuery.of(context).size.width * .8,
          //     alignment:
          //         isMyMessage ? Alignment.centerRight : Alignment.centerLeft,
          //     child: Container(
          //       padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          //       decoration: BoxDecoration(
          //           gradient: LinearGradient(
          //             colors: isMyMessage
          //                 ? [
          //                     const Color.fromRGBO(255, 222, 158, 1),
          //                     const Color.fromRGBO(255, 222, 158, 1)
          //                   ]
          //                 : [
          //                     const Color.fromRGBO(85, 74, 53, 1),
          //                     const Color.fromRGBO(85, 74, 53, 1)
          //                   ],
          //           ),
          //           borderRadius: isMyMessage
          //               ? BorderRadius.only(
          //                   topLeft: Radius.circular(23),
          //                   topRight: Radius.circular(23),
          //                   bottomLeft: Radius.circular(23))
          //               : BorderRadius.only(
          //                   topLeft: Radius.circular(23),
          //                   topRight: Radius.circular(23),
          //                   bottomRight: Radius.circular(23))),
          //       child: isMyMessage
          //           ? Text(
          //               message,
          //               style: TextStyle(
          //                   color: Color.fromRGBO(85, 74, 53, 1),
          //                   fontWeight: FontWeight.bold),
          //             )
          //           : Text(message,
          //               style: TextStyle(
          //                 color: Colors.white,
          //                 fontWeight: FontWeight.bold,
          //               )),
          //     ),
          //   ),
          // ],
          ),
    );
  }
}
