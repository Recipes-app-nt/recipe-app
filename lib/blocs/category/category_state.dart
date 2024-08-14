part of 'category_bloc.dart';

final class CategoryState {
  List<CategoriesModel>? category;
  String? errorMessage;
  bool isLoading;

  CategoryState({
    this.category,
    this.errorMessage,
    this.isLoading = false,
  });

  CategoryState copyWith({
    List<CategoriesModel>? category,
    String? errorMessage,
    bool? isloading,
  }) {
    return CategoryState(
      category: category ?? this.category,
      errorMessage: errorMessage ?? this.errorMessage,
      isLoading: isLoading,
    );
  }
}
