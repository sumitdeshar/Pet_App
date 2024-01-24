import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class Create_Post extends StatefulWidget {
  final int communityId;

  const Create_Post({Key? key, required this.communityId}) : super(key: key);

  @override
  State<Create_Post> createState() => _Create_PostState();
}

class _Create_PostState extends State<Create_Post> {
  TextEditingController postTextController = TextEditingController();
  var appBarTitle = 'Create Post';
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  Future<void> _createPost() async {
    try {
      const String baseUrl = "http://10.0.2.2:8000/posts/create";
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        print(widget.communityId);

        String content = await postTextController.text;

        if (_selectedImage == null) {
          print('No image selected');
          return;
        }

        List<int> imageBytes = await _selectedImage!.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        print('Base64 Image: $base64Image');

        int communityId = await widget.communityId;
        String dynamicFileName =
            'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';

        var request = http.MultipartRequest('POST', Uri.parse(baseUrl))
          ..headers['Authorization'] = 'Bearer $accessToken'
          ..headers['Content-Type'] = 'multipart/form-data'
          ..fields['content'] = content
          ..fields['community'] = communityId.toString()
          ..files.add(http.MultipartFile(
            'photo',
            http.ByteStream.fromBytes(imageBytes),
            imageBytes.length,
            filename: dynamicFileName,
          ));

        var response = await http.Response.fromStream(await request.send());
        print('Server response: ${response.statusCode}, ${response.body}');

        if (response.statusCode == 200) {
          dynamic responseData = jsonDecode(response.body);
          print('Server response: ${response.statusCode}, ${response.body}');
          print(responseData);
        } else {
          throw Exception(
            'Failed to create post. Status code: ${response.statusCode}, Response: ${response.body}',
          );
        }
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error creating post: $e');
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _selectedImage = File(pickedFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: appBarTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: createPosts(),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget createPosts() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blueGrey, width: 2.0),
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25), // Color of the shadow
            spreadRadius: 2, // Spread radius
            blurRadius: 5, // Blur radius
            offset: const Offset(0, 3), // Changes position of shadow
          ),
        ],
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
              hintText: "What's on your mind?",
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: const BorderSide(
                  width: 2.0, // Adjust border width
                  color: Colors.purple,
                ),
              ),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const SizedBox(
                height: 8,
                width: 12,
              ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.gallery),
                icon: const Icon(Icons.image),
                label: const Text('Gallery'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
              ),
              const SizedBox(
                height: 8,
                width: 12,
              ),
              ElevatedButton.icon(
                onPressed: () => _pickImage(ImageSource.camera),
                icon: const Icon(Icons.camera),
                label: const Text('Camera'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
              _createPost();
              print('Done');
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }
}
