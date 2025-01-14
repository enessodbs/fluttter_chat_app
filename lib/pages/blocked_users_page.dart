import 'package:chat_app/components/user_tile.dart';
import 'package:chat_app/services/auth_service/auth_service.dart';
import 'package:chat_app/services/chat_service/chat_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlockedUsersPage extends StatefulWidget {
  const BlockedUsersPage({super.key});

  @override
  State<BlockedUsersPage> createState() => _BlockedUsersPageState();
}

class _BlockedUsersPageState extends State<BlockedUsersPage> {
  final AuthService _authService = AuthService();
  final ChatService _chatService = ChatService();
  @override
  Widget build(BuildContext context) {
    final userID = _authService.currentUser!.uid;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.grey,
          elevation: 0,
          title: const Text(
            "B L O C K E D",
          ),
          centerTitle: true,
        ),
        body: StreamBuilder<List<Map<String, dynamic>>>(
          stream: _chatService.getBlockedUsersStream(userID),
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

            final blockUsers = snapshot.data ?? [];

            //no users
            if (blockUsers.isEmpty) {
              return const Center(
                child: Text("No blocked users"),
              );
            }

            //load complete
            return ListView.builder(
              itemCount: blockUsers.length,
              itemBuilder: (context, index) {
                final user = blockUsers[index];
                return UserTile(
                  text: user['email'],
                  onTap: () => _showUnblockBox(context, user['uid']),
                );
              },
            );
          },
        ));
  }

  void _showUnblockBox(BuildContext context, String userID) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Unblock User"),
        content: Text("Are you sure you want to unblock this user?"),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")),
          TextButton(
              onPressed: () {
                ChatService().unblockUser(userID);
                Navigator.pop(context);
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text("User Unblocked")));
              },
              child: Text("Unblock"))
        ],
      ),
    );
  }
}
