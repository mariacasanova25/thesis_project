import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thesis_project/repositories/messages_repository.dart';
import 'package:thesis_project/widgets/new_message.dart';
import 'package:thesis_project/widgets/message_bubble.dart';

class DiscussionDetailsScreen extends ConsumerWidget {
  const DiscussionDetailsScreen(
      {super.key, required this.discussionName, required this.discussionId});

  final String discussionName;
  final String discussionId;

  Future<Map<String, dynamic>?> getUserData() async {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(authenticatedUser.uid)
        .get();
    return userData.data();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    final messagesAsync = ref.watch(watchMessagesProvider(discussionId));
    return Scaffold(
      appBar: AppBar(
        title: Text(discussionName),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: getUserData(),
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (userSnapshot.hasError) {
            return const Center(child: Text('Error loading user data'));
          } else if (!userSnapshot.hasData || userSnapshot.data == null) {
            return const Center(child: Text('User data not found'));
          } else {
            final userData = userSnapshot.data!;
            final username = userData['username'];
            final role = userData['role'];

            return Column(
              children: [
                Expanded(
                    child: messagesAsync.when(
                        data: (messages) {
                          if (messages.isEmpty) {
                            return const Center(
                              child: Text('No messages found.'),
                            );
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.only(
                              bottom: 40,
                              left: 13,
                              right: 13,
                            ),
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) {
                              final discussionMessage = messages[index];
                              final nextDiscussionMessage =
                                  index + 1 < messages.length
                                      ? messages[index + 1]
                                      : null;
                              final currentMessageUserId =
                                  discussionMessage.userId;
                              final nextMessageUserId =
                                  nextDiscussionMessage != null
                                      ? nextDiscussionMessage.userId
                                      : '';

                              final nextUserIsSame =
                                  nextMessageUserId == currentMessageUserId;

                              if (nextUserIsSame) {
                                return MessageBubble.next(
                                  message: discussionMessage.text,
                                  isMe: authenticatedUser.uid ==
                                      currentMessageUserId,
                                );
                              } else {
                                return MessageBubble.first(
                                  username: username,
                                  role: role,
                                  message: discussionMessage.text,
                                  isMe: authenticatedUser.uid ==
                                      currentMessageUserId,
                                );
                              }
                            },
                          );
                        },
                        error: (error, stackTrace) {
                          return const SizedBox(
                            width: 10,
                          );
                        },
                        loading: () =>
                            const Center(child: CircularProgressIndicator()))),
                NewMessage(discussion: discussionId),
              ],
            );
          }
        },
      ),
    );
  }
}
