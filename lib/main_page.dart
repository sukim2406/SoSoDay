import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

import './widgets/bottom_navbar.dart';
import './welcome_page.dart';
import './photo_page.dart';
import './chat_page.dart';
import './event_page.dart';
import './setting_page.dart';
import './onhold_page.dart';
import './controllers/match_controller.dart';
import './controllers/auth_controller.dart';
import './controllers/user_controller.dart';

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
      Center(child: PhotoPage()),
      Center(child: ChatPage(matchDocId: widget.matchDocId, user: widget.user)),
      Center(child: EventPage()),
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
      print(_curIndex);
    });
  }

  @override
  void initState() {
    _setScreens();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: widget.connected
            ? _screens[_curIndex]
            : OnholdPage(user: widget.user),
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _curIndex,
        setCurIndex: _setCurIndex,
      ),
    );
  }
}
