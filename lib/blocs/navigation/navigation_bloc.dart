import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'navigation_event.dart';
part 'navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(HomePage()) {
    on<AppStarted>((event, emit) {
      emit(HomePage());
    });

    on<PageTapped>((event, emit) {
      switch (event.index) {
        case 0:
          emit(HomePage());
          break;
        case 1:
          emit(FavoritePage());
          break;
        case 2:
          emit(NotificationPage());
          break;
        case 3:
          emit(ProfilePage());
          break;
      }
    });
  }
}
