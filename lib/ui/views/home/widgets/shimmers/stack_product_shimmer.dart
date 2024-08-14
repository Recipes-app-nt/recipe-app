import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StackProductShimmer extends StatelessWidget {
  const StackProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        margin: const EdgeInsets.only(top: 80),
        width: 150,
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Stack(
          children: [
            Positioned(
              top: 20,
              left: 10,
              child: Container(
                clipBehavior: Clip.hardEdge,
                height: 110,
                width: 130,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
