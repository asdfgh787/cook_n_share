import 'dart:convert';
import 'dart:io';

import 'package:cook_n_share/appbar.dart';
import 'package:cook_n_share/recepie_card.dart';
import 'package:cook_n_share/recipe_details.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _Search();
}


class _Search extends State<Search> {
  final List<Recipe> recipes = [];
  TextEditingController _searchController = TextEditingController();

  void backendpetition(String search) async {
    Map jsonMap = {};

    if (!search.isEmpty){
      jsonMap = {
        "name": search, // can be used to make the search tab using post petition
      };
    }


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
        recipes.add(Recipe(
            image: Image.network(data["recipes"][i]["image"]),
            name: data["recipes"][i]["name"],
            user: data["recipes"][i]["user"],
            ingredients: List<String>.from(data["recipes"][i]["ingredients"]),
            likes: data["recipes"][i]["likes"],
            steps: List<String>.from(data["recipes"][i]["steps"]),
            allergens: List<String>.from(data["recipes"][i]["allergens"])));
      }

      print("..number of items ${recipes.length}");
    });
  }


  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: TextField(
          style: TextStyle(color: Colors.white, fontSize: 18.0),
          cursorColor: Colors.white,
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Search',
            hintStyle: TextStyle(color: Colors.white),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent), // Remove the bottom line
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent), // Remove the bottom line when focused
            ),
            suffixIcon: IconButton(

              icon: Icon(Icons.search, color: Colors.white),
              onPressed: () {
                String searchTerm = _searchController.text;
                backendpetition(searchTerm);
              },
            ),
          ),
        ),
      ),
      body: RecipeCard(recipes: recipes,),

      );

  }
}
