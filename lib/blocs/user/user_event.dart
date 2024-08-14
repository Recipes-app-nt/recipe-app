part of 'user_bloc.dart';

sealed class UserEvent {}

final class GetUserEvent extends UserEvent {}

final class EditUserEvent extends UserEvent {
  final String userId;
  final String? username;
  final File? profilePicture;
  final String? bio;

  EditUserEvent({
    required this.userId,
    this.username,
    this.profilePicture,
    this.bio,
  });
}