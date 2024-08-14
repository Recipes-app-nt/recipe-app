import 'package:dio/dio.dart';
import 'package:recipe_app/core/network/dio_client.dart';
import 'package:recipe_app/data/models/user_model.dart';

class DioUserService {
  final _dio = DioClient();

  Future<User?> getUserById(String userId) async {
    try {
      final response = await _dio.get(
        url: 'https://jaguar-c9cc8-default-rtdb.firebaseio.com/users/$userId',
      );

      if (response.data != null) {
        return User.fromJson(response.data, "user1");
      }
      return null;
    } on DioException catch (e) {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

}