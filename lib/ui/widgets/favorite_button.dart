import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/social_functions/social_function_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../data/models/user_model.dart';

class FavoriteButton extends StatefulWidget {
  final String favoriteRecipeId;
  const FavoriteButton({
    super.key,
    required this.favoriteRecipeId,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
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
                  title: socialState.isFavoriteAdded
                      ? "Malumot qo'shildi!"
                      : "Malumot olindi!",
                  message: socialState.isFavoriteAdded
                      ? 'Retsept Sevimlilarga muaffaqiyatli saqlandi!'
                      : 'Retsept Sevimlilardan olib tashlandi!',
                  contentType: socialState.isFavoriteAdded
                      ? ContentType.success
                      : ContentType.warning,
                ),
              );

              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(snackBar);

                // Update UserBloc state
              context.read<UserBloc>().add(UpdateUserFavoritesEvent(
                    recipeId: socialState.recipeId,
                    isFavoriteAdded: socialState.isFavoriteAdded,
                  ));
            }
          },
          builder: (context, socialState) {
            bool isFavorite =
                user!.favoriteDishes.contains(widget.favoriteRecipeId);

            return InkWell(
              onTap: () {
                if (isFavorite) {
                  context.read<SocialFunctionsBloc>().add(
                        RemoveFavoriteEvent(widget.favoriteRecipeId, user!.id),
                      );
                } else {
                  context.read<SocialFunctionsBloc>().add(
                        AddFavoriteEvent(widget.favoriteRecipeId, user!.id),
                      );
                }
              },
              splashColor: Colors.blue.withOpacity(0.9),
              highlightColor: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Image.asset(
                  'assets/icons/bookmark.png',
                  width: 16,
                  color: isFavorite ? const Color(0xff71B1A1) : null,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
