import 'package:flutter/material.dart';
import 'package:cook_n_share/recipe_details.dart';

class Recipe {
  final Image image;
  final String name;
  final String user;
  final List<String> ingredients;
  int likes;
  final List<String> steps;
  final List<String> allergens;
  bool isLiked;

  Recipe(
      {required this.image,
      required this.name,
      required this.user,
      required this.ingredients,
      required this.likes,
      required this.steps,
      required this.allergens,
      this.isLiked = false});
}

class RecipeCard extends StatefulWidget {
  const RecipeCard({super.key, required this.recipes});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final List<Recipe> recipes;

  @override
  State<RecipeCard> createState() => _RecipeCard(recipes: recipes);
}

class _RecipeCard extends State<RecipeCard> {
  _RecipeCard({required this.recipes});

  List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final ButtonStyle style = TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary);

    return recipes.isEmpty
      ? const Center(child: CircularProgressIndicator(),)
      : GridView.builder(
        itemCount: recipes.length,
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 1.5,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          Recipe recipe = recipes[index];
          return Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: oddItemColor,
            ),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  recipe.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  recipe.user,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: Colors.grey[200],
                    child: Image(
                      image: recipe.image.image,
                      fit: BoxFit.cover,
                      width: double
                          .infinity, // Ocupar todo el ancho disponible
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[100],
                  padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            recipe.isLiked = !recipe.isLiked;
                            if (recipe.isLiked) {
                              recipe.likes++;
                            } else {
                              recipe.likes--;
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                        ),
                        icon: Icon(
                          Icons.favorite,
                          color: recipe.isLiked ? Colors.red : Colors.white,
                        ),
                        label: Text(recipe.likes.toString(),
                            style: TextStyle(color: Colors.black)),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  RecipeDetailsScreen(recipe: recipe),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey[300],
                        ),
                        child: const Text('Details',
                            style: TextStyle(color: Colors.black)),
                      ),
                    ],
                  ),
                ),
                // const SizedBox(height: 6),
              ],
            ),
            // child: RecipeCard(
            //   title: title,
            //   subtitle: user_name,
            //   image: Image.asset('assets/im1.png'),
            //   likeCount: likes,
            //   button: ElevatedButton(
            //     onPressed: () {
            //       // Handle button press
            //     },
            //     child: Text('Button'),
            //   ),
            //   icons: [
            //     Icon(Icons.star),
            //     Icon(Icons.favorite),
            //     Icon(Icons.thumb_up),
            //   ],
            // ),
          );
        },
      );
  }
}
