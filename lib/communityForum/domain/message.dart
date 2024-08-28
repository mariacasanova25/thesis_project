import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  const Message(
      {required this.createdAt,
      required this.text,
      required this.userId,
      required this.messageId});

  final String text;
  final String userId;
  final DateTime createdAt;
  final String messageId;

  factory Message.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return Message(
        text: data['text'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
        userId: data['userId'],
        messageId: snapshot.id);
  }
}
