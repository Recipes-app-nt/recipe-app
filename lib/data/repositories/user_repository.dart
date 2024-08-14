import 'package:recipe_app/data/services/user_service.dart';

import '../models/user_model.dart';

class UserRepository {
  final DioUserService _dioUserService;

  UserRepository({required DioUserService dioUserService})
      : _dioUserService = dioUserService;

  Future<User?> getUser(String id) async {
    return _dioUserService.getUserById(id);
  }
}
