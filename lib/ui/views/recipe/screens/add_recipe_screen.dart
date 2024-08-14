import 'package:flutter/material.dart';
import 'package:recipe_app/ui/widgets/custom_textfield.dart';

class AddRecipe extends StatefulWidget {
  const AddRecipe({super.key});

  @override
  State<AddRecipe> createState() => _AddRecipeState();
}

class _AddRecipeState extends State<AddRecipe> {
  final TextEditingController recipeNameController = TextEditingController();
  final TextEditingController ingredientsController = TextEditingController();
  final TextEditingController instructionsController = TextEditingController();
  final TextEditingController coockingTimeController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    selectedCategory = "Nonushta";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recept qo'shish"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: () {},
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload, size: 50),
                        Text('Rasm yoki Video yuklash'),
                      ],
                    ),
                  ),
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
                controller: coockingTimeController,
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
                items: ["Nonushta", "Tushlik", "Kechki ovqat", "Shirinlik"]
                    .map((item) {
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
                  if (Form.of(context).validate()) {}
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
  }
}
