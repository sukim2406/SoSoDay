import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../globals.dart' as globals;
import '../indiviual_widgets/messagge.dart';
import '../controllers/match_controller.dart';

class ChatPageFinal extends StatefulWidget {
  final Map matchDoc;
  final String myUid;
  final String matchDocId;

  const ChatPageFinal({
    Key? key,
    required this.matchDoc,
    required this.myUid,
    required this.matchDocId,
  }) : super(key: key);

  @override
  State<ChatPageFinal> createState() => _ChatPageFinalState();
}

class _ChatPageFinalState extends State<ChatPageFinal> {
  ScrollController scrollController = ScrollController();
  TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(bottom: 50),
          color: globals.tertiaryColor,
          alignment: Alignment.center,
          child: ListView.builder(
            controller: scrollController,
            reverse: true,
            itemCount: widget.matchDoc['chats'].length,
            itemBuilder: (context, index) {
              return Message(
                  matchDoc: widget.matchDoc,
                  messageData: widget.matchDoc['chats']
                      [widget.matchDoc['chats'].length - 1 - index],
                  myUid: widget.myUid);
            },
          ),
        ),
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
                    style: TextStyle(color: globals.secondaryColor),
                    decoration: InputDecoration(
                      hintText: 'Message',
                      hintStyle: TextStyle(color: globals.secondaryColor),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (messageController.text.isNotEmpty) {
                      Map<String, dynamic> messageMap = {
                        'sender': widget.myUid,
                        'message': messageController.text,
                        'time': Timestamp.now(),
                      };

                      MatchController.instance
                          .sendMessage(widget.matchDocId, messageMap);
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent + 300,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                      messageController.clear();
                    }
                  },
                  child: Icon(
                    Icons.send,
                    color: globals.secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
