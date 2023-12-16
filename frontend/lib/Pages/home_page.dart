// home_page.dart
import 'package:flutter/material.dart';
import 'package:frontend/Models/models.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

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
      appBar: customAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfilePicture(),
            SizedBox(height: 16),
            _buildUserInfo(),
            SizedBox(height: 16),
            _buildPetsSection(),
            SizedBox(height: 16),
            _buildPostsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePicture() {
    return CircleAvatar(
      radius: 70,
      //   backgroundImage: ownProfile.isNotEmpty
      //       ? NetworkImage(ownProfile[0].photo)
      //       : const AssetImage('images/101.jpg'),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username: ${ownProfile.isNotEmpty ? ownProfile[0].user.username : ''}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text(
          'BIO: ${ownProfile.isNotEmpty ? ownProfile[0].bio : ''}',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  Widget _buildPetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Pets:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        if (ownProfile.isNotEmpty && ownProfile[0].pets.isNotEmpty)
          ...ownProfile[0].pets.map((pet) => _buildPetSegment(pet)),
      ],
    );
  }

  Widget _buildPetSegment(Pet pet) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pet Name: ${pet.name}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'Species: ${pet.species}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Breed: ${pet.breed}',
            style: TextStyle(fontSize: 16),
          ),
          Text(
            'Age: ${pet.age}',
            style: TextStyle(fontSize: 16),
          ),
          // You can add more pet details as needed
        ],
      ),
    );
  }

  Widget _buildPostsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Posts:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        // Build post previews
        _buildPostPreview(
          'Fun day at the park',
          'Enjoyed a lovely day outdoors with my furry friend! 🐾',
          'assets/fun_day_park.jpg',
        ),
        _buildPostPreview(
          'Pet grooming tips',
          'Sharing some tips for keeping your pets well-groomed. 🛁',
          'images/101.jpg',
        ),
      ],
    );
  }

  Widget _buildPostPreview(
      String postTitle, String postPreview, String imagePath) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            postTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            postPreview,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Image.asset(imagePath,
              height: 150, // Adjust the height as needed
              width: double.infinity,
              fit: BoxFit.cover)
        ]));
  }
}
