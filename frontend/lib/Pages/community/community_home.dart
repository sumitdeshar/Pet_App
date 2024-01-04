import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Models/community_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:frontend/Widgets/appbar.dart';

class CommunityProfilePage extends StatefulWidget {
  final int communityId;

  const CommunityProfilePage({Key? key, required this.communityId})
      : super(key: key);

  @override
  _CommunityProfilePageState createState() => _CommunityProfilePageState();
}

class _CommunityProfilePageState extends State<CommunityProfilePage> {
  CommunityDetail? communityData;

  @override
  void initState() {
    super.initState();
    fetchCommunity();
  }

  Future<void> fetchCommunity() async {
    final String? accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/community/${widget.communityId}'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body)['data'];
      print(data);
      setState(() {
        communityData = CommunityDetail(
          id: data['id'],
          name: data['community_name'],
          description: data['description'],
          creationDate: data['creation_date'],
          coverPhoto: data['cover_photo'] ?? '',
          members: List<int>.from(data['members']),
        );
      });
    } else {
      // Handle error
      print('Failed to fetch community: ${response.statusCode}');
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: ''),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCommunityPicture(),
            const SizedBox(height: 16),
            _buildcommunityInfo(),
            SizedBox(height: 8),
            if (communityData != null)
              for (int memberId in communityData!.members)
                _buildMemberSegment('User $memberId'),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to the community list screen
              },
              child: const Text('View Community List'),
            ),
            Text(
              'Posts:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            const SizedBox(height: 16),
            _buildPost(
              'Latest Tech Trends',
              'Exploring the advancements in AI and machine learning.',
              'images/101.jpg',
            ),
            _buildPost(
              'Programming Tips',
              'Sharing useful tips for efficient coding practices.',
              'images/101.jpg',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCommunityPicture() {
    return _buildPostImage(
        communityData?.coverPhoto ?? 'assets/community_image.jpg');
  }

  Widget _buildcommunityInfo() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey)),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            communityData?.name ?? '',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            communityData?.description ?? '',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          )
        ]));
  }

  Widget _buildMemberSegment(String memberName) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Text(
        memberName,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildPost(String postTitle, String postContent, String imagePath) {
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
            postContent,
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
