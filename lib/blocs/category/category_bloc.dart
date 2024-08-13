import 'package:bloc/bloc.dart';
import 'package:recipe_app/data/models/category_model.dart';

import '../../data/repositories/category_repository.dart';
part 'category_state.dart';
part 'category_event.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;

  CategoryBloc({required this.categoryRepository}) : super(CategoryState()) {
    on<GetCategory>(_onGetCategory);
  }

  Future<void> _onGetCategory(
      GetCategory event, Emitter<CategoryState> emit) async {
    emit(state.copyWith(isloading: true));

    try {
      final category = await categoryRepository.getCategory();
      emit(state.copyWith(category: category, isloading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), isloading: false));
    }
  }
}
