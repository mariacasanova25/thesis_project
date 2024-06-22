import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:thesis_project/models/user.dart';

part 'user_repository.g.dart';

class UserRepository {
  const UserRepository({required this.firestore});

  final FirebaseFirestore firestore;

  Stream<UserData> watchUser(String userId) {
    return firestore.collection('users').doc(userId).snapshots().map(
          (snapshot) => UserData.fromSnapshot(snapshot),
        );
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  return UserRepository(firestore: FirebaseFirestore.instance);
}

@riverpod
Stream<UserData> watchUser(WatchUserRef ref) {
  final user = FirebaseAuth.instance.currentUser!;
  return ref.watch(userRepositoryProvider).watchUser(user.uid);
}
