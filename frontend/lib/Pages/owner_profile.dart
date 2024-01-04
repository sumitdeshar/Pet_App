// home_page.dart
import 'package:flutter/material.dart';
import 'package:frontend/Models/owner_profile_models.dart';
import 'package:frontend/Pages/community/list_community.dart';
import 'package:frontend/Pages/navigation/bottom_navigation_bar.dart';
import 'package:frontend/Pages/posts/post_detail.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PetOwnerProfile> ownProfile = [];
  bool isLoading = true;

  Future<void> _fetchProfileData() async {
    try {
      const String baseUrl = "http://10.0.2.2:8000/";
      final String? accessToken = await getAccessToken();

      if (accessToken != null) {
        var response = await http.get(
          Uri.parse(baseUrl),
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        );

        if (response.statusCode == 200) {
          dynamic responseData = jsonDecode(response.body);
          print(response.body);
          if (responseData is List) {
            ownProfile = responseData.map((profile) {
              return PetOwnerProfile.fromJson(profile);
            }).toList();
          } else if (responseData is Map<String, dynamic>) {
            ownProfile = [
              PetOwnerProfile.fromJson(responseData),
            ];
          }
          setState(() {
            isLoading = false;
          });
        } else {
          throw Future.error('Failed to load profile: ${response.statusCode}');
        }
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error fetching profile: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfilePicture(),
            const SizedBox(height: 16),
            _buildUserInfo(),
            const SizedBox(height: 16),
            _buildPetsSection(),
            const SizedBox(height: 16),
            // Add the button to navigate to the community list
            ElevatedButton(
              onPressed: () {
                // Navigate to the community list screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CommunityList()),
                );
              },
              child: const Text('View Community List'),
            ),
            const SizedBox(height: 16),
            _buildPostsSection(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildProfilePicture() {
    return _buildPostImage(ownProfile.isNotEmpty ? ownProfile[0].photo : '');
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username: ${ownProfile.isNotEmpty ? ownProfile[0].user.username : ''}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          'BIO: ${ownProfile.isNotEmpty ? ownProfile[0].bio : ''}',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildPetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'My Pets:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (ownProfile.isNotEmpty && ownProfile[0].pets.isNotEmpty)
          ...ownProfile[0].pets.map((pet) => _buildPetSegment(pet)),
      ],
    );
  }

  Widget _buildPetSegment(Pet pet) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPetPicture(pet.petphoto),
          Text(
            'Pet Name: ${pet.name}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'Species: ${pet.species}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Breed: ${pet.breed}',
            style: const TextStyle(fontSize: 16),
          ),
          Text(
            'Age: ${pet.age}',
            style: const TextStyle(fontSize: 16),
          ),
          // You can add more pet details as needed
        ],
      ),
    );
  }

  Widget _buildPetPicture(imgpath) {
    return _buildPostImage(imgpath);
  }

  Widget _buildPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Posts:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // Build post previews with GestureDetector for tapping
        GestureDetector(
          onTap: () {
            // Navigate to the full post view
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PostDetailScreen(
                  postTitle: 'Fun day at the park',
                  postContent:
                      'Enjoyed a lovely day outdoors with my furry friend! 🐾',
                  imagePath:
                      'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
                ),
              ),
            );
          },
          child: _buildPostPreview(
            'Fun day at the park',
            'Enjoyed a lovely day outdoors with my furry friend! 🐾',
            'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl-2.jpg',
          ),
        ),
        GestureDetector(
          onTap: () {
            // Navigate to the full post view
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PostDetailScreen(
                  postTitle: 'Pet grooming tips',
                  postContent:
                      'Sharing some tips for keeping your pets well-groomed. 🛁',
                  imagePath: 'images/101.jpg',
                ),
              ),
            );
          },
          child: _buildPostPreview(
            'Pet grooming tips',
            'Sharing some tips for keeping your pets well-groomed. 🛁',
            'images/101.jpg',
          ),
        ),
      ],
    );
  }

  Widget _buildPostPreview(
      String postTitle, String postPreview, String imagePath) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            postTitle,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            postPreview,
            style: const TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          _buildPostImage(imagePath),
        ],
      ),
    );
  }

  Widget _buildPostImage(String imagePath) {
    if (imagePath.startsWith('http')) {
      // Network image
      return CachedNetworkImage(
        imageUrl: imagePath,
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => Icon(Icons.error),
        height: 150, // Adjust the height as needed
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else if (imagePath.startsWith('images')) {
      // Local asset image
      return Image.asset(
        imagePath,
        height: 150, // Adjust the height as needed
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      // Placeholder or error widget for unsupported image sources
      return Container(
        color: Colors.grey,
        height: 150,
        width: double.infinity,
        child: const Center(
          child: Text('Unsupported image source'),
        ),
      );
    }
  }
}
