import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_app/blocs/category/category_bloc.dart';
import 'package:recipe_app/data/models/category_model.dart';
import 'package:recipe_app/data/repositories/category_repository.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

void main() {
  late MockCategoryRepository mockCategoryRepository;
  late CategoryBloc categoryBloc;

  setUp(() {
    mockCategoryRepository = MockCategoryRepository();
    categoryBloc = CategoryBloc(categoryRepository: mockCategoryRepository);
  });

  test('initial state is CategoryState()', () {
    expect(categoryBloc.state, equals(CategoryState()));
  });

  blocTest<CategoryBloc, CategoryState>(
    'emits [isLoading, category] when GetCategory is added and repository returns data',
    build: () {
      when(mockCategoryRepository.getCategory()).thenAnswer(
        (_) async => [
          CategoriesModel(
            id: "1",
            name: 'Category 1',
            categoryId: "",
          ),
        ],
      );
      return categoryBloc;
    },
    act: (bloc) => bloc.add(GetCategory()),
    expect: () => [
      CategoryState(isLoading: true),
      CategoryState(category: [
        CategoriesModel(
          id: "",
          name: 'Category 1',
          categoryId: "",
        ),
      ], isLoading: false),
    ],
  );

  blocTest<CategoryBloc, CategoryState>(
    'emits [isLoading, errorMessage] when GetCategory is added and repository throws an error',
    build: () {
      when(mockCategoryRepository.getCategory())
          .thenThrow(Exception('Failed to load category'));
      return categoryBloc;
    },
    act: (bloc) => bloc.add(GetCategory()),
    expect: () => [
      CategoryState(isLoading: true),
      CategoryState(
        errorMessage: 'Exception: Failed to load category',
        isLoading: false,
      ),
    ],
  );
}
