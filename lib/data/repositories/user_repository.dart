import 'dart:io';

import 'package:recipe_app/data/services/user_service.dart';
// import 'package:recipe_app/data/services/user_service.dart';

// import '../models/user_model.dart';

// class UserRepository {
//   final DioUserService _dioUserService;

//   UserRepository({required DioUserService dioUserService})
//       : _dioUserService = dioUserService;

//   Future<User?> getUser(String id) async {
//     return _dioUserService.getUserById(id);
//   }

// }

import '../models/user_model.dart';
import '../services/user_service.dart';

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
    Future<void> addUser(
        String userName, String email, String? fcmToken) async {
      await _dioUserService.addUser(userName, email, fcmToken);
    }

    Future<void> updateUserFavorites(
        String userId, List<String> favorites) async {
      await _dioUserService.updateUserFavorites(userId, favorites);
    }
  }
}
