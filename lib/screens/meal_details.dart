import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/provider/favourites_provider.dart';

class MealDetailsScreen extends ConsumerWidget {
  const MealDetailsScreen({
    super.key,
    required this.meal,
  });

  final Meal meal;
  // final void Function(Meal meal)
  //     onToggleFavourites; //recieves function from Meals, which recieves it from Tabs.

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favouriteMeals = ref.watch(favouriteMealsProvider);
    final isFavouriteIcon = favouriteMeals.contains(meal);

    //ref doesn't need to be accepted in statelful widget as it is globally available,
    //but here it needs to be passed to build by riverpod.
    return Scaffold(
      appBar: AppBar(
        title: Text(meal.title),
        actions: [
          IconButton(
            onPressed: () {
              final isFavourite =
                  ref //method has been changed from void to bool in fav provider.
                      .read(favouriteMealsProvider.notifier)
                      .toggleFavouriteMealStatus(
                          meal); //the '.notifier' gives us access to the
              //class created inside the 'favouriteMealsProvider' Provider.
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavourite
                        ? 'Meal has been added to favourites!'
                        : 'Meal has been removed from favourites.',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
            icon: Icon(isFavouriteIcon ? Icons.star : Icons.star_border),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.network(
              meal.imageUrl,
              fit: BoxFit.fill,
              width: double.infinity,
              height: 300,
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              'Ingredients',
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            const SizedBox(
              height: 16,
            ),
            ...meal.ingredients.map(
              (ingredient) => Text(
                textAlign: TextAlign.center,
                ingredient,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Text(
              'Steps',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(color: Theme.of(context).colorScheme.primary),
            ),
            ...meal.steps.map(
              (step) => Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Text(
                  textAlign: TextAlign.center,
                  step,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
