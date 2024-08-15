import 'package:dio/dio.dart';

import '../../core/network/dio_client.dart';
import '../models/category_model.dart';

class DioCategoryService {
  final _dioClient = DioClient();
  Future<List<CategoriesModel>> getCategories() async {
    try {
      final response = await _dioClient.get(url: "/categories.json");

      Map<String, dynamic> data = response.data;

      List<CategoriesModel> loadedData = [];
      data.forEach((key, value) {
        value['id'] = key;
        value['categoryId'] = key;
        loadedData.add(CategoriesModel.fromJson(value));
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

  Future<CategoriesModel> addCategories(String name) async {
    try {
      Map<String, dynamic> categoryData = {
        'name': name,
      };

      final response =
          await _dioClient.add(url: "/categories.json", data: categoryData);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to add category');
      }

      print("Category ID: $response");

      final data = response.data;
      categoryData['id'] = data['name'];
      categoryData['categoryId'] = data['name'];
      // print(data);

      CategoriesModel categoriesModel = CategoriesModel.fromJson(categoryData);
      return categoriesModel;
    } on DioException catch (e) {
      print("Dio category added error: $e");
      rethrow;
    } catch (e) {
      print("Category added catch error: $e");
      rethrow;
    }
  }

  Future<Response> deleteCategories(String id) async {
    try {
      final response = await _dioClient.delete(url: "/categories/$id.json");
      return response;
    } catch (e) {
      rethrow;
    }
  }
}

// void main(List<String> args) async {
//   DioCategoryService dioCategoryService = DioCategoryService();
//   final res = await dioCategoryService.getCategories();

//   for (var i in res) {
//     print(i.categoryId);
//     print(i.name);
//   }
// }
