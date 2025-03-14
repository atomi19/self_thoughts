import 'package:flutter/material.dart';
import 'package:self_thoughts/pages/main_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Self Thoughts',
      debugShowCheckedModeBanner: false,
      home: const HomePage(title: 'Self Thoughts'),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.blue
        )
      ),
    );
  }
}