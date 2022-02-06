import 'package:flutter/material.dart';
import 'package:get/get.dart';

import './widgets/log_btn.dart';

class EventForm extends StatefulWidget {
  var event;
  EventForm({Key? key, this.event}) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final formKey = GlobalKey<FormState>();
  String title = '';
  String creator = '';
  DateTime due = DateTime.now();
  String description = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void initialData() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: this.formKey,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                onSaved: (val) {},
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Title can not be empty';
                  }
                },
              ),
              TextFormField(
                  decoration: InputDecoration(labelText: 'Createor'),
                  onSaved: (val) {},
                  validator: (val) {
                    return null;
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: 'Due Date'),
                  onSaved: (val) {},
                  validator: (val) {
                    return null;
                  }),
              TextFormField(
                  decoration: InputDecoration(labelText: 'Description'),
                  onSaved: (val) {},
                  validator: (val) {
                    return null;
                  }),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  LogBtn(
                      btnText: 'Cancel',
                      btnWidth: MediaQuery.of(context).size.width * .3,
                      btnHeight: MediaQuery.of(context).size.height * .03,
                      btnFontSize: 20),
                  GestureDetector(
                    onTap: () async {
                      if (this.formKey.currentState!.validate()) {
                        Get.snackbar('Saved', 'Form Saved');
                      }
                    },
                    child: LogBtn(
                        btnText: 'Save',
                        btnWidth: MediaQuery.of(context).size.width * .3,
                        btnHeight: MediaQuery.of(context).size.height * .03,
                        btnFontSize: 20),
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
