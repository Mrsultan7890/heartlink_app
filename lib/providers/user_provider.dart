import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../providers/auth_provider.dart';

final userProvider = Provider<UserModel?>((ref) {
  return ref.watch(authProvider).user;
});