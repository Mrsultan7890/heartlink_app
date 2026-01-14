import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';

class BlockedUsersScreen extends ConsumerStatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  ConsumerState<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends ConsumerState<BlockedUsersScreen> {
  List<Map<String, dynamic>> blockedUsers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBlockedUsers();
  }

  Future<void> _loadBlockedUsers() async {
    try {
      final response = await ApiService.instance.getBlockedUsers();
      setState(() {
        blockedUsers = List<Map<String, dynamic>>.from(response['blocked_users']);
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _unblockUser(String userId) async {
    try {
      await ApiService.instance.unblockUser(userId);
      setState(() => blockedUsers.removeWhere((u) => u['id'] == userId));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User unblocked')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to unblock: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blocked Users'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : blockedUsers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.block, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        'No blocked users',
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: blockedUsers.length,
                  itemBuilder: (context, index) {
                    final user = blockedUsers[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: (user['profile_images'] != null && 
                                         (user['profile_images'] as List).isNotEmpty)
                            ? NetworkImage(user['profile_images'][0] as String)
                            : null,
                        child: (user['profile_images'] == null || 
                               (user['profile_images'] as List).isEmpty)
                            ? const Icon(Icons.person)
                            : null,
                      ),
                      title: Text(user['name'] ?? 'Unknown'),
                      subtitle: Text('Blocked on ${user['blocked_at']}'),
                      trailing: TextButton(
                        onPressed: () => _unblockUser(user['id']),
                        child: const Text('Unblock'),
                      ),
                    );
                  },
                ),
    );
  }
}
