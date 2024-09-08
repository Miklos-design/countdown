import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(CountdownApp());
}

class CountdownApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // This line removes the debug label

      title: 'Countdown App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
