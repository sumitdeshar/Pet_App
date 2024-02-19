import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Pages/Home/home_page.dart';
import 'package:frontend/Pages/Home/register_page.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  bool isLoading = false;
  String appBarTitle = 'Pet App';

  Future<void> storeTokens(String accessToken, String refreshToken) async {
    await storage.write(key: 'access_token', value: accessToken);
    await storage.write(key: 'refresh_token', value: refreshToken);
  }

  Future<String?> getToken() async {
    return await storage.read(key: 'access_token');
  }

  LoginAuth() async {
    try {
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        final response = await http.post(
          Uri.parse('http://10.0.2.2:8000/login'),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
          body: {
            'username': _usernameController.text,
            'password': _passwordController.text,
          },
        );
        if (response.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(response.body);
          final String accessToken = responseData['access'];
          final String refreshToken = responseData['refresh'];
          await storeTokens(accessToken, refreshToken);

          print(
              'Login successful. Access Token: $accessToken, Refresh Token: $refreshToken');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MyHomePage()), //title: 'Owner Profile',
            //title: 'Pet App'
          );
        }
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: appBarTitle),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Create an Account',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
              child: const Text(
                'New to the community? Create an account',
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    decoration: TextDecoration.underline),
              ),
            ),
            const SizedBox(height: 32.0),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Loading!'),
                    duration: Duration(seconds: 3),
                  ),
                );
                LoginAuth();
              },
              child: const Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
