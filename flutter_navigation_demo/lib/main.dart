import 'package:flutter/material.dart';
import 'home_page.dart';
import 'about_page.dart';
import 'feedback_form_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Navigation Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        '/about': (context) => const AboutPage(),
        '/form': (context) => const FeedbackFormPage(),
      },
    );
  }
}