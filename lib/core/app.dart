import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/data/repositories/category_repository.dart';
import 'package:recipe_app/ui/views/authentication/screens/login_screen.dart';
import 'package:recipe_app/ui/views/authentication/screens/splash_screen.dart';

import '../blocs/auth/auth_bloc.dart';
import '../blocs/category/category_bloc.dart';
import '../data/services/get_it.dart';
import '../ui/home/screens/home_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(
          value: getIt.get<CategoryRepository>(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(
            value: getIt.get<CategoryBloc>(),
          ),
          BlocProvider.value(value: getIt.get<AuthBloc>()),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: SplashScreen(),
        ),
      ),
    );
  }
}
