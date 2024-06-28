import 'package:flutter/material.dart';
import 'package:thesis_project/communityForum/community_forum.dart';

class SendMessageButton extends StatelessWidget {
  const SendMessageButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          children: [
            const Text('Continua com dúvidas?'),
            Padding(
                padding: const EdgeInsets.all(
                    16.0), // Add padding to avoid hitting the edge
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.messenger_outline),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CommunityForumScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 16)),
                  label: const Text("Enviar Mensagem"),
                ))
          ],
        ));
  }
}
