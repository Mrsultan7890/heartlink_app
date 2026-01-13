import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final int matchId;
  final String matchName;

  const ChatScreen({super.key, required this.matchId, required this.matchName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(matchName)),
      body: Center(child: Text('Chat with $matchName')),
    );
  }
}