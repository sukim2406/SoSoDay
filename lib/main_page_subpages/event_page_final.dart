import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soso_day/controllers/match_controller.dart';

import '../globals.dart' as globals;
import '../indiviual_widgets/calendar.dart';
import '../indiviual_widgets/event_tile.dart';
import '../subpages/event_detail.dart';

class EventPageFinal extends StatefulWidget {
  final String myUid;
  final String matchDocId;
  final Map matchDoc;

  const EventPageFinal({
    Key? key,
    required this.myUid,
    required this.matchDoc,
    required this.matchDocId,
  }) : super(key: key);

  @override
  State<EventPageFinal> createState() => _EventPageFinalState();
}

class _EventPageFinalState extends State<EventPageFinal> {
  late Map<DateTime, List<Map>> selectEvents;
  late DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay;
  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    selectEvents = {};
    setSelectEvents();

    super.initState();
  }

  void setSelectEvents() {
    widget.matchDoc['events'].forEach((event) {
      if (selectEvents[event['selectedDay'].toDate().toUtc()] == null) {
        selectEvents[event['selectedDay'].toDate().toUtc()] = [event];
      } else {
        bool duplicateCheck = false;
        selectEvents[event['selectedDay'].toDate().toUtc()]!.forEach((data) {
          if (data['due'] == event['due']) {
            duplicateCheck = true;
          }
        });
        if (!duplicateCheck) {
          selectEvents[event['selectedDay'].toDate().toUtc()]!.add(event);
        }
      }
    });
  }

  List<Map> getEventsFromDay(DateTime date) {
    return selectEvents[date] ?? [];
  }

  void setDates(selectedDate, focusedDate) {
    setState(() {
      _selectedDay = selectedDate;
      _focusedDay = focusedDate;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 100,
          ),
          Calendar(
            selectEvents: selectEvents,
            setDates: setDates,
            getEvents: getEventsFromDay,
          ),
          const SizedBox(height: 30),
          Container(
            color: globals.tertiaryColor,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          text: 'events on ',
                          style: TextStyle(color: globals.secondaryColor),
                          children: [
                            TextSpan(
                              text: _selectedDay.toString().substring(0, 10),
                              style: TextStyle(
                                color: globals.secondaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ConstrainedBox(
                  constraints:
                      const BoxConstraints(minHeight: 0, maxHeight: 200),
                  child: ListView.builder(
                    reverse: true,
                    itemCount: getEventsFromDay(_selectedDay).length,
                    itemBuilder: (context, index) {
                      return EventTile(
                          event: getEventsFromDay(_selectedDay)[index],
                          myUid: widget.myUid,
                          matchDocId: widget.matchDocId,
                          matchDoc: widget.matchDoc);
                    },
                  ),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 30),
            child: FloatingActionButton.extended(
              backgroundColor: globals.secondaryColor,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: globals.tertiaryColor,
                    title: Text(
                      'Add Event',
                      style: TextStyle(color: globals.secondaryColor),
                    ),
                    content: TextFormField(
                      controller: _eventController,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: globals.secondaryColor),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Map<String, dynamic> event = {
                            'selectedDay': Timestamp.fromDate(_selectedDay),
                            'title': '',
                            'completed': false,
                            'due': Timestamp.now(),
                            'creator': widget.myUid,
                            'description': '',
                            'name': widget.matchDoc['userMaps'][widget.myUid]
                                ['name'],
                          };
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EventDetail(
                                  matchDocId: widget.matchDocId, event: event),
                            ),
                          ).then((value) {
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          'Detailed View',
                          style: TextStyle(
                            color: globals.secondaryColor,
                          ),
                        ),
                      ),
                      TextButton(
                          onPressed: () {
                            if (_eventController.text.isNotEmpty) {
                              Map<String, dynamic> event = {
                                'selectedDay': Timestamp.fromDate(_selectedDay),
                                'title': _eventController.text,
                                'completed': false,
                                'due': Timestamp.now(),
                                'description': '',
                                'creator': widget.myUid,
                                'name': widget.matchDoc['userMaps']
                                    [widget.myUid]['name'],
                              };
                              MatchController.instance
                                  .addEvent(widget.matchDocId, event);
                            }
                            _eventController.clear();
                            Navigator.pop(context);
                            return;
                          },
                          child: Text(
                            'Quick Save',
                            style: TextStyle(
                              color: globals.secondaryColor,
                            ),
                          )),
                    ],
                  ),
                );
              },
              label: const Text('add event'),
              icon: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
