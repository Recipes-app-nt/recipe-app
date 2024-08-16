part of 'navigation_bloc.dart';

abstract class NavigationState extends Equatable {
  const NavigationState();

  @override
  List<Object> get props => [];
}

class HomePage extends NavigationState {}

class FavoritePage extends NavigationState {}

class NotificationPage extends NavigationState {}

class ProfilePage extends NavigationState {}
