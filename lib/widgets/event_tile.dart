// <a href="https://www.flaticon.com/free-icons/user" title="user icons">User icons created by Maxim Basinski Premium - Flaticon</a>
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/match_controller.dart';
import '../event_form_page.dart';

class EventTile extends StatelessWidget {
  final event;
  final matchDocId;
  final imageUrl;
  final userName;
  const EventTile({
    Key? key,
    required this.event,
    required this.matchDocId,
    required this.imageUrl,
    required this.userName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: imageUrl,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Connection State None');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Row(
              children: [
                Expanded(child: Container()),
                CircularProgressIndicator(),
                Expanded(child: Container()),
              ],
            );
          case ConnectionState.done:
            if (snapshot.hasError) return Text('snapshot error');
            print('pleaseeee');
            print(snapshot.data);
            return GestureDetector(
              onTap: () {
                event['userName'] = userName;
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventForm(
                              matchDocId: matchDocId,
                              event: event,
                            ))).then((value) {
                  // Navigator.pop(context);
                });
              },
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipOval(
                      child: snapshot.data == ''
                          ? Image.asset('img/user.png')
                          : Image.network(snapshot.data),
                    ),
                  ),
                ),
                title: Text(event['title']),
                enabled: event['completed'] ? false : true,
                trailing: event['completed']
                    ? null
                    : TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Text('Set as Completed?'),
                                    actions: [
                                      TextButton(
                                        child: Text('Cancel'),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Text('Ok'),
                                        onPressed: () {
                                          MatchController.instance
                                              .setEventComplete(
                                                  matchDocId, event);
                                          event.completed = true;
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ));
                        },
                        child: Text('Finished'),
                        style: TextButton.styleFrom(
                            primary: Color.fromRGBO(85, 74, 53, 1)),
                      ),
              ),
            );
        }
      },
    );
    // return ListTile(
    //   leading: CircleAvatar(
    //     backgroundColor: Colors.grey,
    //     child: SizedBox(
    //       width: 40,
    //       height: 40,
    //       child: ClipOval(
    //         child: Image.asset('img/user.png'),
    //       ),
    //     ),
    //   ),
    //   title: Text(event['title']),
    //   enabled: event['completed'] ? false : true,
    //   trailing: event['completed']
    //       ? null
    //       : TextButton(
    //           onPressed: () {
    //             showDialog(
    //                 context: context,
    //                 builder: (context) => AlertDialog(
    //                       title: Text('Set as Completed?'),
    //                       actions: [
    //                         TextButton(
    //                           child: Text('Cancel'),
    //                           onPressed: () {
    //                             Navigator.pop(context);
    //                           },
    //                         ),
    //                         TextButton(
    //                           child: Text('Ok'),
    //                           onPressed: () {
    //                             MatchController.instance
    //                                 .setEventComplete(matchDocId, event);
    //                             event.completed = true;
    //                             Navigator.pop(context);
    //                           },
    //                         ),
    //                       ],
    //                     ));
    //           },
    //           child: Text('Finished'),
    //         ),
    // );
  }
}
