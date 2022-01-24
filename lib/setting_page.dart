import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import './widgets/log_input.dart';
import './widgets/log_btn.dart';
import './controllers/user_controller.dart';
import './controllers/match_controller.dart';
// class SettingPage extends StatefulWidget {
//   const SettingPage({Key? key}) : super(key: key);

//   @override
//   _SettingPageState createState() => _SettingPageState();
// }

// class _SettingPageState extends State<SettingPage> {
//   var emailController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder(
//         future: FirebaseFirestore.instance.collection('matches').doc().get(),
//         builder:
//             (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
//           if (snapshot.hasError || !snapshot.hasData) {
//             return Text('error');
//           }
//           return MaterialApp(
//               home: DefaultTabController(
//                   length: 3,
//                   child: Scaffold(
//                       appBar: PreferredSize(
//                         preferredSize: Size.fromHeight(kToolbarHeight),
//                         child: Container(
//                           color: Colors.green,
//                           child: SafeArea(
//                             child: Column(
//                               children: <Widget>[
//                                 Expanded(child: Container()),
//                                 TabBar(
//                                   tabs: [
//                                     Tab(icon: Icon(Icons.account_box_rounded)),
//                                     Tab(icon: Icon(Icons.arrow_back)),
//                                     Tab(icon: Icon(Icons.arrow_upward))
//                                   ],
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                       body: TabBarView(
//                         children: [
//                           Container(
//                               child: Column(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.all(30),
//                                 child: Text('Account Settings',
//                                     style: TextStyle(
//                                       fontSize: 25,
//                                     )),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.all(15),
//                                 height:
//                                     MediaQuery.of(context).size.height * .06,
//                                 child: LogInput(
//                                   inputIcon: Icon(Icons.email_rounded),
//                                   inputText: 'email',
//                                   controller: emailController,
//                                   obscure: false,
//                                   enabled: false,
//                                 ),
//                               )
//                             ],
//                           )),
//                           Icon(Icons.arrow_back),
//                           Icon(Icons.arrow_upward)
//                         ],
//                       ))));
//         });
//   }
// }

class SettingPage extends StatelessWidget {
  final matchDocId;
  final user;
  const SettingPage({Key? key, required this.user, required this.matchDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var screenNameController = TextEditingController();

    Future<DocumentSnapshot> matchDoc =
        FirebaseFirestore.instance.collection('matches').doc(matchDocId).get();
    Future<DocumentSnapshot> userDoc =
        FirebaseFirestore.instance.collection('users').doc(user.uid).get();

    return FutureBuilder(
        future: Future.wait([matchDoc, userDoc]),
        builder: (BuildContext context,
            AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.hasError || !snapshot.hasData) {
            return Text('error');
          }
          // List<Map<String, dynamic>> data =
          //     snapshot.data as List<Map<String, dynamic>>;
          return MaterialApp(
              home: DefaultTabController(
                  length: 3,
                  child: Scaffold(
                      appBar: PreferredSize(
                        preferredSize: Size.fromHeight(kToolbarHeight),
                        child: Container(
                          color: Colors.green,
                          child: SafeArea(
                            child: Column(
                              children: <Widget>[
                                Expanded(child: Container()),
                                TabBar(
                                  tabs: [
                                    Tab(icon: Icon(Icons.account_box_rounded)),
                                    Tab(icon: Icon(Icons.arrow_back)),
                                    Tab(icon: Icon(Icons.arrow_upward))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.all(30),
                                child: Text('Account Settings',
                                    style: TextStyle(
                                      fontSize: 25,
                                    )),
                              ),
                              Container(
                                margin: EdgeInsets.all(15),
                                // height:
                                //     MediaQuery.of(context).size.height * .06,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'E-mail',
                                    ),
                                    LogInput(
                                      inputIcon: Icon(Icons.email_rounded),
                                      inputText: user.email,
                                      controller: emailController,
                                      obscure: false,
                                      enabled: false,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.all(15),
                                // height:
                                //     MediaQuery.of(context).size.height * .06,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Screen Name'),
                                    LogInput(
                                      inputIcon: Icon(Icons.email_rounded),
                                      inputText: snapshot.data![1]['name'],
                                      controller: screenNameController,
                                      obscure: false,
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  var screenNames =
                                      snapshot.data![0]['screenNames'];
                                  var newScreenNames = [];
                                  UserController.instance.updateUserDocument(
                                      snapshot.data![1].id,
                                      'name',
                                      screenNameController.text);

                                  screenNames.forEach((user) {
                                    print('user');
                                    print(user);
                                    print(snapshot.data![1]['name']);
                                    if (user == snapshot.data![1]['name']) {
                                      newScreenNames
                                          .add(screenNameController.text);
                                    } else {
                                      newScreenNames.add(user);
                                    }
                                  });
                                  MatchController.instance.updateMatchDocument(
                                      snapshot.data![0].id,
                                      'screenNames',
                                      newScreenNames);
                                  print(newScreenNames);
                                },
                                child: Container(
                                  margin: EdgeInsets.all(30),
                                  alignment: Alignment.center,
                                  child: LogBtn(
                                      btnText: 'Update',
                                      btnWidth:
                                          MediaQuery.of(context).size.width *
                                              .7,
                                      btnHeight:
                                          MediaQuery.of(context).size.height *
                                              .05,
                                      btnFontSize: 20),
                                ),
                              )
                            ],
                          )),
                          Icon(Icons.arrow_back),
                          Icon(Icons.arrow_upward)
                        ],
                      ))));
        });
  }
}
