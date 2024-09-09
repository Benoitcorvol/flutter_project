import 'package:flutter/material.dart';
import 'package:collab_app/screens/home_screen.dart';

class CollabApp extends StatelessWidget {
  const CollabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Collab App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomeScreen(),
    );
  }
}