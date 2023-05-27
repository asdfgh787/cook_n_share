import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'dart:io';
import 'dart:typed_data';

import 'package:cook_n_share/appbar.dart';
import 'package:flutter/material.dart';
import 'package:cook_n_share/recepie_card.dart';



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

class Recipe {
  final Image image;
  final String name;
  final String user;
  final List<String> ingredients;
  final int likes;
  final List<String> steps;
  final List<String> allergens;

  Recipe(
      {required this.image,
      required this.name,
      required this.user,
      required this.ingredients,
      required this.likes,
      required this.steps,
      required this.allergens});
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
      for(var i = 0; i < data["recipes"].length; i++){
        _recipes.add(Recipe(
            image: Image.network(
                data["recipes"][i]["image"]),
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
  void initState()
  {
    super.initState();
    readJson();//call it over here
  }

  Widget letsgoo = Image.asset('backend/im1.png');
  Text title = Text('');
  Text user_name = Text('');
  Text likes = Text('0');
  void obtenirImage(BuildContext context) async {
    final Map jsonMap = {
      "name": 'pizza', // can be used to make the search tab using post petition
    };

    final String url = 'http://10.0.2.2:5000/returnImage';
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    title = Text(jsonDecode(reply)['image1']['nom']);
    user_name = Text(jsonDecode(reply)['image1']['user']);
    likes = Text(jsonDecode(reply)['image1']['likes'].toString());

    /*
    setState(() {//still not working

      List<dynamic> imageData = jsonDecode(reply)['image1']['imatge'];
      List<int> imageBytes = [];

      for (dynamic innerList in imageData) {
        for (dynamic value in innerList) {
          if (value is int) {
            imageBytes.add(value);
          }
        }
      }

      imageByte = Uint8List.fromList(imageBytes);
      //letsgoo = Image.memory(Uint8List.fromList(imageBytes));
    }

    );
  */
  }

  @override
  Widget build(BuildContext context) {
    obtenirImage(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final ButtonStyle style = TextButton.styleFrom(
        foregroundColor: Theme.of(context).colorScheme.onPrimary);
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    return Scaffold(
      appBar: myAppBar(context),
      body: GridView.builder(
        itemCount: _recipes.length,
        padding: const EdgeInsets.all(8.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 1,
          childAspectRatio: 2.0,
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return Container(
            alignment: Alignment.center,
            // tileColor: _items[index].isOdd ? oddItemColor : evenItemColor,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: oddItemColor,
            ),
            child: Column(
              children: [
                Expanded(
                  child: _recipes[index].image,
                ),
                Text(_recipes[index].name),
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
      ),
    );
  }
}
