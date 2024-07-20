import 'package:flutter/material.dart';
import 'package:thesis_project/communityForum/model/discussion.dart';
import 'package:thesis_project/communityForum/discussion_details.dart';

class DiscussionsList extends StatelessWidget {
  const DiscussionsList({super.key, required this.discussions});
  final List<Discussion> discussions;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 6,
      ),
      itemCount: discussions.length,
      itemBuilder: (context, index) {
        var createdAt = discussions[index].createdAt.toDate();

        return Card(
          margin: const EdgeInsets.all(6),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
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
              'Criada em ${createdAt.day}/${createdAt.month}/${createdAt.year}',
              style: textTheme.bodySmall,
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 18,
            ),
          ),
        );
      },
    );
  }
}
