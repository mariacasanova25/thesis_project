import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:thesis_project/widgets/new_message.dart';
import 'package:thesis_project/widgets/message_bubble.dart';

class DiscussionDetailsScreen extends StatelessWidget {
  const DiscussionDetailsScreen({super.key, required this.discussion});

  final String discussion;

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: Text(discussion),
      ),
      body: Column(children: [
        Expanded(
          child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection(discussion)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No messages found.'),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(
                    child: Text('Something went wrong'),
                  );
                }
                final loadedMessages = snapshot.data!.docs;

                return ListView.builder(
                    padding: const EdgeInsets.only(
                      bottom: 40,
                      left: 13,
                      right: 13,
                    ),
                    reverse: true,
                    itemCount: loadedMessages.length,
                    itemBuilder: (context, index) {
                      final discussionMessage = loadedMessages[index].data();
                      final nextDiscussionMessage =
                          index + 1 < loadedMessages.length
                              ? loadedMessages[index + 1].data()
                              : null;
                      final currentMessageUserId = discussionMessage['userId'];
                      final nextMessageUserId = nextDiscussionMessage != null
                          ? nextDiscussionMessage['userId']
                          : null;

                      final nextUserIsSame =
                          nextMessageUserId == currentMessageUserId;

                      if (nextUserIsSame) {
                        return MessageBubble.next(
                            message: discussionMessage['text'],
                            isMe:
                                authenticatedUser.uid == currentMessageUserId);
                      } else {
                        return MessageBubble.first(
                            username: discussionMessage['username'],
                            role: discussionMessage['role'],
                            message: discussionMessage['text'],
                            isMe:
                                authenticatedUser.uid == currentMessageUserId);
                      }
                    });
              }),
        ),
        NewMessage(discussion: discussion)
      ]),
    );
  }
}
