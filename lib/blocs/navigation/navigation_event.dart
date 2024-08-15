part of 'navigation_bloc.dart';

abstract class NavigationEvent extends Equatable {
  const NavigationEvent();

  @override
  List<Object> get props => [];
}

class AppStarted extends NavigationEvent {}

class PageTapped extends NavigationEvent {
  final int index;

  const PageTapped({required this.index});

  @override
  List<Object> get props => [index];
}
