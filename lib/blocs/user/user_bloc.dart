import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:recipe_app/data/repositories/user_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/models/user_model.dart';

part 'user_event.dart';
part 'user_states.dart';

class UserBloc extends Bloc<UserEvent, UserStates> {
  final UserRepository _userRepository;

  UserBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(InitialUserState()) {
    on<GetUserEvent>(_getUser);
    on<EditUserEvent>(_editUser);
    on<UpdateUserFavoritesEvent>(_updateUserFavorites);
  }

  Future<void> _getUser(GetUserEvent event, Emitter<UserStates> emit) async {
    emit(LoadingUserState());

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = jsonDecode(prefs.getString('userData') ?? "");

      final user = await _userRepository.getUser(userData["email"]);
      if (user != null) {
        emit(LoadedUserState(user));
      } else {
        emit(ErrorUserState('User not found'));
      }
    } catch (e) {
      emit(ErrorUserState(e.toString()));
    }
  }

  void _editUser(EditUserEvent event, Emitter<UserStates> emit) async {
    emit(LoadingUserState());

    try {
      print("---------------------------------------------------------------");
      await _userRepository.editUser(
        email: event.email,
        username: event.username,
        profilePicture: event.profilePicture,
        bio: event.bio,
      );
      print("keldid ----------------------------------------");

      final updatedUser = await _userRepository.getUser(
        event.email,
      );
      print(updatedUser);
      emit(LoadedUserState(updatedUser!));
    } catch (e) {
      print(e);
      emit(ErrorUserState(e.toString()));
    }
  }

  Future<void> _updateUserFavorites(
      UpdateUserFavoritesEvent event, Emitter<UserStates> emit) async {
    if (state is LoadedUserState) {
      final currentUser = (state as LoadedUserState).user;
      List<String> updatedFavorites = List.from(currentUser.favoriteDishes);

      if (event.isFavoriteAdded) {
        if (!updatedFavorites.contains(event.recipeId)) {
          updatedFavorites.add(event.recipeId);
        }
      } else {
        updatedFavorites.remove(event.recipeId);
      }

      try {
        await _userRepository.updateUserFavorites(
            currentUser.id, updatedFavorites);
        emit(
          LoadedUserState(
            currentUser.copyWith(favoriteDishes: updatedFavorites),
          ),
        );
      } catch (e) {
        emit(ErrorUserState(e.toString()));
      }
    }
  }
}
