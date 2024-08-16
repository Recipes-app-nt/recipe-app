import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:recipe_app/core/network/dio_client.dart';
import 'package:recipe_app/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as path;

class DioUserService {
  final _dio = DioClient();
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<User?> getUserById(String email) async {
    try {
      final response = await _dio.get(
        url: 'users.json',
      );
      final Map<String, dynamic> mapData = response.data;

      for (final key in mapData.keys) {
        final value = mapData[key];
        if (value['email'] == email) {
          value['id'] = key;
          return User.fromJson(
            value,
          );
        }
      }

      return null;
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addUser(
      String userName, String email, String? fcmToken, String uuid) async {
    try {
      final response = await _dio.add(
        url: "users.json",
        data: {
          "username": userName,
          "email": email,
          "favoriteDishes": [],
          "fcmToken": fcmToken,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editUser({
    required String email,
    String? username,
    File? profilePicture,
    String? bio,
  }) async {
    // try {
    Map<String, dynamic> updatedData = {};

    if (username != null) updatedData['username'] = username;
    if (bio != null) updatedData['bio'] = bio;

    if (profilePicture != null) {
      // Upload the image to Firebase Storage
      String fileName = path.basename(profilePicture.path);
      print("----------------------------");
      print(fileName);
      print("----------------------------");

      Reference storageRef = _storage.ref().child('profile_pictures/$fileName');

      UploadTask uploadTask = storageRef.putFile(profilePicture);
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      updatedData['profile_picture'] = downloadUrl;
    }
    User? user = await getUserById(email);

    final response = await _dio.update(
      url: 'users/${user!.id}.json',
      data: updatedData,
    );

    // if (response.data != null) {
    //   final prefs = await SharedPreferences.getInstance();
    //   final userInfo = jsonDecode(prefs.getString('userInfo') ?? "");
    //   userInfo.addAll(updatedData);
    //   await prefs.setString('userInfo', jsonEncode(userInfo));

    //   print('User updated: ${response.data}');
    // }
  }

  Future<void> updateUserFavorites(
      String userId, List<String> favorites) async {
    try {
      await _dio.update(
        url: 'users/$userId.json',
        data: {'favoriteDishes': favorites},
      );

      final prefs = await SharedPreferences.getInstance();
      final userInfo = jsonDecode(prefs.getString("userInfo") ?? "{}");
      userInfo['favoriteDishes'] = favorites;
      await prefs.setString('userInfo', jsonEncode(userInfo));
    } on DioException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }
}
