import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/blocs/social_functions/social_function_bloc.dart';
import 'package:recipe_app/blocs/user/user_bloc.dart';
import 'package:recipe_app/blocs/video_player/video_bloc.dart';
import 'package:recipe_app/data/repositories/category_repository.dart';
import 'package:recipe_app/data/repositories/user_repository.dart';
import 'package:recipe_app/data/services/user_service.dart';
import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/ui/views/authentication/screens/splash_screen.dart';
import 'package:toastification/toastification.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/category/category_bloc.dart';
import '../data/services/get_it.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = RecipeRepository();
    final dioUserService = DioUserService();
    final userRepository = UserRepository(dioUserService: dioUserService);
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: getIt.get<CategoryRepository>(),
        ),
        RepositoryProvider(
          create: (context) => UserRepository(dioUserService: dioUserService),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getIt.get<CategoryBloc>(),
          ),
          BlocProvider.value(value: getIt.get<AuthBloc>()),
          BlocProvider(
            create: (context) => RecipeBloc(repository),
          ),
          BlocProvider(
            create: (context) => UserBloc(userRepository: userRepository),
          ),
          BlocProvider.value(
            value: getIt.get<SocialFunctionsBloc>(),
          ),
          BlocProvider(create: (context) => VideoBloc())
        ],
        child: const ToastificationWrapper(
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          ),
        ),
      ),
    );
  }
}
