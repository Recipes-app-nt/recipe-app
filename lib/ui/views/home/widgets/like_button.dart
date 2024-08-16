/* import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/social_functions/social_function_bloc.dart';
import '../../../../blocs/user/user_bloc.dart';
import '../../../../data/models/user_model.dart';

class LikeButton extends StatefulWidget {
  final String likeRecipeId;
  final List<String> likes;
  const LikeButton({
    super.key,
    required this.likeRecipeId,
    required this.likes,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {

  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.likes.contains(user?.id);
  }
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserStates>(
      builder: (context, state) {
        if (state is LoadingUserState) {
          return const CircularProgressIndicator();
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
            child: Text("Error: User not loaded"),
          );
        }

        return BlocConsumer<SocialFunctionsBloc, SocialFunctionsState>(
          listener: (context, socialState) {
            if (socialState is SocialFunctionsSuccess) {
              final snackBar = SnackBar(
                elevation: 0,
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: socialState.isLikeAdded!
                      ? "Malumot qo'shildi!"
                      : "Malumot olindi!",
                  message:
                      socialState.isLikeAdded! ? 'saqlandi!' : 'tashlandi!',
                  contentType: socialState.isLikeAdded!
                      ? ContentType.success
                      : ContentType.warning,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);
            }
          },
          builder: (context, socialState) {
            // bool isLike = widget.likes.contains(user!.id);
            // print(widget.likes);
            // print(isLike);

            return InkWell(
              onTap: () {
                if (isLike) {
                  // print(user!.id);
                  context.read<SocialFunctionsBloc>().add(
                        RemoveLikeEvent(widget.likeRecipeId, user!.id),
                      );
                } else {
                  // print(user!.id);

                  context.read<SocialFunctionsBloc>().add(
                        AddLikeEvent(widget.likeRecipeId, user!.id),
                      );
                }
              },
              splashColor: Colors.blue.withOpacity(0.9),
              highlightColor: Colors.transparent,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: isLike
                    ? const Icon(
                        Icons.favorite,
                        size: 20,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border,
                        size: 20,
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
 */

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../blocs/social_functions/social_function_bloc.dart';
import '../../../../blocs/user/user_bloc.dart';
import '../../../../data/models/user_model.dart';

class LikeButton extends StatefulWidget {
  final String likeRecipeId;
  final List<String> likes;
  const LikeButton({
    super.key,
    required this.likeRecipeId,
    required this.likes,
  });

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserStates>(
      builder: (context, state) {
        if (state is LoadingUserState) {
          return const CircularProgressIndicator();
        }

        if (state is ErrorUserState) {
          return Center(
            child: Text(state.message),
          );
        }

        User? user;

        if (state is LoadedUserState) {
          user = state.user;
          _isLiked = widget.likes.contains(user.id);
        }

        if (user == null) {
          return const Center(
            child: Text("Error: User not loaded"),
          );
        }

        return BlocConsumer<SocialFunctionsBloc, SocialFunctionsState>(
          listener: (context, socialState) {
            if (socialState is SocialFunctionsSuccess) {
              final snackBar = SnackBar(
                elevation: 0,
                duration: const Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.transparent,
                content: AwesomeSnackbarContent(
                  title: socialState.isLikeAdded!
                      ? "Malumot qo'shildi!"
                      : "Malumot olindi!",
                  message:
                      socialState.isLikeAdded! ? 'saqlandi!' : 'tashlandi!',
                  contentType: socialState.isLikeAdded!
                      ? ContentType.success
                      : ContentType.warning,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);

              setState(() {
                _isLiked = socialState.isLikeAdded!;
              });
            } else if (socialState is SocialFunctionsFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(socialState.error)),
              );
            }
          },
          builder: (context, socialState) {
            return InkWell(
              onTap: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
                if (_isLiked) {
                  context.read<SocialFunctionsBloc>().add(
                        AddLikeEvent(widget.likeRecipeId, user!.id),
                      );
                } else {
                  context.read<SocialFunctionsBloc>().add(
                        RemoveLikeEvent(widget.likeRecipeId, user!.id),
                      );
                }
              },
              splashColor: Colors.blue.withOpacity(0.9),
              highlightColor: Colors.transparent,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: _isLiked
                    ? const Icon(
                        Icons.favorite,
                        size: 20,
                        color: Colors.red,
                      )
                    : const Icon(
                        Icons.favorite_border,
                        size: 20,
                      ),
              ),
            );
          },
        );
      },
    );
  }
}
