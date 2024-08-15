import 'dart:convert';
import 'dart:developer';
import 'package:auth_repository/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String apiKey = 'AIzaSyBUQzviZANpeTc2dtACHPdDlPtVxX1NJF4';
  final dio = Dio();
  Future<User> _authenticate(
      String email, String password, String query) async {
    try {
      final response = await dio.post(
        "https://identitytoolkit.googleapis.com/v1/accounts:$query?key=$apiKey",
        data: {
          "email": email,
          "password": password,
          "returnSecureToken": true,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final user = User.fromMap(data);
        _saveUserData(user);

        return user;
      }
      throw response.data['error']['message'];
    } on DioException {
      rethrow;
    } catch (e) {
      print("Error:  $e");

      rethrow;
    }
  }

  Future<User> register(String email, String password) async {
    return await _authenticate(email, password, "signUp");
  }

  Future<User> signIn(String email, String password) async {
    return await _authenticate(email, password, "signInWithPassword");
  }

  Future<void> logout() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('userData');
  }

  Future<void> resetPassword(String email) async {
    final response = await dio.post(
      "https://identitytoolkit.googleapis.com/v1/accounts:sendOobCode?key=$apiKey",
      data: {
        "requestType": "PASSWORD_RESET",
        "email": email,
      },
    );
    print(response.data);
    // response.data;
  }

  Future<User?> checkTokenExpiry() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final userData = sharedPreferences.getString("userData");
    if (userData == null) {
      return null;
    }

    final user = jsonDecode(userData);

    if (DateTime.now().isBefore(
      DateTime.parse(
        user['expiresIn'],
      ),
    )) {
      return User(
        localId: user['localId'],
        email: user['email'],
        idToken: user['idToken'],
        refreshToken: user['refreshToken'],
        expiresIn: DateTime.parse(
          user['expiresIn'],
        ),
      );
    }

    return null;
  }

  Future<void> _saveUserData(User user) async {
    final sharedPreferences = await SharedPreferences.getInstance();

    sharedPreferences.setString(
      'userData',
      jsonEncode(
        user.toMap(),
      ),
    );
    final data = jsonDecode(sharedPreferences.getString("userData")!);
    print(sharedPreferences.getString('userData'));
  }
}
