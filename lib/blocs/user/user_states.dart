// part of 'user_bloc.dart';

// sealed class UserStates {}

// final class InitialUserState extends UserStates{}

// final class LoadingUserState extends UserStates{}

// final class LoadedUserState extends UserStates{
//   User? user;

//   LoadedUserState(this.user);
// }

// final class ErrorUserState extends UserStates {
//   final String message;

//   ErrorUserState(this.message);
// }


part of 'user_bloc.dart';

sealed class UserStates {}

final class InitialUserState extends UserStates {}

final class LoadingUserState extends UserStates {}

final class LoadedUserState extends UserStates {
  final User user;

  LoadedUserState(this.user);
}

final class ErrorUserState extends UserStates {
  final String message;

  ErrorUserState(this.message);
}
