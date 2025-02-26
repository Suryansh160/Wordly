import 'package:flutter/material.dart';
import 'package:dictionary/screens/searchScreen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SearchScreen(),
      debugShowCheckedModeBanner: false,
      title: 'Dictionary App',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 18, 20, 22),
        scaffoldBackgroundColor: Color.fromARGB(255, 18, 20, 22),
      ),
    );
  }
}
