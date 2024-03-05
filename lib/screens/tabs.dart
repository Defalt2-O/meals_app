// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/screens/categories.dart';
import 'package:meals_app/screens/filters.dart';
import 'package:meals_app/screens/meals.dart';
import 'package:meals_app/widgets/main_drawer.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

//watch vid again
class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> favouriteMeals = [];

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

  void _setScreen(String identifier) {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      Navigator.of(context).push(
        //Using push replacement causes the screen to not be pushed onto the stack of screens,
        //but to replace the currently viewed screen. Push replacement also doesn't add the back button.
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget activePage = CategoriesScreen(
      ontoggleFavourites: _toggleMealFavouriteStatus,
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
