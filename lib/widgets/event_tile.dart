// <a href="https://www.flaticon.com/free-icons/user" title="user icons">User icons created by Maxim Basinski Premium - Flaticon</a>

import 'package:flutter/material.dart';

import '../controllers/match_controller.dart';

class EventTile extends StatelessWidget {
  final event;
  final matchDocId;
  const EventTile({Key? key, required this.event, required this.matchDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.grey,
        child: SizedBox(
          width: 40,
          height: 40,
          child: ClipOval(child: Image.asset('img/user.png')),
        ),
      ),
      title: Text(event.title),
      enabled: event.completed ? false : true,
      trailing: event.completed
          ? null
          : TextButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text('Set as Completed?'),
                          actions: [
                            TextButton(
                              child: Text('Set'),
                              onPressed: () {
                                print('onClick');
                                print(event);
                                MatchController.instance
                                    .modifyEvent(matchDocId, event);
                                Navigator.pop(context);
                              },
                            ),
                            TextButton(
                              child: Text('Cancel'),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ));
              },
              child: Text('temp'),
            ),
    );
  }
}
