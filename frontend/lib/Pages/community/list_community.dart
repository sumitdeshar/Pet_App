import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Models/community_model.dart';
import 'package:frontend/Pages/community/community_home.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommunityList extends StatefulWidget {
  const CommunityList({Key? key}) : super(key: key);

  @override
  State<CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  List<CommunityDetail> communities = [];

  @override
  void initState() {
    super.initState();

    fetchCommunities();
  }

  Future<void> fetchCommunities() async {
    final String? accessToken = await getAccessToken();
    final response = await http.get(
      Uri.parse('http://10.0.2.2:8000/community/'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['data'];
      setState(() {
        communities = data.map((communityData) {
          return CommunityDetail(
            id: communityData['id'],
            name: communityData['community_name'],
            description: communityData['description'],
            creationDate: communityData['creation_date'],
            coverPhoto: communityData['cover_photo'] ?? '',
            members: List<int>.from(communityData['members']),
          );
        }).toList();
      });
    } else {
      // Handle error
      print('Failed to fetch communities: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community Management'),
      ),
      body: ListView.builder(
        itemCount: communities.length,
        itemBuilder: (context, index) {
          return CommunityCard(community: communities[index]);
        },
      ),
    );
  }
}

class CommunityCard extends StatelessWidget {
  final CommunityDetail community;

  CommunityCard({required this.community});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CommunityProfilePage(
                communityId: community.id,
              ),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                community.name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                community.description,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
