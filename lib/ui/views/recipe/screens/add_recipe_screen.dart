import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe_app/blocs/recipe/recipe_bloc.dart';
import 'package:recipe_app/blocs/recipe/recipe_event.dart';
import 'package:recipe_app/blocs/recipe/recipe_state.dart';
import 'package:recipe_app/data/models/recipe_model.dart';
import 'package:recipe_app/data/services/media_picker_service.dart';
import 'package:recipe_app/ui/widgets/custom_textfield.dart';

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

  final MediaPickerService _mediaPickerService = MediaPickerService();

  @override
  void initState() {
    super.initState();
    selectedCategory = "Nonushta";
  }

  void clearController(){
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
          if (state is MediaUploadInProgress || state is RecipeLoading) {
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
                  content: Text("${state.mediaType == 'image' ? 'Rasm' : 'Video'} yuklandi!"),
                  backgroundColor: Colors.green,
                  duration: const Duration(seconds: 2),
                ),
              );
            });
          } else if (state is MediaUploadFailure) {
            return const Center(
                child: Text("Media yuklashda xatolik yuz berdi!"));
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
                        child: imageUrl != null && videoUrl == null
                            ? const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.upload, size: 50),
                              Text("Rasm yoki Video yuklash"),
                            ],
                          ),
                        ) : const Center(child: Icon(Icons.check,size: 60, color: Colors.green,))
                      ),
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
                      labelText: "Vaqti",
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Iltimos vaqtini kiriting!!!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                          labelText: 'Category', border: OutlineInputBorder()),
                      items: [
                        "Nonushta",
                        "Tushlik",
                        "Kechki ovqat",
                        "Shirinlik"
                      ].map((item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                          categoryController.text = value;
                        });
                      },
                      value: selectedCategory,
                      validator: (value) =>
                          value == null ? "Iltimos categoriyani tanlang" : null,
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () {
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
                            category: categoryController.text,
                            authorId: "",
                            likes: [],
                            comments: [],
                            createdAt: DateTime.now(),
                            updatedAt: DateTime.now(),
                          );

                          context.read<RecipeBloc>().add(AddRecipe(recipe));
                          clearController();
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
                            fontWeight: FontWeight.w600),
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
