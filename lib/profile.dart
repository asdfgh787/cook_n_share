import 'dart:convert';
import 'dart:io';

import 'package:cook_n_share/appbar.dart';
import 'package:cook_n_share/recepie_card.dart';
import 'package:cook_n_share/recipe_details.dart';
import 'package:flutter/material.dart';

class User {
  final String name;
  final String alias;
  final String following;
  final String followers;
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
/*
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
*/
  @override
  State<Profile> createState() => _Profile(userAlias: userAlias);
}

class _Profile extends State<Profile> {


  _Profile({required this.userAlias});
  String userAlias;
  User user = User(name:'',alias:'',following:'0',followers:'0',image:Image.network(
      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),recipes:[]);
  List<Recipe> recipes = [];
  void backendpetition() async {
    final Map jsonMap = {
      "user": userAlias, // can be used to make the search tab using post petition
    };

    final String url = 'http://10.0.2.2:5000/returnUser';
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();

    final data = jsonDecode(reply)['user'][0];

    setState(() {
      recipes = [];
      for (var i = 0; i < data["recipes"].length; i++) {
        recipes.add(Recipe(
            image: Image.network(data["recipes"][i]["image"]),
            name: data["recipes"][i]["name"],
            user: data["recipes"][i]["user"],
            ingredients: List<String>.from(data["recipes"][i]["ingredients"]),
            likes: data["recipes"][i]["likes"],
            steps: List<String>.from(data["recipes"][i]["steps"]),
            allergens: List<String>.from(data["recipes"][i]["allergens"])));
      }
      user = User(
          name: data['name'],
          alias: data['alias'],
          following: data['following'],
          followers: data['followers'],
          image: Image.network(
          data['image']),
      recipes: recipes
      );
    });
  }
  @override
  void initState() {
    super.initState();
    backendpetition(); //data from backend
  }
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
                      child:  user.image),
                ),
                const SizedBox(height: 10, width: 30),
                Expanded(
                  child: Column(children: [
                    Text(user.name,
                        style: Theme.of(context).textTheme.headlineMedium),
                    Text(user.alias,
                        style: Theme.of(context).textTheme.bodyMedium),
                  ]),
                ),
                const SizedBox(height: 20, width: 20),
              ],
            ),
            const SizedBox(height: 40.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: Column(
                      children: [
                        Text(
                          'Followers',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          user.followers,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding:
                        const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: Column(
                      children:  [
                        Text(
                          'Following',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          user.following,
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25.0),
            // Post Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: user.alias == '@martagil'? const Text('POST'): const Text('Follow'),
              ),
            ),
            const SizedBox(height: 16.0),
            // List
            ListView.builder(
              shrinkWrap: true,
              itemCount: user.recipes.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100, // Set the desired height
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 6.0, horizontal: 10.0),
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
