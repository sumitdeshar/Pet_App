import 'package:flutter/material.dart';
import 'Pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pet App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const MyHomePage(title: 'Pet App'), // Pass the title here
    );
  }
}


// import 'package:flutter/material.dart';
// import 'Pages/home_page.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: true,
//       title: 'Pet App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: Scaffold(),
//     );
//   }
// }