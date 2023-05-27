import 'package:flutter/material.dart';

class RecipeCard extends StatelessWidget {
  final Widget title;
  final Widget subtitle;
  final Widget image;
  final Widget likeCount;
  final Widget button;
  final List<Widget> icons;

  RecipeCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.likeCount,
    required this.button,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: title,
          subtitle: subtitle,
        ),
        image,
        Row(
          children: [
            likeCount,
            SizedBox(width: 16),
            button,
          ],
        ),
        Row(
          children: icons,
        ),
      ],
    );
  }
}
