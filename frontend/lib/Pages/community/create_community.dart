import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:frontend/Pages/Community/list_community.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CommunityApplicationPage extends StatefulWidget {
  @override
  _CommunityApplicationPageState createState() =>
      _CommunityApplicationPageState();
}

class _CommunityApplicationPageState extends State<CommunityApplicationPage> {
  final TextEditingController _communityNameController =
      TextEditingController();
  final TextEditingController _communityDescriptionController =
      TextEditingController();
  bool _acceptedRules = false;
  var appBarTitle = 'Register Community';

  Future<void> submitCommunityApplication() async {
    final Map<String, dynamic> requestData = {
      'community_name': _communityNameController.text,
      'description': _communityDescriptionController.text,
    };
    final String? accessToken = await getAccessToken();

    try {
      final http.Response response = await http.post(
        Uri.parse('http://10.0.2.2:8000/community/create'),
        body: jsonEncode(requestData),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
      );

      if (response.statusCode == 200) {
        print('Community application successful!');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.thumb_up_outlined),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Text('Community application successful!'),
                ),
              ],
            ),
            duration: Duration(seconds: 5),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CommunityList()),
        );
      } else {
        print(
            'Community application failed with status code: ${response.statusCode}');
        print('Response body: ${response.body}');

        try {
          final Map<String, dynamic> errorData = jsonDecode(response.body);
          final errorMessage = errorData['error'] ?? 'Unknown error';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              duration: const Duration(seconds: 5),
            ),
          );
        } catch (error) {
          print('Error decoding JSON or extracting error message: $error');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed!'),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (error) {
      print('Error during community application: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: Scaffold(
        appBar: CustomAppBar(title: appBarTitle),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community Name',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _communityNameController,
                      decoration: InputDecoration(
                        hintText: 'Enter community name',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Community names, including capitalization, cannot be changed.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Community Description',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    TextFormField(
                      controller: _communityDescriptionController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Enter community description',
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Give context about what your community looks like.',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _acceptedRules,
                    onChanged: (value) {
                      setState(() {
                        _acceptedRules = value ?? false;
                      });
                    },
                  ),
                  Text('I accept the community rules'),
                ],
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      submitCommunityApplication();
                    },
                    child: Text('Submit Application'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
