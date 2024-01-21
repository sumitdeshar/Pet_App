import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Pages/Home/login_page.dart';

final storage = FlutterSecureStorage();

class TokenVerification extends StatefulWidget {
  const TokenVerification({super.key});

  @override
  State<TokenVerification> createState() => _TokenVerificationState();
}

class _TokenVerificationState extends State<TokenVerification> {
  Future<void> checkAccessToken() async {
    final String? accessToken = await getAccessToken();

    if (accessToken == null) {
      // No access token, navigate to login
      print('NULL');
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    } else {
      // Check if the token is expired
      final bool isTokenExpired = await isAccessTokenExpired(accessToken);

      if (isTokenExpired) {
        // Token expired, try refreshing
        await refreshAccessToken();

        // Check again after refresh
        final String? newAccessToken = await getAccessToken();
        if (newAccessToken == null) {
          // Refresh failed, navigate to login
          print('NULL2');
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

Future<bool> isAccessTokenExpired(String accessToken) async {
  try {
    final Map<String, dynamic> decodedToken = json.decode(
      utf8.decode(base64Url.decode(
        accessToken.split('.')[1],
      )),
    );

    if (decodedToken.containsKey('exp')) {
      final int expirationTime = decodedToken['exp'];
      final int currentTimeInSeconds =
          DateTime.now().toUtc().millisecondsSinceEpoch ~/ 1000;

      return expirationTime < currentTimeInSeconds;
    }

    // If the token doesn't have an expiration claim, consider it expired
    return true;
  } catch (e) {
    // Handle decoding errors or missing claims
    print('Error decoding token: $e');
    return true;
  }
}

Future<String?> getAccessToken() async {
  // Retrieve the access token from secure storage
  return await storage.read(key: 'access_token');
}

Future<void> refreshAccessToken() async {
  try {
    final String? refreshToken = await storage.read(key: 'refresh_token');

    if (refreshToken != null) {
      final response = await http.post(
        Uri.parse(
            'http://10.0.2.2/token/refresh'), // Replace with your server's token refresh endpoint
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'refresh': refreshToken,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final String newAccessToken = responseData['access'];

        // Update the stored access token
        await storage.write(key: 'access_token', value: newAccessToken);

        print('New Access Token: $newAccessToken');
      } else {
        // Handle other refresh token response statuses
        print('Error refreshing access token: ${response.statusCode}');
      }
    } else {
      // No refresh token found, handle accordingly
      print('No refresh token found');
    }
  } catch (e) {
    // Handle refresh token request errors
    print('Error refreshing access token: $e');
  }
}
