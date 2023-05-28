import 'package:cook_n_share/recipe_details.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:cook_n_share/recepie_card.dart';
import 'package:flutter/services.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:cook_n_share/appbar.dart';

/*final List<Recipe> recipes = [
  Recipe(
      image: Image.network(
          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
      name: 'Pizza',
      user: '@marta',
      ingredients: ['farina', 'tomaquet'],
      likes: 121,
      steps: ['preparar la massa', 'afegir el tomaquet'],
      allergens: [])
];*/

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Cook N' Share",
      theme: ThemeData(
        colorSchemeSeed: const Color(0xff788b91),
      ),
      home: const HomePage(title: "Cook N' Share"),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool shadowColor = false;
  double? scrolledUnderElevation;
  var imageByte;
  List<Recipe> _recipes = [];

  Future<void> readJson() async {
    final String response = await rootBundle.loadString('assets/recipes.json');
    final data = await json.decode(response);
    setState(() {
      for (var i = 0; i < data["recipes"].length; i++) {
        _recipes.add(Recipe(
            image: Image.network(data["recipes"][i]["image"]),
            name: data["recipes"][i]["name"],
            user: data["recipes"][i]["user"],
            ingredients: List<String>.from(data["recipes"][i]["ingredients"]),
            likes: data["recipes"][i]["likes"],
            steps: List<String>.from(data["recipes"][i]["steps"]),
            allergens: List<String>.from(data["recipes"][i]["allergens"])));
      }

      print("..number of items ${_recipes.length}");
    });
  }

  void backendpetition() async {
    final Map jsonMap = {
      //"name": 'pizza', // can be used to make the search tab using post petition
    };

    final String url = 'http://10.0.2.2:5000/returnImage';
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();

    final data = jsonDecode(reply);
    setState(() {
      for (var i = 0; i < data["recipes"].length; i++) {
        _recipes.add(Recipe(
            image: Image.network(data["recipes"][i]["image"]),
            name: data["recipes"][i]["name"],
            user: data["recipes"][i]["user"],
            ingredients: List<String>.from(data["recipes"][i]["ingredients"]),
            likes: data["recipes"][i]["likes"],
            steps: List<String>.from(data["recipes"][i]["steps"]),
            allergens: List<String>.from(data["recipes"][i]["allergens"])));
      }

      print("..number of items ${_recipes.length}");
    });
  }

  @override
  void initState() {
    super.initState();
    //readJson(); // data from json
    backendpetition(); //data from backend
  }


  @override
  Widget build(BuildContext context) {

    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final ButtonStyle style = TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary);
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: myAppBar(context),
      body: RecipeCard(recipes: _recipes),
    );
  }
}
