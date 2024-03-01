import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pick your Category'),
      ),
      body: GridView(
        //Creates a Grid Like Structure
        padding: const EdgeInsets.all(24),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          //Delegates rows and columns to the grid. Sliver object defines
          crossAxisCount: 2, //no of columns i.e. main axis is rows
          childAspectRatio: 3 / 2, //sizing
          crossAxisSpacing: 20, //space between columns
          mainAxisSpacing: 20, //space between rows
        ),
        children: [
          ...availableCategories
              .map((category) => CategoryGridItem(category: category))
        ],
      ),
    );
  }
}
