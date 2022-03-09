import 'package:flutter/material.dart';

import '../globals.dart' as globals;
import '../subpages/account_info.dart';
import '../subpages/reset_password.dart';
import '../subpages/couple_info.dart';

class SettingsPageFinal extends StatelessWidget {
  final Map matchDoc;
  final String matchDocId;
  final String myUid;
  final user;

  const SettingsPageFinal({
    Key? key,
    required this.user,
    required this.matchDoc,
    required this.matchDocId,
    required this.myUid,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(kToolbarHeight),
            child: Container(
              color: globals.primaryColor,
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: Container(),
                  ),
                  TabBar(
                    indicatorColor: globals.tertiaryColor,
                    tabs: [
                      Tab(
                        icon: Icon(
                          Icons.account_box_rounded,
                          color: globals.secondaryColor,
                        ),
                      ),
                      Tab(
                        icon: Icon(
                          Icons.vpn_key_rounded,
                          color: globals.secondaryColor,
                        ),
                      ),
                      Tab(
                          icon: Icon(
                        Icons.favorite,
                        color: globals.secondaryColor,
                      )),
                    ],
                  ),
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              SingleChildScrollView(
                child: SingleChildScrollView(
                  child: AccountInfo(
                    matchDoc: matchDoc,
                    matchDocId: matchDocId,
                    myUid: myUid,
                    user: user,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: SingleChildScrollView(
                  child: ResetPassword(
                    matchDoc: matchDoc,
                    myUid: myUid,
                  ),
                ),
              ),
              SingleChildScrollView(
                child: CoupleInfo(
                  matchDoc: matchDoc,
                  myUid: myUid,
                  user: user,
                  matchDocId: matchDocId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
