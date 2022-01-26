import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../setting_page_subpages/account_info_page.dart';
import '../setting_page_subpages/reset_password_page.dart';
import '../setting_page_subpages/couple_info_page.dart';

class SettingPage extends StatelessWidget {
  final matchDocId;
  final user;
  const SettingPage({Key? key, required this.user, required this.matchDocId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                                    Tab(icon: Icon(Icons.vpn_key_rounded)),
                                    Tab(icon: Icon(Icons.favorite))
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      body: TabBarView(
                        children: [
                          AccountInfoPage(
                              user: user,
                              snapshot: snapshot,
                              matchDocId: matchDocId),
                          ResetPasswordPage(
                            user: user,
                          ),
                          CoupleInfoPage(
                            user: user,
                            snapshot: snapshot,
                            matchDocID: matchDocId,
                          ),
                        ],
                      ))));
        });
  }
}
