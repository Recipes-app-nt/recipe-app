import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/comment_model.dart';
import '../../data/repositories/social_functions_repositoyr.dart';

part 'social_function_event.dart';
part 'social_function_state.dart';

class SocialFunctionsBloc
    extends Bloc<SocialFunctionsEvent, SocialFunctionsState> {
  final SocialFunctionsRepository repository;

  SocialFunctionsBloc({required this.repository})
      : super(SocialFunctionsInitial()) {
    // on<AddCommentEvent>(_onAddComment);
    // on<AddLikeEvent>(_onAddLike);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  // Future<void> _onAddComment(
  //     AddCommentEvent event, Emitter<SocialFunctionsState> emit) async {
  //   emit(SocialFunctionsLoading());
  //   try {
  //     await repository.addComment(event.recipeId, event.comment);
  //     emit(SocialFunctionsSuccess());
  //   } catch (e) {
  //     emit(SocialFunctionsFailure(e.toString()));
  //   }
  // }

  // Future<void> _onAddLike(
  //     AddLikeEvent event, Emitter<SocialFunctionsState> emit) async {
  //   emit(SocialFunctionsLoading());
  //   try {
  //     await repository.addLike(event.recipeId, event.userId);
  //     emit(SocialFunctionsSuccess());
  //   } catch (e) {
  //     emit(SocialFunctionsFailure(e.toString()));
  //   }
  // }

  Future<void> _onAddFavorite(
      AddFavoriteEvent event, Emitter<SocialFunctionsState> emit) async {
    emit(SocialFunctionsLoading());
    try {
      await repository.addFavorite(event.recipeId, event.userId);
      emit(SocialFunctionsSuccess(isFavoriteAdded: true, recipeId: event.recipeId));
    } catch (e) {
      emit(SocialFunctionsFailure(e.toString()));
    }
  }

  Future<void> _onRemoveFavorite(
      RemoveFavoriteEvent event, Emitter<SocialFunctionsState> emit) async {
    emit(SocialFunctionsLoading());
    try {
      await repository.removeFavorite(event.recipeId, event.userId);
      emit(SocialFunctionsSuccess(
          isFavoriteAdded: false, recipeId: event.recipeId));

    } catch (e) {
      emit(SocialFunctionsFailure(e.toString()));
    }
  }
}
