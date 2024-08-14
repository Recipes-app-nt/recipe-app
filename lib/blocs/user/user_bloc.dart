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
  }

  void _getUser(GetUserEvent event, Emitter<UserStates> emit) async {
    emit(LoadingUserState());

    try {
      final user = await _userRepository.getUser("user1");
      emit(LoadedUserState(user));
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
      emit(LoadedUserState(updatedUser));
    } catch (e) {
      emit(ErrorUserState(e.toString()));
    }
  }

}
