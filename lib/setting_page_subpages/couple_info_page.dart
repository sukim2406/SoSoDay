import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:soso_day/main_page.dart';

import '../widgets/log_input.dart';
import '../widgets/log_btn.dart';
import '../controllers/match_controller.dart';

class CoupleInfoPage extends StatefulWidget {
  final user;
  final snapshot;
  final matchDocID;
  const CoupleInfoPage(
      {Key? key,
      required this.user,
      required this.snapshot,
      required this.matchDocID})
      : super(key: key);

  @override
  _CoupleInfoPageState createState() => _CoupleInfoPageState();
}

class _CoupleInfoPageState extends State<CoupleInfoPage> {
  String date = '';
  DateTime selectedDate = DateTime.now();
  TextEditingController sinceController = TextEditingController();

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1990),
        lastDate: DateTime(2025));

    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
  }

  _getSince() {
    setState(() {
      selectedDate = widget.snapshot.data![0]['since'].toDate();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSince();
  }

  // _getSince() async{
  //   await MatchController.instance.g
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.all(30),
            child: Text('Between Us', style: TextStyle(fontSize: 25)),
          ),
          Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('In love since...'),
                      LogInput(
                        inputIcon: Icon(Icons.calendar_today),
                        inputText:
                            selectedDate.toLocal().toString().substring(0, 10),
                        controller: sinceController,
                        obscure: false,
                        enabled: false,
                      ),
                      GestureDetector(
                        onTap: () {
                          _selectDate(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 5),
                          width: MediaQuery.of(context).size.width,
                          child: Text('modify',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline)),
                        ),
                      )
                    ],
                  )
                ],
              )),
          GestureDetector(
            onTap: () {
              MatchController.instance.updateMatchDocument(
                  widget.matchDocID, 'since', Timestamp.fromDate(selectedDate));
              Get.offAll(() => MainPage(
                  user: widget.user,
                  connected: true,
                  matchDocId: widget.matchDocID));
            },
            child: Container(
              margin: EdgeInsets.all(15),
              alignment: Alignment.center,
              child: LogBtn(
                btnText: 'Update',
                btnWidth: MediaQuery.of(context).size.width * .7,
                btnHeight: MediaQuery.of(context).size.height * .05,
                btnFontSize: 15,
              ),
            ),
          )
        ],
      ),
    );
  }
}