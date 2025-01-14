// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/services/chat_service/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/themes/themes_provider.dart';

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isCurrentUser;
  final String messageID;
  final String userID;
  const ChatBubble({
    super.key,
    required this.message,
    required this.isCurrentUser,
    required this.messageID,
    required this.userID,
  });

  //show options method

  void _showOptions(BuildContext context, String messageID, String userID) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
            child: Wrap(
          children: [
            //report message button
            ListTile(
              leading: Icon(Icons.flag),
              title: Text("Report"),
              onTap: () {
                Navigator.pop(context);
                _reportMessage(context, messageID, userID);
              },
            ),
            //block user
            ListTile(
              leading: Icon(Icons.block),
              title: Text("Block"),
              onTap: () {
                Navigator.pop(context);
                _blockUser(context, userID);
              },
            ),
            //cancel button
            ListTile(
              leading: Icon(Icons.cancel),
              title: Text("Cancel"),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ));
      },
    );
  }

  //report message

  void _reportMessage(BuildContext context, String messageID, String userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Report Message"),
        content: Text("Are you sure you want to report this message?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")),
          TextButton(
              onPressed: () {
                ChatService().reportUser(messageID, userID);
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("Message Reported")));
              },
              child: Text("Report"))
        ],
      ),
    );
  }

  //block user
  void _blockUser(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Block User"),
        content: Text("Are you sure you want to block this user?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")),
          TextButton(
              onPressed: () {
                ChatService().blockUser(userID);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("User Blocked")));
              },
              child: Text("Block"))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Provider.of<ThemesProvider>(context).isDark;
    return GestureDetector(
      onLongPress: () {
        if (!isCurrentUser) {
          //show options
          _showOptions(context, messageID, userID);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: isCurrentUser
              ? (isDarkMode ? Colors.green.shade600 : Colors.green.shade500)
              : (isDarkMode ? Colors.grey.shade800 : Colors.grey.shade100),
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Text(
          message,
          style: TextStyle(
              color: isCurrentUser
                  ? (isDarkMode ? Colors.white : Colors.white)
                  : isDarkMode
                      ? Colors.white
                      : Colors.black),
        ),
      ),
    );
  }
}
