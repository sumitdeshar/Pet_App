import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Models/post_model.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class NewsFeed extends StatefulWidget {
  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  List<PostModel> posts = [];
  bool isLoading = true;
  String appBarTitle = 'New Feeds';

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
            const Text(
              'Posted by',
              style: TextStyle(color: Colors.black),
            ),
            const SizedBox(height: 16),
            viewPosts(),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget viewPosts() {
    return SingleChildScrollView(
      child: Column(
        children: posts.map((post) => _buildPostCard(post)).toList(),
      ),
    );
  }

  Widget _buildPostCard(PostModel post) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.description,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Posted by ${post.author.isNotEmpty ? post.author.first.username : ''}',
                  style: const TextStyle(color: Colors.grey),
                ),
                // const SizedBox(height: 16),
                // _buildPostImage(post.imageUrl),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildActionButton(icon: Icons.thumb_up, label: 'Upvote'),
                    _buildActionButton(icon: Icons.comment, label: 'Comment'),
                    _buildActionButton(icon: Icons.share, label: 'Share'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label}) {
    return Column(
      children: [
        Icon(icon),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
