import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../globals.dart' as globals;
import '../controllers/match_controller.dart';

class EventDetail extends StatefulWidget {
  final String matchDocId;
  final Map event;

  const EventDetail({
    Key? key,
    required this.matchDocId,
    required this.event,
  }) : super(key: key);

  @override
  State<EventDetail> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetail> {
  final formKey = GlobalKey<FormState>();
  String title = '';
  String name = '';
  String creator = '';
  DateTime due = DateTime.now();
  String description = '';
  bool completed = false;

  @override
  void initState() {
    // TODO: implement initState
    initialData();
    super.initState();
  }

  void initialData() {
    if (widget.event != null) {
      title = widget.event['title'];
      creator = widget.event['creator'];
      due = widget.event['due'].toDate().toUtc();
      completed = widget.event['completed'];
      name = widget.event['name'];
      description = widget.event['description'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('img/event-detail-app-bar.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: globals.secondaryColor,
        ),
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (val) {
                  setState(() {
                    title = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Title can not be empty';
                  }
                },
              ),
              TextFormField(
                enabled: false,
                initialValue: name,
                decoration: const InputDecoration(
                  labelText: 'Creator',
                ),
              ),
              TextFormField(
                enabled: false,
                initialValue: due.toString(),
                decoration: const InputDecoration(
                  labelText: 'Due Date',
                ),
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(
                  labelText: 'Description',
                ),
                onChanged: (val) {
                  setState(
                    () {
                      description = val;
                    },
                  );
                },
              ),
              Row(
                children: [
                  const Text('Set completed'),
                  Checkbox(
                    value: completed,
                    onChanged: (bool? val) {
                      setState(
                        () {
                          completed = val!;
                        },
                      );
                    },
                  ),
                ],
              ),
              SizedBox(
                height: globals.getHeight(context) * .1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () {
                        MatchController.instance
                            .deleteEvent(widget.matchDocId, widget.event)
                            .then((result) {
                          Navigator.pop(context);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: globals.getHeight(context) * .03,
                          width: globals.getwidth(context) * .3,
                          child: const Image(
                            image: AssetImage('img/backBtn.png'),
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (formKey.currentState!.validate()) {
                          Map<String, dynamic> newData = {
                            'title': title,
                            'due': Timestamp.fromDate(due),
                            'description': description,
                            'completed': completed,
                            'selectedDay': widget.event['selectedDay'],
                            'creator': widget.event['creator'],
                          };

                          if (widget.event['title'].isNotEmpty) {
                            MatchController.instance.modifyEvent(
                                widget.matchDocId, widget.event, newData);
                          } else {
                            MatchController.instance
                                .addEvent(widget.matchDocId, newData);
                          }
                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: SizedBox(
                          height: globals.getHeight(context) * 03,
                          width: globals.getwidth(context) * .3,
                          child: const Image(
                            image: AssetImage(
                              'img/save-btn.png',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
