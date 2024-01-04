import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Pages/navigation/bottom_navigation_bar.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class Create_Post extends StatefulWidget {
  const Create_Post({super.key});

  @override
  State<Create_Post> createState() => _Create_PostState();
}

class _Create_PostState extends State<Create_Post> {
  TextEditingController postTextController = TextEditingController();
  var appBarTitle = 'New Feed';
  File? _selectedImage;

  Future<void> _createPost() async {
    try {
      const String baseUrl = "http://10.0.2.2:8000/posts/create";
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        var response = await http.post(
          Uri.parse(baseUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'description': postTextController.text,
            // Add additional fields as needed
          }),
        );

        if (response.statusCode == 200) {
          dynamic responseData = jsonDecode(response.body);
          print(responseData);
          // Handle successful response, if needed
        } else {
          throw Future.error('Failed to create post: ${response.statusCode}');
        }
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    print(pickedImage);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<void> _pickImageCamera() async {
    final picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.camera);
    print(pickedImage);

    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: appBarTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: createPosts(),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget createPosts() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create a Post',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: postTextController,
            decoration: InputDecoration(
              hintText: 'What\'s on your mind?',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo),
                label: const Text('Photo'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Change the button color
                  onPrimary: Colors.white, // Change the text color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Adjust the border radius
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20), // Adjust padding
                ),
              ),
              ElevatedButton.icon(
                onPressed: _pickImageCamera,
                icon: const Icon(Icons.photo),
                label: const Text('Camera'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green, // Change the button color
                  onPrimary: Colors.white, // Change the text color
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8.0), // Adjust the border radius
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20), // Adjust padding
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _selectedImage != null
              ? Image.file(_selectedImage!)
              : const Text("Please select an Image to upload"),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              print('Done');
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
