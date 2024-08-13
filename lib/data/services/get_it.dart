import 'package:auth_repository/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe_app/blocs/auth/auth_bloc.dart';
import 'package:recipe_app/blocs/category/category_bloc.dart';
import 'package:recipe_app/data/repositories/category_repository.dart';
import 'package:recipe_app/data/services/categories_service.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton(
    DioCategroiesService(),
  );
  getIt.registerSingleton(
    CategoryRepository(
      dioCategoryService: getIt.get<DioCategroiesService>(),
    ),
  );
  getIt.registerSingleton(
      CategoryBloc(categoryRepository: getIt.get<CategoryRepository>()));
}

void setUpAuth() {
  getIt.registerSingleton(AuthService());

  getIt.registerSingleton(AuthBloc(authService: getIt.get<AuthService>()));
}
