import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: SpalshPage(),
  ));
}
class SpalshPage extends StatelessWidget {
  const SpalshPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 250,
          height: 250,
          child: const Image(
            image: AssetImage('assets/images/.png'),
          ),
        ),
      ),
    );
  }
}

