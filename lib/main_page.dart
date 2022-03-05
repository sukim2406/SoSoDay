import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import './widgets/bottom_navbar.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   body: Center(
    //     child: widget.connected
    //         ? _screens[_curIndex]
    //         : OnholdPage(user: widget.user),
    //   ),
    //   bottomNavigationBar: BottomNavbar(
    //     currentIndex: _curIndex,
    //     setCurIndex: _setCurIndex,
    //   ),
    // );

    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('matches')
          .doc(widget.matchDocId)
          .snapshots(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('error');
        } else if (!snapshot.hasData) {
          return const Text('empty');
        }

        return Scaffold(
          body: Center(
            child: widget.connected
                ? _curIndex == 0
                    ? Center(
                        child: WelComePageFinal(
                          matchDoc: snapshot.data?.data(),
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
                            : _screens[_curIndex]
                : OnholdPage(user: widget.user),
          ),
          bottomNavigationBar: BottomNavbar(
            currentIndex: _curIndex,
            setCurIndex: _setCurIndex,
          ),
        );
      },
    );
    // bottomNavigationBar: StreamBuilder(
    //     stream: FirebaseFirestore.instance
    //         .collection('matches')
    //         .doc(widget.matchDocId)
    //         .snapshots(),
    //     builder:
    //         (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
    //       if (snapshot.hasError || !snapshot.hasData) {
    //         return Text('Bottom Nav Bar Stream Builder Error');
    //       }
    //       return BottomNavbar(
    //         currentIndex: _curIndex,
    //         setCurIndex: _setCurIndex,
    //         matchDocData: snapshot.data!,
    //       );
    //     }),
    // );
  }
}
