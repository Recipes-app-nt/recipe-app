import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/blocs/category/category_bloc.dart';
import 'package:recipe_app/data/models/category_model.dart';
import 'package:recipe_app/ui/views/home/widgets/shimmers/categories_shimmer.dart';

class MyCategoriesRow extends StatefulWidget {
  const MyCategoriesRow({super.key});

  @override
  State<MyCategoriesRow> createState() => _MyCategoriesRowState();
}

class _MyCategoriesRowState extends State<MyCategoriesRow> {
  String selectedCategoryId = 'all';

  @override
  void initState() {
    super.initState();
    context.read<CategoryBloc>().add(GetCategory());
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state.isLoading) {
            return SizedBox(
              height: 40,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (context, index) => const Gap(10.0),
                itemBuilder: (context, index) {
                  return const CategoriesShimmer();
                },
              ),
            );
          }
          if (state.errorMessage != null) {
            return Center(
              child: Text(state.errorMessage!),
            );
          }
          if (state.category == null) {
            return const SizedBox.shrink();
          }

          final categories = [
            CategoriesModel(id: 'all', name: 'All', categoryId: 'all'),
            ...state.category!,
          ];

          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: categories.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const Gap(10.0),
            itemBuilder: (context, index) {
              final category = categories[index];
              final isSelected = category.id == selectedCategoryId;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedCategoryId = category.id;
                  });
                  print(selectedCategoryId);
                },
                child: Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xff129575)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    category.name,
                    style: TextStyle(
                      color:
                          isSelected ? Colors.white : const Color(0xff129575),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
