import 'package:dio/dio.dart';
import 'package:recipe_app/core/network/dio_client.dart';
import 'package:recipe_app/data/models/user_model.dart';

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

}