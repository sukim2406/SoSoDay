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
  late Map<DateTime, List<Map>> selectEvents;
  late String userName;
  late DateTime _selectedDay = DateTime.now();
  var _focusedDay;
  var _calendarFormat = CalendarFormat.month;
  TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    selectedEvents = {};
    selectEvents = {};
    userName = '';
    saveUserName();
    // saveAsSelectedEvents();
    super.initState();
  }

  // List<Event> _getEventsfromDay(DateTime date) {
  //   return selectedEvents[date] ?? [];
  // }

  List<Map> _getEventsFromDay(DateTime date) {
    return selectEvents[date] ?? [];
  }

  Future getProfilePicture(uid) async {
    var url =
        await MatchController.instance.getUserImageById(uid, widget.matchDocId);

    return url.toString();
  }

  void saveUserName() async {
    var data = await UserController.instance.getUsername(widget.user);
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
        .where('couple', arrayContains: widget.user)
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

        snapshot.data!.docs.first['events'].forEach((event) {
          if (selectEvents[event['selectedDay'].toDate().toUtc()] == null) {
            selectEvents[event['selectedDay'].toDate().toUtc()] = [event];
          } else {
            bool duplicateCheck = false;
            selectEvents[event['selectedDay'].toDate().toUtc()]!
                .forEach((data) {
              if (data['due'] == event['due']) {
                duplicateCheck = true;
              }
            });
            if (!duplicateCheck) {
              selectEvents[event['selectedDay'].toDate().toUtc()]!.add(event);
            }
          }
          // if (selectEvents[event['selectedDay'].toDate().toUtc()] != null) {
          //   selectEvents[event['selectedDay'].toDate().toUtc()]!
          //       .forEach((data) {
          //     if (data['selectedDay'] == event['selectedDay']) {
          //     } else {
          //       selectEvents[event['selectedDay'].toDate().toUtc()]!.add(event);
          //     }
          //   });
          // } else {
          //   selectEvents[event['selectedDay'].toDate().toUtc()] = [event];
          // }
          // print(selectEvents);
        });

        return TableCalendar(
          calendarStyle: CalendarStyle(
            markerDecoration: BoxDecoration(
                color: Color.fromRGBO(255, 222, 158, 1),
                shape: BoxShape.circle),
            todayDecoration: BoxDecoration(
                color: Color.fromRGBO(242, 236, 217, 1),
                shape: BoxShape.circle),
            selectedDecoration: BoxDecoration(
                color: Color.fromRGBO(85, 74, 53, 1), shape: BoxShape.circle),
          ),
          firstDay: DateTime.utc(2020, 01, 01),
          lastDay: DateTime.utc(2030, 12, 31),
          focusedDay: DateTime.now(),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            print('onDaySelected');
            print(selectedDay);
            print(focusedDay);
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
            print('onPageChanged');
            print(_selectedDay);
            print(focusedDay);
            _focusedDay = focusedDay;
          },
          eventLoader: _getEventsFromDay,
        );
      },
    );
  }

  Future<Widget> TileList() async {
    return ListView.builder(
      // shrinkWrap: true,
      itemCount: _getEventsFromDay(_selectedDay).length,
      itemBuilder: (context, index) {
        return EventTile(
          event: _getEventsFromDay(_selectedDay)[index],
          matchDocId: widget.matchDocId,
          // imageUrl: getProfilePicture(
          //     _getEventsFromDay(_selectedDay)[index]['creator']),
          imageUrl: MatchController.instance
              .getUserImageById(
                  _getEventsFromDay(_selectedDay)[index]['creator'],
                  widget.matchDocId)
              .then((data) {
            print('gggggg');
            print(data);
            return data;
          }),
          userName: userName,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        SizedBox(height: 100),
        Container(
          child: Calendar(),
        ),
        SizedBox(height: 30),
        Container(
          color: Color.fromRGBO(242, 236, 217, 1),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                // child: Text(_selectedDay.toString().substring(0, 10)),
                child: Row(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: 'events on ',
                        style: TextStyle(
                          color: Color.fromRGBO(85, 74, 53, 1),
                        ),
                        children: [
                          TextSpan(
                            text: _selectedDay.toString().substring(0, 10),
                            style: TextStyle(
                                color: Color.fromRGBO(85, 74, 53, 1),
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              ConstrainedBox(
                constraints: new BoxConstraints(minHeight: 0, maxHeight: 200),
                child: ListView.builder(
                  // shrinkWrap: true,
                  reverse: true,
                  itemCount: _getEventsFromDay(_selectedDay).length,
                  itemBuilder: (context, index) {
                    return Container(
                      child: EventTile(
                        event: _getEventsFromDay(_selectedDay)[index],
                        matchDocId: widget.matchDocId,
                        // imageUrl: getProfilePicture(
                        //     _getEventsFromDay(_selectedDay)[index]['creator']),
                        imageUrl: MatchController.instance
                            .getUserImageById(
                                _getEventsFromDay(_selectedDay)[index]
                                    ['creator'],
                                widget.matchDocId)
                            .then((data) {
                          return data;
                        }),
                        userName: userName,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // Container(
        //   height: 200,
        //   child: ListView.builder(
        //     shrinkWrap: true,
        //     itemCount: _getEventsFromDay(_selectedDay).length,
        //     itemBuilder: (context, index) {
        //       return EventTile(
        //           event: _getEventsFromDay(_selectedDay)[index],
        //           matchDocId: widget.matchDocId);
        //     },
        //   ),
        // ),

        // ..._getEventsFromDay(_selectedDay).map((Map event) => GestureDetector(
        //       onTap: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => EventForm(
        //                       matchDocId: widget.matchDocId,
        //                       event: event,
        //                     )));
        //       },
        //       child: EventTile(
        //         event: event,
        //         matchDocId: widget.matchDocId,
        //       ),
        //     )),
        Container(
          padding: EdgeInsets.only(top: 30),
          child: FloatingActionButton.extended(
              backgroundColor: Color.fromRGBO(85, 74, 53, 1),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          backgroundColor: Color.fromRGBO(242, 236, 217, 1),
                          title: Text(
                            'Add Event',
                            style: TextStyle(
                              color: Color.fromRGBO(85, 74, 53, 1),
                            ),
                          ),
                          content: TextFormField(
                            controller: _eventController,
                          ),
                          actions: [
                            TextButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                    color: Color.fromRGBO(85, 74, 53, 1),
                                  ),
                                ),
                                onPressed: () => Navigator.pop(context)),
                            TextButton(
                                child: Text(
                                  'Detailed View',
                                  style: TextStyle(
                                    color: Color.fromRGBO(85, 74, 53, 1),
                                  ),
                                ),
                                onPressed: () {
                                  Map<String, dynamic> event = {
                                    'selectedDay':
                                        Timestamp.fromDate(_selectedDay),
                                    'title': '',
                                    'completed': false,
                                    'due': Timestamp.now(),
                                    'creator': widget.user,
                                    'userName': userName,
                                    'description': '',
                                  };
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EventForm(
                                                matchDocId: widget.matchDocId,
                                                event: event,
                                              ))).then((value) {
                                    Navigator.pop(context);
                                  });
                                }),
                            TextButton(
                              child: Text(
                                'Quick Save',
                                style: TextStyle(
                                  color: Color.fromRGBO(85, 74, 53, 1),
                                ),
                              ),
                              onPressed: () {
                                if (_eventController.text.isEmpty) {
                                } else {
                                  Map<String, dynamic> event = {
                                    'selectedDay':
                                        Timestamp.fromDate(_selectedDay),
                                    'title': _eventController.text,
                                    'completed': false,
                                    'due': Timestamp.now(),
                                    'creator': widget.user,
                                    'userName': userName,
                                    'description': '',
                                  };
                                  // if (selectedEvents[_selectedDay] != null) {
                                  //   selectedEvents[_selectedDay]?.add(Event(
                                  //       _eventController.text,
                                  //       false,
                                  //       event['due'],
                                  //       userName,
                                  //       event['description']));
                                  // } else {
                                  //   selectedEvents[_selectedDay] = [
                                  //     Event(
                                  //         _eventController.text,
                                  //         false,
                                  //         event['due'],
                                  //         userName,
                                  //         event['description'])
                                  //   ];
                                  // }
                                  MatchController.instance
                                      .addEvent(widget.matchDocId, event)
                                      .then((result) {
                                    // setState(() {
                                    //   saveAsSelectedEvents();
                                    // });
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
        ),
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
