import 'package:flutter/material.dart';
import 'package:thesis_project/communityForum/new_discussion.dart';

class NewdiscussionButton extends StatelessWidget {
  const NewdiscussionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const NewDiscussion(),
          ),
        );
      },
      label: const Text("Discussão"),
      icon: const Icon(Icons.add),
    );
  }
}
