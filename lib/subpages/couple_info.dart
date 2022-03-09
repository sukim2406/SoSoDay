import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../globals.dart' as globals;
import '../controllers/match_controller.dart';
import '../main_pages/main_landing.dart';

class CoupleInfo extends StatefulWidget {
  final String matchDocId;
  final Map matchDoc;
  final String myUid;
  final user;

  const CoupleInfo({
    Key? key,
    required this.user,
    required this.matchDoc,
    required this.matchDocId,
    required this.myUid,
  }) : super(key: key);

  @override
  State<CoupleInfo> createState() => _CoupleInfoState();
}

class _CoupleInfoState extends State<CoupleInfo> {
  TextEditingController sinceController = TextEditingController();
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.all(30),
          child: Text(
            'Between us',
            style: TextStyle(
              fontSize: 25,
              color: globals.secondaryColor,
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Background image',
                    style: TextStyle(
                      color: globals.secondaryColor,
                    ),
                  ),
                  Expanded(
                    child: Container(),
                  ),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: globals.tertiaryColor,
                          title: const Text('Unset background image?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  color: globals.secondaryColor,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                MatchController.instance.updateMatchDocument(
                                    widget.matchDocId, 'backgroundImage', '');
                                Navigator.pop(context);
                              },
                              child: Text(
                                'OK',
                                style: TextStyle(
                                  color: globals.secondaryColor,
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    child: Text(
                      'Click to unset',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: globals.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: globals.getHeight(context) * .2,
                width: globals.getwidth(context),
                decoration: BoxDecoration(
                  color: globals.tertiaryColor,
                ),
                child: Image(
                  image: (widget.matchDoc['backgroundImage'] == '')
                      ? const AssetImage('img/welcomepage.png')
                      : NetworkImage(widget.matchDoc['backgroundImage'])
                          as ImageProvider,
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'In love since',
                    style: TextStyle(
                      color: globals.secondaryColor,
                    ),
                  ),
                  TextField(
                    style: TextStyle(
                      color: globals.secondaryColor,
                    ),
                    enabled: false,
                    controller: sinceController,
                    obscureText: false,
                    decoration: globals.textFieldDecoration(
                        selectedDate.toLocal().toString().substring(0, 10)),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final DateTime? selected = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(1990),
                        lastDate: DateTime(2030),
                        builder: (context, child) => Theme(
                          child: child!,
                          data: ThemeData().copyWith(
                            colorScheme: ColorScheme.dark(
                              primary: globals.primaryColor,
                              surface: globals.primaryColor,
                              onSurface: globals.secondaryColor,
                            ),
                          ),
                        ),
                      );
                      if (selected != null && selected != selectedDate) {
                        setState(() {
                          selectedDate = selected;
                        });
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 5),
                      width: globals.getwidth(context),
                      child: Text(
                        'modify',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: globals.secondaryColor,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            MatchController.instance.updateMatchDocument(
              widget.matchDocId,
              'since',
              Timestamp.fromDate(selectedDate),
            );
            Get.offAll(
              () => MainLanding(
                  user: widget.user,
                  myUid: widget.myUid,
                  connected: false,
                  matchDocId: widget.matchDocId),
            );
          },
          child: Container(
            margin: const EdgeInsets.all(30),
            alignment: Alignment.center,
            child: Container(
              height: globals.getHeight(context) * .04,
              width: globals.getwidth(context) * .4,
              child: const Image(
                image: AssetImage('img/update-btn.png'),
              ),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Container(),
            ),
            TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: globals.tertiaryColor,
                    title: const Text('Clear all data'),
                    content: Text(
                      'Clear data connot be undone, are you sure ?',
                      style: TextStyle(
                        color: globals.secondaryColor,
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: globals.secondaryColor,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          MatchController.instance
                              .clearAllData(widget.matchDocId);
                        },
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.redAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
              child: Text(
                'Clear all data',
                style: TextStyle(
                  color: globals.secondaryColor,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
