import 'package:auth_repository/auth_repository.dart';
import 'package:get_it/get_it.dart';
import 'package:recipe_app/blocs/auth/auth_bloc.dart';
import 'package:recipe_app/blocs/category/category_bloc.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/blocs/social_functions/social_function_bloc.dart';
import 'package:recipe_app/data/repositories/category_repository.dart';
import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/data/repositories/social_functions_repositoyr.dart';
import 'package:recipe_app/data/services/categories_service.dart';
import 'package:recipe_app/data/services/recipe_service.dart';
import 'package:recipe_app/data/services/socail_functions_service.dart';

final getIt = GetIt.instance;

void setUp() {
  getIt.registerSingleton(
    DioCategoryService(),
  );
  getIt.registerSingleton(
    CategoryRepository(
      dioCategoryService: getIt.get<DioCategoryService>(),
    ),
  );
  getIt.registerSingleton(
    CategoryBloc(
      categoryRepository: getIt.get<CategoryRepository>(),
    ),
  );
  getIt.registerSingleton(
    RecipeService(),
  );
  getIt.registerSingleton(
    RecipeRepository(),
  );
  getIt.registerSingleton(
    RecipeBloc(
      getIt.get<RecipeRepository>(),
    ),
  );

  getIt.registerSingleton(
    SocailFunctionsService(),
  );

  getIt.registerSingleton(
    SocialFunctionsRepository(
      socialFunctionsService: getIt.get<SocailFunctionsService>(),
    ),
  );

  getIt.registerSingleton(
    SocialFunctionsBloc(
      repository: getIt.get<SocialFunctionsRepository>(),
      recipeBloc: getIt.get<RecipeBloc>(),
    ),
  );
}

void setUpAuth() {
  getIt.registerSingleton(AuthService());

  getIt.registerSingleton(AuthBloc(authService: getIt.get<AuthService>()));
}
