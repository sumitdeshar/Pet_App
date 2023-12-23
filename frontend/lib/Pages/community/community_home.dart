import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Models/community_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                  communityData?.coverPhoto ?? 'assets/community_image.jpg',
                ),
              ),
              SizedBox(height: 16),
              Text(
                communityData?.name ?? '',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Text(
                'About Community:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                communityData?.description ?? '',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'Members:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              if (communityData != null)
                for (int memberId in communityData!.members)
                  _buildMemberSegment('User $memberId'),
              SizedBox(height: 16),
              Text(
                'Posts:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildPostPreview(
                'Latest Tech Trends',
                'Exploring the advancements in AI and machine learning.',
              ),
              //   'assets/latest_tech_trends.jpg',
              // _buildPostPreview(
              //   'Programming Tips',
              //   'Sharing useful tips for efficient coding practices.',
              //   'assets/programming_tips.jpg',
              // ),
            ],
          ),
        ),
      ),
    );
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

  Widget _buildPostPreview(String postTitle, String postPreview) {
    //, String imagePath
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            postTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            postPreview,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          // SizedBox(height: 8),
          // Image.asset(
          //   imagePath,
          //   height: 150,
          //   width: double.infinity,
          //   fit: BoxFit.cover,
          // ),
        ],
      ),
    );
  }
}
