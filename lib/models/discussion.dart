import 'package:cloud_firestore/cloud_firestore.dart';

class Discussion {
  Discussion(
      {required this.name,
      required this.createdAt,
      required this.userId,
      required this.discussionId});

  final String name;
  final Timestamp createdAt;
  final String userId;

  final String discussionId;

  factory Discussion.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;

    return Discussion(
        name: data['name'],
        createdAt: data['createdAt'],
        userId: data['userId'],
        discussionId: snapshot.id);
  }
}
