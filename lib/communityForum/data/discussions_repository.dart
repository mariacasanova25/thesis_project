import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:thesis_project/communityForum/domain/discussion.dart';

part 'discussions_repository.g.dart';

class DiscussionsRepository {
  const DiscussionsRepository({required this.firestore});

  final FirebaseFirestore firestore;

  Stream<List<Discussion>> watchDiscussions() {
    return FirebaseFirestore.instance
        .collection('discussions')
        .orderBy('createdAt', descending: false)
        .snapshots()
        .map(
          (snapshots) =>
              snapshots.docs.map((e) => Discussion.fromSnapshot(e)).toList(),
        );
  }
}

@riverpod
DiscussionsRepository discussionsRepository(DiscussionsRepositoryRef ref) {
  return DiscussionsRepository(firestore: FirebaseFirestore.instance);
}

@riverpod
Stream<List<Discussion>> watchDiscussions(WatchDiscussionsRef ref) {
  return ref.watch(discussionsRepositoryProvider).watchDiscussions();
}
