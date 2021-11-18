import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:flutter/services.dart';
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Hide the debug banner
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: Home2(),
    );
  }
}

class Home2 extends StatefulWidget {
  const Home2({Key? key}) : super(key: key);

  @override
  _Home2State createState() => _Home2State();
}

class _Home2State extends State<Home2> {
  List _items = [];

  // Fetch content from the json file
  Future<void> readJson() async {
    print("clicked");
    final String response = await rootBundle.loadString('assets/images/data.txt');
    final data = await json.decode(response);
    setState(() {
     // _items = data["items"];
      print("-----------------------------");
      print(data);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Kindacode.com',
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            ElevatedButton(
              child: const Text('Load Data'),
              onPressed: readJson,
            ),

            // Display the data loaded from sample.json
            // _items.isNotEmpty
            //     ? Expanded(
            //   child: ListView.builder(
            //     itemCount: _items.length,
            //     itemBuilder: (context, index) {
            //       return Card(
            //         margin: const EdgeInsets.all(10),
            //         child: ListTile(
            //           leading: Text(_items[index]["id"]),
            //           title: Text(_items[index]["name"]),
            //           subtitle: Text(_items[index]["description"]),
            //         ),
            //       );
            //     },
            //   ),
            // )
            //     : Container()
          ],
        ),
      ),
    );
  }
}