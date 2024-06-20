import 'package:flutter/material.dart';
import 'package:thesis_project/models/discussion.dart';
import 'package:thesis_project/screens/discussion_details.dart';

class DiscussionsList extends StatelessWidget {
  const DiscussionsList({super.key, required this.discussions});
  final List<Discussion> discussions;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: discussions.length,
      itemBuilder: (context, index) {
        var createdAt = discussions[index].createdAt.toDate();

        return ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DiscussionDetailsScreen(
                  discussionName: discussions[index].name,
                  discussionId: discussions[index].discussionId,
                ),
              ),
            );
          },
          title: Text(
            discussions[index].name,
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
  }
}
