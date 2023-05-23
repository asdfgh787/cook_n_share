import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

final List<int> _items = List<int>.generate(51, (int index) => index);

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorSchemeSeed: const Color(0xff788b91),
      ),
      home: const MyHomePage(title: "Cook N' Share"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool shadowColor = false;
  double? scrolledUnderElevation;

  //Code to display an image
  var imageByte;

  Image? letsgoo;
  void obtenirImage(BuildContext context) async {
    final Map jsonMap = {
      "name": 'pizza', // can be used to make the search tab
    };

    final String url = 'http://10.0.2.2:5000/returnImage';
    //final String url = 'http://127.0.0.1:5000/returnImage';
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    String reply = await response.transform(utf8.decoder).join();
    print('decode');
    print(jsonDecode(reply));

    setState(() {//still not working
      imageByte = Uint8List.fromList(jsonDecode(reply)['image1']['imatge'].cast<int>());
      letsgoo = Image.memory(
          Uint8List.fromList(jsonDecode(reply)['image1']['imatge'].cast<int>()));
    });
    //httpClient.close();
  }

  @override
  Widget build(BuildContext context) {
    obtenirImage(context);
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    final Color oddItemColor = colorScheme.primary.withOpacity(0.05);
    final ButtonStyle style = TextButton.styleFrom(foregroundColor: Theme.of(context).colorScheme.onPrimary);
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        scrolledUnderElevation: scrolledUnderElevation,
        shadowColor: shadowColor ? Theme.of(context).colorScheme.shadow : null,
        actions: <Widget>[
          TextButton(
            style: style,
            onPressed: () {},
            child: const Icon(
              Icons.search,
              color: Colors.white,
            ),
          ),
          TextButton(
            style: style,
            onPressed: () {},
            child: const Icon(
              Icons.person,
              color: Colors.white
            ),
          ),
          TextButton(
            style: style,
            onPressed: () {},
            child: const Icon(
              Icons.more_vert,
              color: Colors.white
            ),
          ),
        ],
      ),
      body: GridView.builder(
        itemCount: _items.length,
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
            child: letsgoo == null
                ? Text('No image selected.')
                : Image(
              image: letsgoo!.image,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }


}


