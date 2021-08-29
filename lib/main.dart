import 'package:flutter/material.dart';
import 'package:mapp/view/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mapps with ORS',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: HomeScreen(),
    );
  }
}
