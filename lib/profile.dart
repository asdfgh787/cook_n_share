import 'package:cook_n_share/appbar.dart';
import 'package:cook_n_share/recepie_card.dart';
import 'package:cook_n_share/recipe_details.dart';
import 'package:flutter/material.dart';

class User {
  final String name;
  final String alias;
  int following;
  int followers;
  final Image image;
  final List<Recipe> recipes;

  User(
      {required this.name,
      required this.alias,
      required this.following,
      required this.followers,
      required this.image,
      required this.recipes});
}

class Profile extends StatefulWidget {
  final bool isYourProfile;
  final String userAlias;

  Profile({super.key, required this.isYourProfile, required this.userAlias});

  final User user = User(
      name: 'Marta Gil',
      alias: '@martagil',
      following: 354,
      followers: 546,
      image: Image.network(
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
      recipes: [
        Recipe(
            image: Image.network(
                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            name: 'Pizza',
            user: '@marta',
            ingredients: ['farina', 'tomaquet'],
            likes: 121,
            steps: ['preparar la massa', 'afegir el tomaquet'],
            allergens: [])
      ]); //TODO: get the user info from backend using userAlias

  @override
  State<Profile> createState() => _Profile(user: user);
}

class _Profile extends State<Profile> {
  User user;

  _Profile({required this.user});

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: myAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 30),
          child: Column(children: [
            Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: const Image(
                          image: NetworkImage(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'))),
                ),
                const SizedBox(height: 10, width: 30),
                Expanded(
                  child: Column(children: [
                    Text("Marta Gil",
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text("@martagil",
                        style: Theme.of(context).textTheme.bodyMedium),
                  ]),
                ),
                const SizedBox(height: 20, width: 20),
              ],
            ),
            const SizedBox(height: 20.0),
            // List
            ListView.builder(
              shrinkWrap: true,
              itemCount: user.recipes.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100, // Set the desired height
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                    leading: Container(
                      width: 80,
                      height: 170,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        image: DecorationImage(
                          // image: AssetImage('assets/item_image.jpg'),
                          image: user.recipes[index].image.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Align(
                      alignment: Alignment.center,
                      child: Text(
                        user.recipes[index].name,
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                    trailing: Column(children: const [
                      SizedBox(height: 20.0),
                      Icon(Icons.arrow_forward)
                    ]),
                    onTap: () {
                      // Handle item selection
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              RecipeDetailsScreen(recipe: user.recipes[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ]),
        ),
      ),
    );
  }
}
