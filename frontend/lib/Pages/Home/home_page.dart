// home_page.dart
import 'package:flutter/material.dart';
import 'package:frontend/Models/owner_profile_models.dart';
import 'package:frontend/Pages/Community/list_community.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'package:frontend/Pages/posts/post_detail.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:frontend/Models/post_model.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PetOwnerProfile> ownProfile = [];
  bool isLoading = true;
  late String user;
  String appBarTitle = '';
  List<PostModel> posts = [];

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

          user = ownProfile.isNotEmpty ? ownProfile[0].user.username : '';
          appBarTitle = "$user's Profile";

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

  Future<void> fetchPosts() async {
    try {
      const String baseUrl = "http://10.0.2.2:8000/posts/";
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
          List<dynamic> responseData = jsonDecode(response.body);
          print(responseData);

          posts = responseData.map((jsonpost) {
            return PostModel.fromJson(jsonpost);
          }).toList();

          setState(() {
            isLoading = false;
          });
        } else {
          throw Future.error('Failed to load posts: ${response.statusCode}');
        }
      } else {
        print('Access token is null');
      }
    } catch (e) {
      print('Error fetching posts: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
    fetchPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: appBarTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfilePicture(),
            const SizedBox(height: 16),
            _buildUserInfo(),
            const SizedBox(height: 16),
            _FollowSection(),
            const SizedBox(height: 16),
            _buildPetsSection(),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CommunityList()),
                );
              },
              child: const Text('View Community List'),
            ),
            const SizedBox(height: 16),
            _buildPostsSection(posts),
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
    // Extract the first profile (if available)
    final profile = ownProfile.isNotEmpty ? ownProfile[0] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (profile != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${profile.user.firstName}',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    ' ',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${profile.user.lastName}',
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '${profile.user.username}',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                '${profile.bio}',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ElevatedButton(
          onPressed: () {},
          child: const Row(
            children: [
              Icon(Icons.add),
              SizedBox(width: 6),
              Text('Follow'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _FollowSection() {
    final profile = ownProfile.isNotEmpty ? ownProfile[0] : null;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('Following'),
        Text(
          '${profile != null ? profile.following.length : 0}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text('Followers'),
        Text(
          '${profile != null ? profile.followers.length : 0}',
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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

  Widget _buildPostsSection(List<PostModel> posts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Posts:',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        for (var post in posts)
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PostDetailScreen(
                    postTitle: post.description,
                    postContent:
                        "${post.createdAt.year}-${post.createdAt.month}-${post.createdAt.day}",
                    imagePath: post.imageUrl,
                  ),
                ),
              );
            },
            child: _buildPostPreview(
              post.description,
              post.createdAt,
              post.imageUrl,
              post.author[0].username,
            ),
          ),
      ],
    );
  }

  Widget _buildPostPreview(
    String postTitle,
    DateTime createdAt,
    String imagePath,
    String author,
  ) {
    String formattedDate =
        "${createdAt.year}-${createdAt.month}-${createdAt.day}";

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
            formattedDate,
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
      return AspectRatio(
        aspectRatio: 9 / 10,
        child: CachedNetworkImage(
          imageUrl: imagePath,
          placeholder: (context, url) => const CircularProgressIndicator(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          fit: BoxFit.fill,
        ),
      );
    } else if (imagePath.startsWith('images')) {
      // Local asset image
      return AspectRatio(
        aspectRatio: 9 / 10,
        child: Image.asset(
          imagePath,
          fit: BoxFit.fill,
        ),
      );
    } else {
      return Container(
        color: Colors.grey,
        child: const Center(
          child: Text('Unsupported image source'),
        ),
      );
    }
  }
}
