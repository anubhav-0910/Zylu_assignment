import 'package:flutter/material.dart';
import './screens/homescreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Zylu Assignment',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
              primary: Colors.white, secondary: Colors.black),
          fontFamily: 'UberMove',
        ),
        home: const HomeScreen());
  }
}
