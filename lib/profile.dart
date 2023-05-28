import 'package:cook_n_share/appbar.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _Profile();
}

class _Profile extends State<Profile> {
  final List<String> items = [
    'Item 1',
    'Item 2',
    'Item 3',
    'Item 4',
    'Item 5',
  ];

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
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Container(
                  height: 100, // Set the desired height
                  child: ListTile(
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
                    leading: Container(
                      width: 80,
                      height: 150,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(7.0),
                        image: DecorationImage(
                          // image: AssetImage('assets/item_image.jpg'),
                          image: NetworkImage(
                              'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Align(
                      alignment: Alignment.center,
                      child: Text(
                        items[index],
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                    trailing: Icon(Icons.arrow_forward),
                    onTap: () {
                      // Handle item selection
                      print('Selected: ${items[index]}');
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
