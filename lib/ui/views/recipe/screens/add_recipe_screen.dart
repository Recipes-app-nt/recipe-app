import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/category/category_bloc.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/data/models/category_model.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/data/services/media_picker_service.dart';
import 'package:recipe_app/hive/services/hive_service.dart';
import 'package:recipe_app/ui/widgets/custom_textfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../hive/models/recipe_hive_model.dart';

class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  State<AddRecipeScreen> createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final TextEditingController recipeNameController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController cookingTimeController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  String? selectedCategory;
  final _formKey = GlobalKey<FormState>();
  String? imageUrl;
  String? videoUrl;
  late String authorId;
  final RecipeHiveService _recipeHiveService = RecipeHiveService();
  final MediaPickerService _mediaPickerService = MediaPickerService();

  @override
  void initState() {
    super.initState();
    _initHiveService();
    selectedCategory = "Nonushta";
    getUserEmail();
  }

  Future<void> _initHiveService() async {
    await _recipeHiveService.init();
  }

  Future<void> _saveRecipeToHive(Recipe recipe) async {
    final recipeHiveModel = RecipeHiveModel(
      id: recipe.id,
      title: recipe.title,
      ingredients: recipe.ingredients,
      instructions: recipe.instructions,
      cookingTime: recipe.cookingTime,
      imageUrl: recipe.imageUrl,
      videoUrl: recipe.videoUrl,
      category: recipe.category,
      authorId: recipe.authorId,
      rating: recipe.rating,
    );

    await _recipeHiveService.addRecipe(recipeHiveModel);
    print("==================Manimcha localga saqlandi");
  }

  void getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();

    final userInfo = jsonDecode(prefs.getString("userData")!);

    if (userInfo != null) {
      authorId = userInfo["email"];
    } else {
      print("Foydlanuvchi malumotlari mavjud emas!!!");
    }
  }

  void clearController() {
    recipeNameController.clear();
    ingredientsController.clear();
    instructionsController.clear();
    cookingTimeController.clear();
    categoryController.clear();
  }

  Future<void> _pickAndUploadMedia(BuildContext context) async {
    final mediaType = await _showMediaPickerDialog(context);
    if (mediaType == null) return;

    final path = await _mediaPickerService.pickMedia(mediaType);
    if (path == null) return;

    context.read<RecipeBloc>().add(UploadMedia(path, mediaType));
  }

  Future<String?> _showMediaPickerDialog(BuildContext context) async {
    return showDialog<String?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Mediani tanlang"),
          content: const Text("Rasm yuklaysizmi yoki Video. Tanlng!!!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('image');
              },
              child: const Text("Rasm"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop('video');
              },
              child: const Text("Video"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recept qo'shish"),
        centerTitle: true,
      ),
      body: BlocBuilder<RecipeBloc, RecipeState>(
        builder: (context, state) {
          if (state is MediaUploadInProgress) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text("Yuklanmoqda..."),
                ],
              ),
            );
          } else if (state is MediaUploadSuccess) {
            if (state.mediaType == 'image') {
              imageUrl = state.downloadUrl;
            } else if (state.mediaType == 'video') {
              videoUrl = state.downloadUrl;
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      "${state.mediaType == 'image' ? 'Rasm' : 'Video'} yuklandi!"),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            });
          } else if (state is MediaUploadFailure) {
            return Center(
              child: Text(state.message),
            );
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GestureDetector(
                      onTap: () => _pickAndUploadMedia(context),
                      child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              style: BorderStyle.solid,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: imageUrl == null && videoUrl == null
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.upload, size: 50),
                                      Text("Rasm yoki Video yuklash"),
                                    ],
                                  ),
                                )
                              : const Center(
                                  child: Icon(
                                  Icons.check,
                                  size: 60,
                                  color: Colors.green,
                                ))),
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: recipeNameController,
                      labelText: "Nomi",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Iltimos recept nomini kiriting!!!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: ingredientsController,
                      labelText: 'Masalliqlar ( , bilan)',
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Iltimos masalliqlarni kiriting!!!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: instructionsController,
                      labelText: "Jarayon(,bilan)",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Iltimos jarayonlarni kiriting!!!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    CustomTextFormField(
                      controller: cookingTimeController,
                      labelText: "Vaqti(min)",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Iltimos vaqtini kiriting!!!";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 20),
                    BlocBuilder<CategoryBloc, CategoryState>(
                      builder: (context, state) {
                        if (state.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (state.errorMessage != null) {
                          return Center(
                            child: Text(state.errorMessage!),
                          );
                        }
                        if (state.category == null || state.category!.isEmpty) {
                          return const SizedBox.shrink();
                        }

                        final categoryItems = state.category!.map((category) {
                          return DropdownMenuItem<CategoriesModel>(
                            value: category,
                            child: Text(category.name),
                          );
                        }).toList();

                        return DropdownButtonFormField<CategoriesModel>(
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: categoryItems,
                          onChanged: (CategoriesModel? value) {
                            setState(() {
                              selectedCategory = value!.categoryId;
                              categoryController.text = value.name;
                            });
                          },
                          validator: (value) => value == null
                              ? "Iltimos categoriyani tanlang"
                              : null,
                        );
                      },
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          final recipe = Recipe(
                            id: DateTime.now().toString(),
                            title: recipeNameController.text,
                            ingredients: ingredientsController.text.split(","),
                            instructions:
                                instructionsController.text.split(","),
                            cookingTime: cookingTimeController.text,
                            imageUrl: imageUrl ?? "",
                            videoUrl: videoUrl ?? "",
                            category: selectedCategory.toString(),
                            authorId: authorId ?? "",
                            likes: [],
                            comments: [],
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                            rating: 0.0,
                          );
                          await _saveRecipeToHive(recipe);
                          context.read<RecipeBloc>().add(AddRecipe(recipe));

                          clearController();
                          imageUrl = null;
                          videoUrl = null;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Ma'lumotlar saqlandi!!!"),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 1),
                            ),
                          );

                          await Future.delayed(const Duration(seconds: 2), () {
                            Navigator.pop(context, true);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff129575),
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text(
                        "Qo'shish",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
