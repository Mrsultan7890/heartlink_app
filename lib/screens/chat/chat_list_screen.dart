import 'package:flutter/material.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Messages')),
      body: const Center(child: Text('Chat List Screen')),
    );
  }
}

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