import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:recipe_app/core/network/dio_client.dart';
import 'package:recipe_app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioUserService {
  final _dio = DioClient();

  Future<User?> getUserById(String userId) async {
    try {
      final response = await _dio.get(
        url: 'users/$userId.json',
      );

      print(response.data);

      if (response.data != null) {
        return User.fromJson(response.data, "user1");
      }
      return null;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUser(String userName, String email, String? fcmToken) async {
    try {
      final response = await _dio.add(
        url: "users.json",
        data: {
          "username": userName,
          "email": email,
          "fcmToken": fcmToken,
        },
      );

      final data = response.data;

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
        'userInfo',
        jsonEncode({
          "email": email,
          "username": userName,
          'id': data["name"],
        }),
      );

      print(prefs.getString('userInfo'));
    } catch (e) {
      rethrow;
    }
  }
}
