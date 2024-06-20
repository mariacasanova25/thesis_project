import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:thesis_project/models/message.dart';

part 'messages_repository.g.dart';

class MessagesRepository {
  const MessagesRepository({required this.firestore});

  final FirebaseFirestore firestore;

  Stream<List<Message>> watchMessages(String discussionId) {
    return firestore
        .collection('discussions')
        .doc(discussionId)
        .collection('messages')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromSnapshot(doc)).toList());
  }
}

@riverpod
MessagesRepository messagesRepository(MessagesRepositoryRef ref) {
  return MessagesRepository(firestore: FirebaseFirestore.instance);
}

@riverpod
Stream<List<Message>> watchMessages(WatchMessagesRef ref, String discussionId) {
  return ref.watch(messagesRepositoryProvider).watchMessages(discussionId);
}
