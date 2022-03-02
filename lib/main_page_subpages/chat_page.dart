import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:soso_day/controllers/match_controller.dart';
import '../widgets/message_tile.dart';

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
  final itemKey = GlobalKey();
  ScrollController scrollController = ScrollController();

  var messageController = TextEditingController();

  void sendMessage(matchDocId) async {
    Map<String, dynamic> messageMap = {
      'sender': widget.user,
      'message': messageController.text,
      'time': Timestamp.now()
    };

    MatchController.instance.sendMessage(widget.matchDocId, messageMap);

    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 300,
      curve: Curves.easeOut,
      duration: const Duration(milliseconds: 300),
    );
  }

  Stream<QuerySnapshot> getStream() async* {
    yield* FirebaseFirestore.instance
        .collection('matches')
        .where('couple', arrayContains: widget.user)
        .snapshots();
  }

  Widget ChatMessageList(controller) {
    print('user');
    print(widget.user);
    return StreamBuilder<QuerySnapshot>(
        stream: getStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error');
          } else {
            if (!snapshot.hasData) {
              return Text('Empty');
            }
            return ListView.builder(
              reverse: true,
              // controller: controller,
              itemCount: snapshot.data!.docs.first['chats'].length,
              itemBuilder: (context, index) {
                return MessageTile(
                  message: snapshot.data!.docs.first['chats'][
                          snapshot.data!.docs.first['chats'].length - 1 - index]
                      ['message'],
                  isMyMessage: (snapshot.data!.docs.first['chats'][
                              snapshot.data!.docs.first['chats'].length -
                                  1 -
                                  index]['sender'] ==
                          widget.user)
                      ? true
                      : false,
                  matchDocData: snapshot.data!.docs.first,
                  userId: widget.user,
                  time: snapshot.data!.docs.first['chats'][
                          snapshot.data!.docs.first['chats'].length - 1 - index]
                      ['time'],
                );
              },
            );
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Stack(
      children: [
        Container(
            padding: const EdgeInsets.only(bottom: 50),
            color: Color.fromRGBO(242, 236, 217, 1),
            alignment: Alignment.center,
            child: ChatMessageList(scrollController)),
        Container(
            alignment: Alignment.bottomCenter,
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                    controller: messageController,
                    style: TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                    decoration: InputDecoration(
                        hintText: 'Message',
                        hintStyle:
                            TextStyle(color: Color.fromRGBO(85, 74, 53, 1)),
                        border: InputBorder.none),
                  )),
                  GestureDetector(
                    onTap: () {
                      if (messageController.text.isNotEmpty) {
                        sendMessage(widget.matchDocId);
                        messageController.text = '';
                      }
                    },
                    child: Icon(
                      Icons.send,
                      color: Color.fromRGBO(85, 74, 53, 1),
                    ),
                  )
                ],
              ),
            ))
      ],
    ));
  }
}
