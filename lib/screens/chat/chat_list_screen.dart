import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../utils/app_theme.dart';
import '../../utils/app_router.dart';
import '../matches/matches_screen.dart';

class ChatListScreen extends ConsumerStatefulWidget {
  const ChatListScreen({super.key});

  @override
  ConsumerState<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends ConsumerState<ChatListScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(matchesProvider.notifier).loadMatches());
  }

  @override
  Widget build(BuildContext context) {
    final matchesState = ref.watch(matchesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: matchesState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : matchesState.matches.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => ref.read(matchesProvider.notifier).loadMatches(),
                  child: ListView.builder(
                    itemCount: matchesState.matches.length,
                    itemBuilder: (context, index) {
                      final match = matchesState.matches[index];
                      return _buildChatTile(match);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 100,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 24),
          Text(
            'No conversations yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start matching to begin chatting!',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatTile(dynamic match) {
    final dynamic otherUser = match.user2Profile ?? match.user1Profile;
    final bool hasImages = otherUser.profileImages?.isNotEmpty ?? false;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: hasImages
            ? CachedNetworkImageProvider(otherUser.profileImages.first) as ImageProvider
            : null,
        child: !hasImages ? const Icon(Icons.person) : null,
      ),
      title: Text(otherUser.name as String),
      subtitle: Text(
        (match.lastMessage as String?) ?? 'Start a conversation',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: AppTheme.textSecondary),
      ),
      trailing: match.lastMessageTime != null
          ? Text(
              timeago.format(DateTime.parse(match.lastMessageTime as String)),
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 12,
              ),
            )
          : null,
      onTap: () => context.push(
        '${AppRoutes.chat}/${match.id}?name=${otherUser.name}',
      ),
    );
  }
}