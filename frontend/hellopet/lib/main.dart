import 'package:flutter/material.dart';
import 'Pages/login_page.dart';
// import 'Pages/register_page.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
      home: const LoginPage(), // Pass the title here (title: 'Pet App')
    );
  }
}

class getDataClass extends StatefulWidget {
  const getDataClass({super.key});

  @override
  State<getDataClass> createState() => _getDataClassState();
}

class _getDataClassState extends State<getDataClass> {
  Future<Map<String, dynamic>> retrieveData() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/checkuser/1'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> userData = jsonDecode(response.body);
        print(userData);
        return userData;
      } else {
        throw Exception('Failed to load profile: ${response.statusCode}');
      }
    } catch (e) {
      print(e);
      return {}; // or handle the error accordingly
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // Call the retrieveData function when the button is pressed
                await retrieveData();
              },
              child: const Text('Retrieve Data'), // Add a meaningful child
            ),
          ],
        ),
      ),
    );
  }
}
