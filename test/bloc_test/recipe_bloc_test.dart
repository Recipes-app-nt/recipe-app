import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/data/repositories/recipe_repository.dart';
import 'package:recipe_app/data/models/recipe_model.dart';

class MockRecipeRepository extends Mock implements RecipeRepository {}

void main() {
  late RecipeBloc recipeBloc;
  late MockRecipeRepository mockRepository;

  setUp(() {
    mockRepository = MockRecipeRepository();
    recipeBloc = RecipeBloc(mockRepository);
  });
  setUpAll(() {
    registerFallbackValue(Recipe(
      id: 'dummy_id',
      title: 'Dummy Recipe',
      ingredients: ['Dummy Ingredient'],
      instructions: ['Dummy Instruction'],
      cookingTime: '0 minutes',
      imageUrl: 'http://example.com/dummy.jpg',
      videoUrl: 'http://example.com/dummy.mp4',
      category: 'Dummy Category',
      authorId: 'dummy_author',
      likes: [],
      comments: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rating: 0.0,
    ));
  });

  tearDown(() {
    recipeBloc.close();
  });

  group('RecipeBloc', () {
    final testRecipes = [
      Recipe(
        id: '1',
        title: 'Test Recipe 1',
        ingredients: ['Ingredient 1', 'Ingredient 2'],
        instructions: ['Step 1', 'Step 2'],
        cookingTime: '30 minutes',
        imageUrl: 'http://example.com/image1.jpg',
        videoUrl: 'http://example.com/video1.mp4',
        category: 'Main Course',
        authorId: 'user1',
        likes: ['user2', 'user3'],
        comments: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rating: 4.5,
      ),
      Recipe(
        id: '2',
        title: 'Test Recipe 2',
        ingredients: ['Ingredient 3', 'Ingredient 4'],
        instructions: ['Step 1', 'Step 2', 'Step 3'],
        cookingTime: '45 minutes',
        imageUrl: 'http://example.com/image2.jpg',
        videoUrl: 'http://example.com/video2.mp4',
        category: 'Dessert',
        authorId: 'user2',
        likes: ['user1'],
        comments: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        rating: 4.0,
      ),
    ];

    test('initial state is RecipeLoading', () {
      expect(recipeBloc.state, equals(RecipeLoading()));
    });

    blocTest<RecipeBloc, RecipeState>(
      'emits [RecipeLoading, RecipeLoaded] when LoadRecipes is added successfully',
      build: () {
        when(() => mockRepository.getAllRecipes())
            .thenAnswer((_) async => testRecipes);
        return recipeBloc;
      },
      act: (bloc) => bloc.add(LoadRecipes()),
      expect: () => [
        RecipeLoading(),
        RecipeLoaded(testRecipes),
      ],
    );

    blocTest<RecipeBloc, RecipeState>(
      'emits [RecipeLoading, RecipeError] when LoadRecipes fails',
      build: () {
        when(() => mockRepository.getAllRecipes())
            .thenThrow(Exception('Failed to load recipes'));
        return recipeBloc;
      },
      act: (bloc) => bloc.add(LoadRecipes()),
      expect: () => [
        RecipeLoading(),
        isA<RecipeError>().having(
              (error) => error.message,
          'error message',
          contains('Malumotlarni olishda xatolik mavjud!'),
        ),
      ],
    );

    blocTest<RecipeBloc, RecipeState>(
      'emits [RecipeLoading, UserRecipeLoaded] when GetUserRecipes is added successfully',
      build: () {
        when(() => mockRepository.getUserRecipes())
            .thenAnswer((_) async => testRecipes);
        return recipeBloc;
      },
      act: (bloc) => bloc.add(GetUserRecipes()),
      expect: () => [
        RecipeLoading(),
        UserRecipeLoaded(testRecipes),
      ],
    );

    final newRecipe = Recipe(
      id: '3',
      title: 'New Recipe',
      ingredients: ['New Ingredient'],
      instructions: ['New Step'],
      cookingTime: '20 minutes',
      imageUrl: 'http://example.com/newimage.jpg',
      videoUrl: 'http://example.com/newvideo.mp4',
      category: 'Appetizer',
      authorId: 'user3',
      likes: [],
      comments: [],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      rating: 0.0,
    );

    blocTest<RecipeBloc, RecipeState>(
      'emits [RecipeLoading] and calls LoadRecipes when AddRecipe is added successfully',
      build: () {
        when(() => mockRepository.addRecipe(newRecipe))
            .thenAnswer((_) async {});
        when(() => mockRepository.getAllRecipes())
            .thenAnswer((_) async => [...testRecipes, newRecipe]);
        return recipeBloc;
      },
      act: (bloc) => bloc.add(AddRecipe(newRecipe)),
      expect: () => [
        RecipeLoading(),
        RecipeLoaded([...testRecipes, newRecipe]),
      ],
    );

    blocTest<RecipeBloc, RecipeState>(
      'calls repository.updateRecipe when UpdateRecipe is added',
      build: () {
        when(() => mockRepository.updateRecipe(any(), any()))
            .thenAnswer((_) async {});
        return recipeBloc;
      },
      act: (bloc) => bloc.add(UpdateRecipe(testRecipes[0], '1')),
      verify: (_) {
        verify(() => mockRepository.updateRecipe(testRecipes[0], '1')).called(1);
      },
    );

    blocTest<RecipeBloc, RecipeState>(
      'calls repository.deleteRecipe and LoadRecipes when DeleteRecipe is added',
      build: () {
        when(() => mockRepository.deleteRecipe(any()))
            .thenAnswer((_) async {});
        when(() => mockRepository.getAllRecipes())
            .thenAnswer((_) async => testRecipes.sublist(1));
        return recipeBloc;
      },
      act: (bloc) => bloc.add(DeleteRecipe('1')),
      expect: () => [
        RecipeLoading(),
        RecipeLoaded(testRecipes.sublist(1)),
      ],
      verify: (_) {
        verify(() => mockRepository.deleteRecipe('1')).called(1);
      },
    );

    blocTest<RecipeBloc, RecipeState>(
      'emits [MediaUploadInProgress, MediaUploadSuccess] when UploadMedia is added successfully',
      build: () {
        when(() => mockRepository.uploadMedia(any(), any()))
            .thenAnswer((_) async => 'https://example.com/media');
        return recipeBloc;
      },
      act: (bloc) => bloc.add(UploadMedia('path/to/media', 'image')),
      expect: () => [
        MediaUploadInProgress(),
        MediaUploadSuccess('https://example.com/media', 'image'),
      ],
    );
  });
}