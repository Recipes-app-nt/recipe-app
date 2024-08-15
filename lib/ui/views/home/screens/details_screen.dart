import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  // final Recipe recipe;
  const DetailsScreen({
    super.key,
    // required this.recipe,
  });

  @override
  Widget build(BuildContext context) {
    // print(recipe.imageUrl);
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_horiz),
          ),
        ],
      ),
      // body: SingleChildScrollView(
      //   child: Column(
      //     children: [
      //       Container(
      //         height: 150,
      //         width: double.infinity,
      //         child: Image.network(
      //           recipe.imageUrl,
      //           fit: BoxFit.cover,
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
    );
  }
}
