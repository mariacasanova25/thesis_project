import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:thesis_project/screens/discussion_details.dart';
import 'package:thesis_project/widgets/new_discussion.dart';

class CommunityForumScreen extends StatelessWidget {
  const CommunityForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('discussions')
            .orderBy('createdAt', descending: false)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No discussions found.'),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong'),
            );
          }
          final loadedMessages = snapshot.data!.docs;

          return ListView.builder(
            itemCount: loadedMessages.length,
            itemBuilder: (context, index) {
              var createdAt =
                  loadedMessages[index].data()['createdAt'].toDate();

              return ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DiscussionDetailsScreen(
                          discussion: loadedMessages[index].data()['name']),
                    ),
                  );
                },
                title: Text(
                  loadedMessages[index].data()['name'],
                ),
                subtitle: Text(
                  'Criada em ${createdAt.day}-${createdAt.month}-${createdAt.year}',
                ),
                leading: Container(
                  //square
                  width: 48,
                  height: 48,
                  color: Colors.purple,
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  size: 18,
                ),
              );
            },
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewDiscussion(),
            ),
          );
        },
        child: const Text("Nova Discussão"),
      ),
    );
  }
}
