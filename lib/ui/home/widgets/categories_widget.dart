import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:recipe_app/blocs/category/category_bloc.dart';

class MyCategoriesRow extends StatefulWidget {
  const MyCategoriesRow({super.key});

  @override
  State<MyCategoriesRow> createState() => _MyCategoriesRowState();
}

class _MyCategoriesRowState extends State<MyCategoriesRow> {
  String? selectedCategoryId;

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
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: state.category!.length,
            scrollDirection: Axis.horizontal,
            separatorBuilder: (context, index) => const Gap(10.0),
            itemBuilder: (context, index) {
              final categoryies = state.category![index];
              return Container(
                width: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  color: const Color.fromARGB(255, 199, 217, 232),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text(categoryies.name),
              );
            },
          );
        },
      ),
    );
  }
}
