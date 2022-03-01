import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './widgets/log_btn.dart';
import './controllers/match_controller.dart';

class EventForm extends StatefulWidget {
  final matchDocId;
  var event;
  EventForm({Key? key, this.event, required this.matchDocId}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final formKey = GlobalKey<FormState>();
  String title = '';
  String creator = '';
  String name = '';
  DateTime due = DateTime.now();
  String description = '';
  bool completed = false;

  TextEditingController titleController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    initialData();
    super.initState();
  }

  void initialData() async {
    if (widget.event != null) {
      title = widget.event['title'];
      creator = widget.event['creator'];
      // creator = await MatchController.instance
      //     .getUserNameById(widget.event['creator'], widget.matchDocId);
      due = widget.event['due'].toDate().toUtc();
      completed = widget.event['completed'];
      name = widget.event['userName'];
      if (widget.event['description'] == null) {
        description = '';
      } else {
        description = widget.event['description'];
      }
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: due,
        firstDate: DateTime(1990),
        lastDate: DateTime(2025));

    if (selected != null && selected != due) {
      setState(() {
        due = selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print('testing');
    print(creator);
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('img/event-detail-app-bar.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        // backgroundColor: Color.fromRGBO(255, 222, 158, 1),
        iconTheme: IconThemeData(
          color: Color.fromRGBO(85, 74, 53, 1),
        ),
        // title: Text(
        //   'EVENT DETAILS',
        //   style: TextStyle(
        //     color: Color.fromRGBO(85, 74, 53, 1),
        //   ),
        // ),
      ),
      body: Form(
        key: this.formKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextFormField(
                // controller: titleController,
                initialValue: title,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                onChanged: (val) {
                  setState(() {
                    title = val;
                  });
                },
                onSaved: (val) {},
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Title can not be empty';
                  }
                },
              ),
              TextFormField(
                  enabled: false,
                  initialValue: name,
                  decoration: InputDecoration(labelText: 'Creator'),
                  onSaved: (val) {},
                  validator: (val) {
                    return null;
                  }),
              TextFormField(
                  // key: Key(due.toString()),
                  // onTap: () => _selectDate(context),
                  enabled: false,
                  initialValue: due.toString(),
                  decoration: InputDecoration(labelText: 'Due Date'),
                  onSaved: (val) {},
                  validator: (val) {
                    return null;
                  }),
              TextFormField(
                  initialValue: description,
                  decoration: InputDecoration(labelText: 'Description'),
                  onChanged: (val) {
                    setState(() {
                      description = val;
                    });
                  },
                  onSaved: (val) {},
                  validator: (val) {
                    return null;
                  }),
              Row(
                children: [
                  Text('Set completed'),
                  Checkbox(
                      value: completed,
                      onChanged: (bool? val) {
                        setState(() {
                          completed = val!;
                        });
                      })
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
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
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .03,
                        width: MediaQuery.of(context).size.width * .3,
                        child: Image(
                          image: AssetImage('img/backBtn.png'),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (this.formKey.currentState!.validate()) {
                        Map<String, dynamic> newData = {
                          'title': title,
                          'due': Timestamp.fromDate(due),
                          'description': description,
                          'completed': completed,
                          'selectedDay': widget.event['selectedDay'],
                          'creator': widget.event['creator']
                        };
                        if (widget.event['title'] != '') {
                          MatchController.instance
                              .modifyEvent(
                                  widget.matchDocId, widget.event, newData)
                              .then((result) {});
                        } else {
                          MatchController.instance
                              .addEvent(widget.matchDocId, newData);
                        }
                        Navigator.pop(context);
                        // Get.snackbar('Saved', 'Form Saved');
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      child: Container(
                        height: MediaQuery.of(context).size.height * .03,
                        width: MediaQuery.of(context).size.width * .3,
                        child: Image(
                          image: AssetImage('img/save-btn.png'),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
