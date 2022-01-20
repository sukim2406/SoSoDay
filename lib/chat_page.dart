import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:soso_day/controllers/match_controller.dart';

class ChatPage extends StatefulWidget {
  final matchDocId;
  final user;
  const ChatPage({Key? key, required this.matchDocId, required this.user})
      : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  // Widget ChatMessageList() {}
  var messageController = TextEditingController();
  late Stream chatMessageStream;

  void sendMessage(matchDocId) async {
    Map<String, dynamic> messageMap = {
      'sender': widget.user.email,
      'message': messageController.text,
      'time': Timestamp.now()
    };

    MatchController.instance.sendMessage(widget.matchDocId, messageMap);
  }

  // Widget ChatMessageList() {
  //   return StreamBuilder(
  //     stream: chatMessageStream,
  //     builder: (context, snapshot) {
  //       if(snapshot.hasData){
  //         return ListView.builder(
  //           itemCount: snapshot.data!.docs.length,
  //           itemBuilder: (context, index) {return MessageTile(snap)},
  //         );
  //       }else{
  //         return Text('Error');
  //       }
  //     },
  //   );
  // }

  @override
  void initState() {
    MatchController.instance.getMessageStream(widget.matchDocId).then((value) {
      setState(() {
        chatMessageStream = value;
        print('initstate');
        print(chatMessageStream);
      });
      print('hi');
      print(chatMessageStream.length);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                      onTap: () {
                        if (messageController.text.isNotEmpty) {
                          sendMessage(widget.matchDocId);
                        }
                      },
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: [
                              Color(0x36FFFFFF),
                              Color(0x0FFFFFFF),
                            ]),
                            borderRadius: BorderRadius.circular(40)),
                        padding: const EdgeInsets.all(12),
                        child: Image.asset('img/profile.png'),
                      ))
                ],
              ),
            ))
      ],
    ));
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  const MessageTile({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message),
    );
  }
}
