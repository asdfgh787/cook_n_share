import 'package:cook_n_share/profile.dart';
import 'package:cook_n_share/search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar myAppBar(BuildContext context) {
  final String title = "Cook N' Share";
  final ColorScheme colorScheme = Theme.of(context).colorScheme;
  final ButtonStyle style = TextButton.styleFrom(
      foregroundColor: Theme.of(context).colorScheme.onPrimary);
  bool shadowColor = false;
  double? scrolledUnderElevation;

  return AppBar(
    title: Text(title),
    leading: IconButton(
      icon: Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () => Navigator.of(context).pop(),
    ),
    scrolledUnderElevation: scrolledUnderElevation,
    shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
    actions: <Widget>[
      TextButton(
        style: style,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Search()),
          );
          },
        child: const Icon(
          Icons.search,
          color: Colors.white,
        ),
      ),
      TextButton(
        style: style,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Profile()),
          );
        },
        child: const Icon(Icons.person, color: Colors.white),
      ),
      TextButton(
        style: style,
        onPressed: () {},
        child: const Icon(Icons.more_vert, color: Colors.white),
      ),
    ],
  );
}
