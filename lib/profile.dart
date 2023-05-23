import 'package:cook_n_share/appbar.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: myAppBar(context),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal:50, vertical:50),
          child: Column(children: [
            Row(
              children: [
                SizedBox(
                  width: 120,
                  height: 120,
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: const Image(
                          image: NetworkImage(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'))),
                ),
                const SizedBox(height: 10, width: 30),
                Column(
                  children: [
                    Text("Marta Gil", style: Theme.of(context).textTheme.headlineMedium),
                    Text("@martagil", style: Theme.of(context).textTheme.bodyMedium),]
                ),
                const SizedBox(height: 20, width: 20),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
