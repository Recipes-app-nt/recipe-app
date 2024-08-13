import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../models/category_model.dart';

class DioCategroiesService {
  final _dioClient = DioClient();

  Future<List<Category>> getCategories() async {
    try {
      final response = await _dioClient.get(url: "/categories.json");

      Map<String, dynamic> data = response.data;

     
      List<Category> loadedData = [];
      data.forEach((key, value) {
        value['id'] = key;
        value['categoryId'] = key;
        loadedData.add(Category.fromJson(value));
      });


      return loadedData;
    } on DioException catch (e) {
      print("Service Dio error: $e");
      rethrow;
    } catch (e) {
      print("Category catch Erro: $e");
      rethrow;
    }
  }
}

// void main(List<String> args) async {
//   DioCategroiesService dioCategroiesService = DioCategroiesService();

//   final res = await dioCategroiesService.getCategories();
//   print(res[0].name);
// }
