import 'package:flutter/material.dart';

void main() {
  runApp(const MyPanel());

}
class MyPanel extends StatelessWidget {
  const MyPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          constraints: const BoxConstraints.expand(),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('images/bg.webp'),
              fit: BoxFit.cover
              )
          ),
        ),
      ),
    );
  }
}
