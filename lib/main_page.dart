import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

// import './widgets/bottom_navbar.dart';
import './main_page_subpages/welcome_page_final.dart';
import './main_page_subpages/welcome_page.dart';
import './main_page_subpages/photo_page.dart';
import './main_page_subpages/chat_page.dart';
import './main_page_subpages/event_page.dart';
import './main_page_subpages/setting_page.dart';
import './main_page_subpages/onhold_page.dart';
import './controllers/match_controller.dart';
import './controllers/auth_controller.dart';
import './controllers/user_controller.dart';
import './main_page_subpages/photo_page_final.dart';
import './main_page_subpages/chat_page_final.dart';
import './main_page_subpages/event_page_final.dart';
import './main_page_subpages/settings_page_final.dart';
import './indiviual_widgets/bottom_navbar.dart';

class MainPage extends StatefulWidget {
  final user;
  final connected;
  final matchDocId;

  MainPage(
      {Key? key,
      required this.user,
      required this.connected,
      required this.matchDocId})
      : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _curIndex = 0;
  var _screens;

  void _setScreens() {
    _screens = [
      Center(
          child: WelcomePage(
        user: widget.user,
        matchDocId: widget.matchDocId,
      )),
      Center(
          child: PhotoPage(
        matchDocId: widget.matchDocId,
        user: widget.user,
      )),
      Center(child: ChatPage(matchDocId: widget.matchDocId, user: widget.user)),
      Center(
          child: EventPage(matchDocId: widget.matchDocId, user: widget.user)),
      Center(
          child: SettingPage(
        user: widget.user,
        matchDocId: widget.matchDocId,
      )),
    ];
  }

  void _setCurIndex(int index) {
    setState(() {
      _curIndex = index;
    });
  }

  @override
  void initState() {
    _setScreens();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('matches')
            .doc(widget.matchDocId)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          // switch (snapshot.connectionState) {
          //   case ConnectionState.none:
          //     return Text('Connection State None');
          //   case ConnectionState.active:
          //   case ConnectionState.waiting:
          //     return Container(
          //       height: MediaQuery.of(context).size.height * .8,
          //       width: MediaQuery.of(context).size.width,
          //       child: Center(
          //         child: CircularProgressIndicator(),
          //       ),
          //     );
          //   case ConnectionState.done:
          if (snapshot.hasError)
            return const Text('error');
          else if (!snapshot.hasData) return const Text('empty');
          return Scaffold(
            body: Center(
              child: widget.connected
                  ? _curIndex == 0
                      ? Center(
                          child: WelComePageFinal(
                            matchDoc: snapshot.data?.data() as Map,
                          ),
                        )
                      : _curIndex == 1
                          ? Center(
                              child: PhotoPageFinal(
                                matchDoc: snapshot.data?.data() as Map,
                                matchDocId: widget.matchDocId,
                                myUid: widget.user,
                              ),
                            )
                          : _curIndex == 2
                              ? Center(
                                  child: ChatPageFinal(
                                    matchDoc: snapshot.data?.data() as Map,
                                    matchDocId: widget.matchDocId,
                                    myUid: widget.user,
                                  ),
                                )
                              : _curIndex == 3
                                  ? Center(
                                      child: EventPageFinal(
                                        myUid: widget.user,
                                        matchDoc: snapshot.data?.data() as Map,
                                        matchDocId: widget.matchDocId,
                                      ),
                                    )
                                  : Center(
                                      child: SettingsPageFinal(
                                        myUid: widget.user,
                                        matchDoc: snapshot.data?.data() as Map,
                                        matchDocId: widget.matchDocId,
                                      ),
                                    )
                  : OnholdPage(
                      myUid: widget.user.uid,
                      user: widget.user,
                    ),
            ),
            bottomNavigationBar: BottomNavbar(
              currentIndex: _curIndex,
              setCurIndex: _setCurIndex,
              myUid: widget.user,
              matchDoc: snapshot.data?.data() as Map,
            ),
          );
        });
  }
}
