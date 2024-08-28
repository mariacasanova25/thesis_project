import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewDiscussion extends StatefulWidget {
  const NewDiscussion({super.key});

  @override
  State<NewDiscussion> createState() {
    return _NewMessageState();
  }
}

class _NewMessageState extends State<NewDiscussion> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitDiscussion() async {
    final enteredText = _textController.text;

    if (enteredText.trim().isEmpty) {
      return;
    }

    FocusScope.of(context).unfocus();
    _textController.clear();

    final user = FirebaseAuth.instance.currentUser!;

    FirebaseFirestore.instance.collection('discussions').add({
      'name': enteredText,
      'createdAt': Timestamp.now(),
      'userId': user.uid,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Nova discussão"),
        ),
        body: Padding(
          padding: const EdgeInsets.only(left: 15, right: 1, bottom: 14),
          child: Column(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                      labelText: 'Título da discussão... '),
                ),
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                      padding: const EdgeInsets.all(
                          16.0), // Add padding to avoid hitting the edge
                      child: ElevatedButton(
                        onPressed: _submitDiscussion,
                        style: ElevatedButton.styleFrom(
                            textStyle: const TextStyle(fontSize: 16)),
                        child: const Text("Adicionar"),
                      )))
            ],
          ),
        ));
  }
}
