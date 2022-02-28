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
  const EventTile(
      {Key? key,
      required this.event,
      required this.matchDocId,
      required this.imageUrl})
      : super(key: key);

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
            return CircularProgressIndicator();
          case ConnectionState.done:
            if (snapshot.hasError) return Text('snapshot error');
            print('pleaseeee');
            print(snapshot.data);
            return ListTile(
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
