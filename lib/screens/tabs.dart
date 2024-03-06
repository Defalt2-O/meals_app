// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/provider/meals_provider.dart';

var kInitialFilters = {
  Filters.glutenFree: false,
  Filters.lactoseFree: false,
  Filters.vegetarian: false,
  Filters.vegan: false
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> favouriteMeals = [];
  Map<Filters, bool> _selectedFilters = kInitialFilters;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _toggleMealFavouriteStatus(Meal meal) {
    final isExisting = favouriteMeals.contains(meal);
    if (isExisting) {
      setState(() {
        favouriteMeals.remove(meal);
      });
      _showInfoMessage('Meal has been removed from Favourites!');
    } else {
      setState(() {
        favouriteMeals.add(meal);
      });
      _showInfoMessage('Meal has been added to Favourites!');
    }
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      final result = await Navigator.of(context).push<Map<Filters, bool>>(
        //Using push replacement causes the screen to not be pushed onto the stack of screens,
        //but to replace the currently viewed screen. Push replacement also doesn't add the back button.
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );

      setState(() {
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final meals = ref.watch(
        mealsProvider); //by changing the widget from 'StatefulWidget' to 'ConsumerStatefulWidget', we have access
    //to ref..which can use 'watch' to listen for any changes in the 'mealsProvider' Provider
    //However, main must also be modified.
    final availableMeals = meals.where(
      (meal) {
        if (_selectedFilters[Filters.glutenFree]! && !meal.isGlutenFree) {
          return false;
        }
        if (_selectedFilters[Filters.lactoseFree]! && !meal.isLactoseFree) {
          return false;
        }
        if (_selectedFilters[Filters.vegetarian]! && !meal.isVegetarian) {
          return false;
        }
        if (_selectedFilters[Filters.vegan]! && !meal.isVegan) {
          return false;
        }
        return true;
      },
    ).toList();

    Widget activePage = CategoriesScreen(
      ontoggleFavourites: _toggleMealFavouriteStatus,
      availableMeals: availableMeals,
    );
    String _selectedPage = 'Categories';

    if (_selectedPageIndex == 1) {
      activePage = MealsScreen(
          meals: favouriteMeals,
          onToggleFavourites: _toggleMealFavouriteStatus);
      _selectedPage = 'Favourites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_selectedPage),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        onTap:
            _selectPage, //ontap of bottomnavbar updates an index value based on one of the items that we click below
        currentIndex: _selectedPageIndex,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.set_meal), label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Favourites'),
        ],
      ),
    );
  }
}
