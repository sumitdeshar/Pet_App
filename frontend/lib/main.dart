import 'package:flutter/material.dart';
import 'Pages/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginPage(), // Pass the title here (title: 'Pet App')
    );
  }
}
