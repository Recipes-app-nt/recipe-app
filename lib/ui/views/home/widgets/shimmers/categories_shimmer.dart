import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.center,
        child: SizedBox(
          height: 20,
          width: 60,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ),
    );
  }
}
