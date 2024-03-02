import 'package:flutter/material.dart';
import 'package:meals_app/models/meal.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  const MealItem({super.key, required this.meal});

  final Meal meal;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {},
        child: Stack(
          clipBehavior: Clip.hardEdge,
          //Stacks items above one another
          children: [
            FadeInImage(
              fit: BoxFit.cover,
              height: 200,
              width: double.infinity,
              //Images fade into the display instead of abruptly jumping at you
              placeholder: MemoryImage(
                  kTransparentImage), //Memory Image loads an image from memory
              image: NetworkImage(meal
                  .imageUrl), //Network Image allows us to use a URL to use that image
            ),
            Positioned(
              //Allows us to position the item in the stack, the container in this case.
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(horizontal: 44, vertical: 6),
                child: Column(
                  children: [
                    Text(
                      meal.title,
                      overflow:
                          TextOverflow.ellipsis, //ends overflow texts with ...
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      softWrap: true, //Dk what it does
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
