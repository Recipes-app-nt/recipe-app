// import 'package:bloc/bloc.dart';
// import 'package:recipe_app/data/repositories/user_repository.dart';

// import '../../data/models/user_model.dart';

// part 'user_event.dart';

// part 'user_states.dart';

// class UserBloc extends Bloc<UserEvent, UserStates> {
//   final UserRepository _userRepository;

//   UserBloc({required UserRepository userRepository})
//       : _userRepository = userRepository,
//         super(InitialUserState()) {
//     on<GetUserEvent>(_getUser);
//   }

//   void _getUser(GetUserEvent event, Emitter<UserStates> emit) async {
//     emit(LoadingUserState());

//     try {
//       final user = await _userRepository.getUser("-O4Hr7UWzyIbfWNfdmA6");
//       emit(LoadedUserState(user));
//     } catch (e) {
//       emit(ErrorUserState(e.toString()));
//     }
//   }
// }

import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:recipe_app/data/repositories/user_repository.dart';

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
      final user = await _userRepository.getUser("-O4Hr7UWzyIbfWNfdmA6");
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
      await _userRepository.editUser(
        userId: event.userId,
        username: event.username,
        profilePicture: event.profilePicture,
        bio: event.bio,
      );

      final updatedUser = await _userRepository.getUser(event.userId);
      emit(LoadedUserState(updatedUser!));
    } catch (e) {
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
        emit(LoadedUserState(
            currentUser.copyWith(favoriteDishes: updatedFavorites),),);
      } catch (e) {
        emit(ErrorUserState(e.toString()));
      }
    }
  }
}
