import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/messageBubble.dart';
import 'package:flutter/material.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;

class MessageStream extends StatelessWidget {
  final ScrollController scrollController;
  final Function scrollToBottom;

  const MessageStream({
    super.key,
    required this.scrollController,
    required this.scrollToBottom,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final messages = snapshot.data!.docs;

          // Manual sort with null safety
          messages.sort((a, b) {
            final aTimestamp = (a.data() as Map<String, dynamic>)['timestamp'];
            final bTimestamp = (b.data() as Map<String, dynamic>)['timestamp'];

            if (aTimestamp == null && bTimestamp == null) return 0;
            if (aTimestamp == null) return -1;
            if (bTimestamp == null) return 1;

            return (aTimestamp as Timestamp).compareTo(bTimestamp as Timestamp);
          });

          List<MessageBubble> messageBubbles = [];
          for (var message in messages) {
            final messageData = message.data() as Map<String, dynamic>;
            final messageText = messageData['text'] ?? '';
            final messageSender = messageData['sender'] ?? 'Unknown';
            final currentUser = loggedInUser?.email;

            final messageBubble = MessageBubble(
              messageText: messageText,
              messageSender: messageSender,
              isMe: currentUser == messageSender,
            );
            messageBubbles.add(messageBubble);
          }

          // Scroll to bottom after frame build
          WidgetsBinding.instance.addPostFrameCallback((_) => scrollToBottom());

          return ListView(
            controller: scrollController,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageBubbles,
          );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
