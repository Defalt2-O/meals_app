import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';

class FavouriteMealsNotifier extends StateNotifier<List<Meal>> {
  //The generic argument tells flutter which kind of data will be managed in the end.
  FavouriteMealsNotifier()
      : super([]); //pass data to super that was mentioned in the generic type

  bool toggleFavouriteMealStatus(Meal meal) {
    final isMealFavourite = state.contains(
        meal); //state is the list that is passed to super. It is immutable and cannot be modified,
    //but can only be reassigned.

    if (isMealFavourite) {
      state = state.where((m) => m.id != meal.id).toList();
      return false;
    } else {
      state = [...state, meal];
      return true;
    }
  }
}

final favouriteMealsProvider =
    StateNotifierProvider<FavouriteMealsNotifier, List<Meal>>((ref) {
  //The StateNotifierProvider wants to know what type of data will be returned in the generic brackets.
  //Therefore first pass the class name that was created, and then pass the type that that class deals with.
  return FavouriteMealsNotifier();
});
