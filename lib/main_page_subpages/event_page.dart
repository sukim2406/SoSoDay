import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import 'package:soso_day/controllers/match_controller.dart';
import '../widgets/event_tile.dart';

class EventPage extends StatefulWidget {
  final matchDocId;
  final user;
  const EventPage({Key? key, required this.matchDocId, required this.user})
      : super(key: key);

  @override
  _EventPageState createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Map<DateTime, List<Event>> selectedEvents;
  late DateTime _selectedDay = DateTime.now();
  var _focusedDay;
  var _calendarFormat = CalendarFormat.month;
  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    selectedEvents = {};
    saveAsSelectedEvents();
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  // void saveAsEvent(events) {
  //   events.forEach((event) {
  //     print('toUTC');
  //     print(event['selectedDay'].toDate().toUtc());
  //     if (selectedEvents[event['selectedDay'].toDate().toUtc()] != null) {
  //       selectedEvents[event['selectedDay'].toDate().toUtc()]
  //           ?.add(Event(event['title'], event['completed']));
  //     } else {
  //       selectedEvents[event['selectedDay'].toDate().toUtc()] = [
  //         Event(event['title'], event['completed'])
  //       ];
  //     }
  //   });
  //   print('selctedEvents');
  //   print(selectedEvents);
  //   // setState(() {});
  // }

  void saveAsSelectedEvents() async {
    var data = await MatchController.instance.getEvents(widget.matchDocId);
    print('saveAsSelectedEvents');
    print(data[0]['selectedDay'].toDate());
    data.forEach((event) {
      if (selectedEvents[event['selectedDay'].toDate().toUtc()] != null) {
        selectedEvents[event['selectedDay'].toDate().toUtc()]?.add(
            Event(event['title'], event['completed'], event['createdAt']));
      } else {
        selectedEvents[event['selectedDay'].toDate().toUtc()] = [
          Event(event['title'], event['completed'], event['createdAt'])
        ];
      }
    });

    print('ha');
    print(selectedEvents);
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }

  Stream<QuerySnapshot> getEventStream() async* {
    yield* FirebaseFirestore.instance
        .collection('matches')
        .where('couple', arrayContains: widget.user.uid)
        .snapshots();
  }

  Widget Calendar() {
    return StreamBuilder<QuerySnapshot>(
      stream: getEventStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('Snapshot Error');
        }
        if (!snapshot.hasData) {
          return Text('Snapshot Empty');
        }

        return TableCalendar(
          firstDay: DateTime.utc(2020, 01, 01),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
          calendarFormat: _calendarFormat,
          onFormatChanged: (format) {
            setState(() {
              _calendarFormat = format;
            });
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
          eventLoader: _getEventsfromDay,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        SizedBox(height: 200),
        Calendar(),
        ..._getEventsfromDay(_selectedDay).map((Event event) => EventTile(
              event: event,
              matchDocId: widget.matchDocId,
            )),
        FloatingActionButton.extended(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                        title: Text('Add Event'),
                        content: TextFormField(
                          controller: _eventController,
                        ),
                        actions: [
                          TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.pop(context)),
                          TextButton(
                              child: Text('Detailed View'),
                              onPressed: () {
                                Navigator.pop(context);
                              }),
                          TextButton(
                            child: Text('Quick Save'),
                            onPressed: () {
                              if (_eventController.text.isEmpty) {
                              } else {
                                Map<String, dynamic> event = {
                                  'selectedDay':
                                      Timestamp.fromDate(_selectedDay),
                                  'title': _eventController.text,
                                  'completed': false,
                                  'createdAt': Timestamp.now(),
                                };
                                if (selectedEvents[_selectedDay] != null) {
                                  selectedEvents[_selectedDay]?.add(Event(
                                      _eventController.text,
                                      false,
                                      event['createdAt']));
                                } else {
                                  selectedEvents[_selectedDay] = [
                                    Event(_eventController.text, false,
                                        event['createdAt'])
                                  ];
                                }
                                MatchController.instance
                                    .addEvent(widget.matchDocId, event);
                              }
                              Navigator.pop(context);
                              _eventController.clear();
                              // setState(() {});
                              return;
                            },
                          ),
                        ],
                      ));
            },
            label: Text('add event'),
            icon: Icon(Icons.add)),
      ],
    ));
  }
}

class Event {
  final String _title;
  bool _completed;
  final Timestamp _createdAt;

  Event(this._title, this._completed, this._createdAt);

  String get title => _title;
  bool get completed => _completed;
  Timestamp get createdAt => _createdAt;

  set completed(bool value) {
    _completed = value;
  }
}
