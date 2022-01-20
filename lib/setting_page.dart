import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
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
                              Tab(icon: Icon(Icons.arrow_forward)),
                              Tab(icon: Icon(Icons.arrow_back)),
                              Tab(icon: Icon(Icons.arrow_upward))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                )
                // AppBar(
                //   bottom: TabBar(
                //     tabs: [
                //       Tab(icon: Icon(Icons.arrow_forward)),
                //       Tab(icon: Icon(Icons.arrow_back)),
                //       Tab(icon: Icon(Icons.arrow_upward))
                //     ],
                //   ),
                // )
                ,
                body: TabBarView(
                  children: [
                    Icon(Icons.arrow_forward),
                    Icon(Icons.arrow_back),
                    Icon(Icons.arrow_upward)
                  ],
                ))));
  }
}
