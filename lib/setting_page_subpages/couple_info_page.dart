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
      lastDate: DateTime(2025),
      builder: (context, child) => Theme(
        child: child!,
        data: ThemeData().copyWith(
          colorScheme: ColorScheme.dark(
            primary: Color.fromRGBO(255, 222, 158, 1),
            surface: Color.fromRGBO(255, 222, 158, 1),
            onSurface: Color.fromRGBO(85, 74, 53, 1),
          ),
        ),
      ),
    );

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
            child: Text(
              'Between Us',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(85, 74, 53, 1),
              ),
            ),
          ),
          Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Background Image',
                        style: TextStyle(
                          color: Color.fromRGBO(85, 74, 53, 1),
                        ),
                      ),
                      Expanded(child: Container()),
                      TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                      backgroundColor:
                                          Color.fromRGBO(242, 236, 217, 1),
                                      title: Text('Unset Background Image?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'Cancel',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(85, 74, 53, 1),
                                            ),
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            MatchController.instance
                                                .updateMatchDocument(
                                                    widget.matchDocID,
                                                    'backgroundImage',
                                                    '');
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'OK',
                                            style: TextStyle(
                                              color:
                                                  Color.fromRGBO(85, 74, 53, 1),
                                            ),
                                          ),
                                        )
                                      ]));
                        },
                        child: Text(
                          'click to unset',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            color: Color.fromRGBO(85, 74, 53, 1),
                          ),
                        ),
                      )
                    ],
                  ),
                  // Text(widget.snapshot.data![0]['backgroundImage']),
                  Container(
                    height: MediaQuery.of(context).size.height * .2,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(242, 236, 217, 1),
                    ),
                    child: Image(
                      image: (widget.snapshot.data![0]['backgroundImage'] == '')
                          ? AssetImage('img/welcomepage.png')
                          : NetworkImage(
                                  widget.snapshot.data![0]['backgroundImage'])
                              as ImageProvider,
                    ),
                    // child: (widget.snapshot[0]['backgroundImage'] == '') ? NetworkImage(widget.snapshot[0]['backgroundImage']) as ImageProvider : AssetImage('img/signup.png'),
                  )
                ],
              )),
          Container(
              margin: EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'In love since...',
                        style: TextStyle(
                          color: Color.fromRGBO(85, 74, 53, 1),
                        ),
                      ),
                      TextField(
                        style: TextStyle(
                          color: Color.fromRGBO(85, 74, 53, 1),
                        ),
                        enabled: false,
                        controller: sinceController,
                        obscureText: false,
                        decoration: InputDecoration(
                          hintText: selectedDate
                              .toLocal()
                              .toString()
                              .substring(0, 10),
                          prefixIcon: Icon(
                            Icons.password,
                            color: Color.fromRGBO(85, 74, 53, 1),
                          ),
                          hintStyle: TextStyle(
                            color: Color.fromRGBO(85, 74, 53, 1),
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(85, 74, 53, 1),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: Color.fromRGBO(85, 74, 53, 1),
                            ),
                          ),
                        ),
                      ),
                      // LogInput(
                      //   inputIcon: Icon(Icons.calendar_today),
                      //   inputText:
                      //       selectedDate.toLocal().toString().substring(0, 10),
                      //   controller: sinceController,
                      //   obscure: false,
                      //   enabled: false,
                      // ),
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
                                  color: Color.fromRGBO(85, 74, 53, 1),
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
              margin: EdgeInsets.all(30),
              alignment: Alignment.center,
              child: Container(
                height: MediaQuery.of(context).size.height * .04,
                width: MediaQuery.of(context).size.width * .4,
                child: Image(
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
                            backgroundColor: Color.fromRGBO(242, 236, 217, 1),
                            title: Text('Clear all data'),
                            content: Text(
                              'Clearing data cannot be undone, are you sure?',
                              style: TextStyle(
                                color: Color.fromRGBO(85, 74, 53, 1),
                              ),
                            ),
                            actions: [
                              TextButton(
                                  child: Text(
                                    'Cancel',
                                    style: TextStyle(
                                      color: Color.fromRGBO(85, 74, 53, 1),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  }),
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: TextStyle(color: Colors.redAccent),
                                ),
                                onPressed: () {
                                  MatchController.instance
                                      .clearAllData(widget.matchDocID);
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ));
                },
                child: Text(
                  'Clear all data',
                  style: TextStyle(
                    color: Color.fromRGBO(85, 74, 53, 1),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          )
          // GestureDetector(
          //   onTap: () {
          //     showDialog(
          //         context: context,
          //         builder: (context) => AlertDialog(
          //               title: Text('Clear all data'),
          //               content: Text(
          //                   'Clearing data cannot be undone, are you sure?'),
          //               actions: [
          //                 TextButton(
          //                     child: Text('Cancel'),
          //                     onPressed: () {
          //                       Navigator.pop(context);
          //                     }),
          //                 TextButton(
          //                   child: Text('OK'),
          //                   onPressed: () {
          //                     MatchController.instance
          //                         .clearAllData(widget.matchDocID);
          //                     Navigator.pop(context);
          //                   },
          //                 )
          //               ],
          //             ));
          //   },
          //   child: Container(
          //     margin: EdgeInsets.all(15),
          //     alignment: Alignment.center,
          //     child: LogBtn(
          //       btnText: 'Clear All Data',
          //       btnWidth: MediaQuery.of(context).size.width * .7,
          //       btnHeight: MediaQuery.of(context).size.height * .05,
          //       btnFontSize: 15,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
