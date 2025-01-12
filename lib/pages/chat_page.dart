// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/components/my_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/services/auth_service/auth_service.dart';
import 'package:chat_app/services/chat_service/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();

  //chats & auth service
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();

  //send message
  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(
          widget.receiverID, _messageController.text);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          widget.receiverEmail,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          //display all messages

          Expanded(
            child: _buildMessageList(),
          ),

          //user input
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.currentUser!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID),
      builder: (context, snapshot) {
        //error
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
        //loading
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        //return list view
        return ListView(
          children: snapshot.data!.docs
              .map<Widget>((doc) => _buildMessageItem(doc))
              .toList(),
        );
      },
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    bool isCurrentUser = data["senderID"] == _authService.currentUser!.uid;

    var alignment =
        isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(alignment: alignment, child: Text(data["message"]));
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 50),
      child: Row(
        children: [
          Expanded(
              child: MyTextfield(
                  hintText: "Type a message",
                  obbscureText: false,
                  controller: _messageController)),
          Container(
            margin: const EdgeInsets.only(right: 25),
            child: IconButton(onPressed: sendMessage, icon: Icon(Icons.send)))
        ],
      ),
    );
  }
}
