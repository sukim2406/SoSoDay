import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soso_day/controllers/match_controller.dart';
import 'package:table_calendar/table_calendar.dart';

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
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  void saveAsEvent(events) {
    events.forEach((event) {
      print('save as event');
      print(event['selectedDay'].toDate());
      if (selectedEvents[event['selectedDay'].toDate()] != null) {
        selectedEvents[event['selectedDay'].toDate()]
            ?.add(Event(event['title']));
      } else {
        selectedEvents[event['selectedDay'].toDate()] = [Event(event['title'])];
      }
    });
    print('selctedEvents');
    print(selectedEvents);
  }

  void saveAsSelectedEvents() async {
    await MatchController.instance.getEvents(widget.matchDocId).then((data) {
      data.forEach((event) {
        if (selectedEvents[event['selectedDay'].toDate()] != null) {
          selectedEvents[event['selectedDay'].toDate()]
              ?.add(Event(event['title']));
        } else {
          selectedEvents[event['selectedDay'].toDate()] = [
            Event(event['title'])
          ];
        }
      });
    });
    print('saveAsSelectedEvents()');
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
        // print('testing');
        // print(snapshot.data!.docs.first['events']);
        // saveAsSelectedEvents();
        // saveAsEvent(snapshot.data!.docs.first['events']);
        // setState(() {});

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
        ..._getEventsfromDay(_selectedDay)
            .map((Event event) => ListTile(title: Text(event.title))),
        // Column(
        //   children: [
        //     TableCalendar(
        //       firstDay: DateTime.utc(2020, 01, 01),
        //       lastDay: DateTime.utc(2030, 12, 31),
        //       focusedDay: DateTime.now(),
        //       selectedDayPredicate: (day) {
        //         return isSameDay(_selectedDay, day);
        //       },
        //       onDaySelected: (selectedDay, focusedDay) {
        //         setState(() {
        //           _selectedDay = selectedDay;
        //           _focusedDay = focusedDay;

        //         });
        //       },
        //       calendarFormat: _calendarFormat,
        //       onFormatChanged: (format) {
        //         setState(() {
        //           _calendarFormat = format;
        //         });
        //       },
        //       onPageChanged: (focusedDay) {
        //         _focusedDay = focusedDay;
        //       },
        //       eventLoader: _getEventsfromDay,
        //     ),
        //     ..._getEventsfromDay(_selectedDay).map(
        //       (Event event) => ListTile(
        //         title: Text(event.title),
        //       ),
        //     ),
        //   ],
        // ),
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
                            child: Text('OK'),
                            onPressed: () {
                              if (_eventController.text.isEmpty) {
                              } else {
                                print('Date check');
                                print(_selectedDay);
                                print(Timestamp.fromDate(_selectedDay));
                                Map<String, dynamic> event = {
                                  'selectedDay':
                                      Timestamp.fromDate(_selectedDay),
                                  'title': _eventController.text,
                                };
                                // if (selectedEvents[_selectedDay] != null) {
                                //   selectedEvents[_selectedDay]
                                //       ?.add(Event(_eventController.text));
                                // } else {
                                //   selectedEvents[_selectedDay] = [
                                //     Event(_eventController.text)
                                //   ];
                                // }
                                MatchController.instance
                                    .addEvent(widget.matchDocId, event);
                              }
                              Navigator.pop(context);
                              _eventController.clear();
                              // setState(() {});
                              return;
                            },
                          ),
                          TextButton(
                              child: Text('Cancel'),
                              onPressed: () => Navigator.pop(context)),
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
  final String title;

  Event(this.title);

  String toString() => title;
}
