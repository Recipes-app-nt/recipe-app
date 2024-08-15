/* import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/auth/auth_bloc.dart';
import 'package:recipe_app/data/services/get_it.dart';

import '../../../../blocs/user/user_bloc.dart';
import '../../../../data/models/user_model.dart';

class ProfileInfoWidget extends StatefulWidget {
  const ProfileInfoWidget({super.key});

  @override
  State<ProfileInfoWidget> createState() => _ProfileInfoWidgetState();
}

class _ProfileInfoWidgetState extends State<ProfileInfoWidget> {

  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserEvent());
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserStates>(
      builder: (context, state) {
        if (state is LoadingUserState) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (state is ErrorUserState) {
          return Center(
            child: Text(state.message),
          );
        }

        User? user;

        if (state is LoadedUserState) {
          user = state.user;
        }

        if (user == null) {
          return const Center(
            child: Text("User not found"),
          );
        }

        // print(user.favoriteDishes);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello ${user.username}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onDoubleTap: () {
                  print("Log out");
                  getIt.get<AuthBloc>().add(AuthLogout());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffFFCE80),
                  ),
                  child: Image.network(
                    user.profilePicture,
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset('assets/images/emoji.png');
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} */

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/auth/auth_bloc.dart';
import 'package:recipe_app/data/services/get_it.dart';

import '../../../../blocs/user/user_bloc.dart';
import '../../../../data/models/user_model.dart';
import 'shimmers/profile_widget_shimmer.dart';

class ProfileInfoWidget extends StatefulWidget {
  const ProfileInfoWidget({super.key});

  @override
  State<ProfileInfoWidget> createState() => _ProfileInfoWidgetState();
}

class _ProfileInfoWidgetState extends State<ProfileInfoWidget> {
  @override
  void initState() {
    super.initState();
    context.read<UserBloc>().add(GetUserEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserStates>(
      builder: (context, state) {
        if (state is LoadingUserState) {
          return const ProfileShimmer();
        }

        if (state is ErrorUserState) {
          return Center(
            child: Text(state.message),
          );
        }

        User? user;

        if (state is LoadedUserState) {
          user = state.user;
        }

        if (user == null) {
          return const Center(
            child: Text("User not found"),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello ${user.username}",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onDoubleTap: () {
                  print("Log out");
                  getIt.get<AuthBloc>().add(AuthLogout());
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xffFFCE80),
                  ),
                  child: Image.asset('assets/images/emoji.png'),
                  // child: Image.network(
                  //   user.profilePicture,
                  //   errorBuilder: (context, error, stackTrace) {
                  //     return Image.asset('assets/images/emoji.png');
                  //   },
                  // ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
