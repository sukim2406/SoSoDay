import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';

import 'package:soso_day/controllers/match_controller.dart';
import '../controllers/user_controller.dart';
import '../widgets/event_tile.dart';
import '../event_form_page.dart';

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
  late String userName;
  late DateTime _selectedDay = DateTime.now();
  var _focusedDay;
  var _calendarFormat = CalendarFormat.month;
  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    selectedEvents = {};
    userName = '';
    saveUserName();
    saveAsSelectedEvents();
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  void saveUserName() async {
    var data = await UserController.instance.getUsername(widget.user.uid);
    userName = data;
  }

  void saveAsSelectedEvents() async {
    selectedEvents = {};
    var data = await MatchController.instance.getEvents(widget.matchDocId);
    if (!data.isEmpty) {
      data.forEach((event) {
        if (selectedEvents[event['selectedDay'].toDate().toUtc()] != null) {
          selectedEvents[event['selectedDay'].toDate().toUtc()]?.add(Event(
              event['title'],
              event['completed'],
              event['due'],
              event['creator'],
              event['description']));
        } else {
          selectedEvents[event['selectedDay'].toDate().toUtc()] = [
            Event(event['title'], event['completed'], event['due'],
                event['creator'], event['description'])
          ];
        }
      });
    }
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
        ..._getEventsfromDay(_selectedDay).map((Event event) => GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EventForm(
                              matchDocId: widget.matchDocId,
                              event: event,
                            ))).then((value) {
                  setState(() {
                    saveAsSelectedEvents();
                  });
                });
              },
              child: EventTile(
                event: event,
                matchDocId: widget.matchDocId,
              ),
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
                                Get.to(() => EventForm(
                                      matchDocId: widget.matchDocId,
                                    ));
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
                                  'due': Timestamp.now(),
                                  'creator': userName,
                                  'description': '',
                                };
                                if (selectedEvents[_selectedDay] != null) {
                                  selectedEvents[_selectedDay]?.add(Event(
                                      _eventController.text,
                                      false,
                                      event['due'],
                                      userName,
                                      event['description']));
                                } else {
                                  selectedEvents[_selectedDay] = [
                                    Event(
                                        _eventController.text,
                                        false,
                                        event['due'],
                                        userName,
                                        event['description'])
                                  ];
                                }
                                MatchController.instance
                                    .addEvent(widget.matchDocId, event)
                                    .then((result) {
                                  setState(() {
                                    saveAsSelectedEvents();
                                  });
                                });
                              }
                              Navigator.pop(context);
                              _eventController.clear();
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
  Timestamp _due;
  final String _creator;
  String _description;

  Event(this._title, this._completed, this._due, this._creator,
      this._description);

  String get title => _title;
  bool get completed => _completed;
  Timestamp get due => _due;
  String get creator => _creator;
  String get description => _description;

  set completed(bool value) {
    _completed = value;
  }

  set due(Timestamp value) {
    _due = value;
  }

  set description(String value) {
    _description = value;
  }
}
