import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// import '../globals.dart' as globals;
import '../controllers/match_controller.dart';
// import '../controllers/auth_controller.dart';
import '../main_page_subpages/welcome_page_final.dart';
import '../main_page_subpages/photo_page_final.dart';
import '../main_page_subpages/chat_page_final.dart';
import '../main_page_subpages/event_page_final.dart';
import '../main_page_subpages/settings_page_final.dart';
import '../main_page_subpages/onhold_page.dart';
import '../indiviual_widgets/bottom_navbar.dart';

class MainLanding extends StatefulWidget {
  final user;
  final String myUid;
  final String matchDocId;
  final bool connected;
  const MainLanding({
    Key? key,
    required this.matchDocId,
    required this.connected,
    required this.myUid,
    required this.user,
  }) : super(key: key);

  @override
  State<MainLanding> createState() => _MainLandingState();
}

class _MainLandingState extends State<MainLanding> {
  int curIndex = 0;

  void setCurIndex(int index) {
    setState(() {
      curIndex = index;
    });
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
        if (snapshot.hasError || !snapshot.hasData) {
          return const Text('getStream error');
        } else {
          return Scaffold(
            body: Center(
              child: (widget.connected)
                  ? curIndex == 0
                      ? Center(
                          child: WelComePageFinal(
                            matchDoc: snapshot.data?.data() as Map,
                          ),
                        )
                      : curIndex == 1
                          ? Center(
                              child: PhotoPageFinal(
                                matchDocId: widget.matchDocId,
                                matchDoc: snapshot.data?.data() as Map,
                                myUid: widget.myUid,
                              ),
                            )
                          : curIndex == 2
                              ? Center(
                                  child: ChatPageFinal(
                                    matchDoc: snapshot.data?.data() as Map,
                                    matchDocId: widget.matchDocId,
                                    myUid: widget.myUid,
                                  ),
                                )
                              : curIndex == 3
                                  ? Center(
                                      child: EventPageFinal(
                                        matchDoc: snapshot.data?.data() as Map,
                                        matchDocId: widget.matchDocId,
                                        myUid: widget.myUid,
                                      ),
                                    )
                                  : Center(
                                      child: SettingsPageFinal(
                                        user: widget.user,
                                        matchDoc: snapshot.data?.data() as Map,
                                        matchDocId: widget.matchDocId,
                                        myUid: widget.myUid,
                                      ),
                                    )
                  : OnholdPage(
                      myUid: widget.myUid,
                      user: widget.user,
                    ),
            ),
            bottomNavigationBar: BottomNavbar(
              currentIndex: curIndex,
              setCurIndex: setCurIndex,
              myUid: widget.myUid,
              matchDoc: snapshot.data?.data() as Map,
            ),
          );
        }
      },
    );
  }
}
