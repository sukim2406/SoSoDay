import 'package:flutter/material.dart';
import 'package:soso_day/controllers/match_controller.dart';

import '../subpages/event_detail.dart';
import '../indiviual_widgets/circle_profile_picture.dart';
import '../globals.dart' as globals;

class EventTile extends StatelessWidget {
  final String matchDocId;
  final Map event;
  final String myUid;
  final Map matchDoc;

  const EventTile({
    Key? key,
    required this.event,
    required this.myUid,
    required this.matchDocId,
    required this.matchDoc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        event['userName'] = matchDoc['userMaps'][myUid]['name'];
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                EventDetail(matchDocId: matchDocId, event: event),
          ),
        );
      },
      child: ListTile(
        leading: CircleProfilePicture(
          backgroundImage: matchDoc['userMaps'][event['creator']]
              ['profilePicture'],
          radius: 20.0,
        ),
        title: Text(
          event['title'],
        ),
        enabled: event['completed'] ? false : true,
        trailing: event['completed']
            ? null
            : TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Set as completed?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            MatchController.instance
                                .setEventComplete(matchDocId, event);
                            Navigator.pop(context);
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text('Finished'),
                style: TextButton.styleFrom(primary: globals.secondaryColor),
              ),
      ),
    );
  }
}
