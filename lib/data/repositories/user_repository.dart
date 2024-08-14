import 'dart:io';

import 'package:recipe_app/data/services/user_service.dart';

import '../models/user_model.dart';

class UserRepository {
  final DioUserService _dioUserService;

  UserRepository({required DioUserService dioUserService})
      : _dioUserService = dioUserService;

  Future<User?> getUser(String id) async {
    return _dioUserService.getUserById(id);
  }

  Future<void> editUser({
    required String userId,
    String? username,
    File? profilePicture,
    String? bio,
  }) async {
    await _dioUserService.editUser(
      userId: userId,
      username: username,
      profilePicture: profilePicture,
      bio: bio,
    );
  }
}
