import 'package:flutter/material.dart';
import 'package:meals_app/data/dummy_data.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/category_grid_item.dart';
import 'package:meals_app/models/category.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key, required this.ontoggleFavourites});

  final void Function(Meal meal) ontoggleFavourites;

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = dummyMeals
        .where((meal) => meal.categories.contains(category.id))
        .toList();
    Navigator.push(
      //ctx content is pushed onto context content (Build WIdget content)
      context,
      MaterialPageRoute(
        builder: (ctx) {
          return MealsScreen(
            title: category.title,
            meals: filteredMeals,
            onToggleFavourites: ontoggleFavourites,
          );
        },
      ),
    );
  }

  @override
  Widget build(context) {
    return GridView(
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
        ...availableCategories.map(
          (category) => CategoryGridItem(
            category: category,
            onSelectCategory: () {
              _selectCategory(context,
                  category); //sends context of build Widget to selectCategory
            },
          ),
        ),
      ],
    );
  }
}
