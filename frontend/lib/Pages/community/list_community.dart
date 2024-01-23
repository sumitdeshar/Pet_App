import 'package:flutter/material.dart';
import 'package:frontend/Constants/token_auth.dart';
import 'package:frontend/Models/community_model.dart';
import 'package:frontend/Pages/Community/community_home.dart';
import 'package:frontend/Pages/Community/create_community.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CommunityList extends StatefulWidget {
  const CommunityList({Key? key}) : super(key: key);

  @override
  State<CommunityList> createState() => _CommunityListState();
}

class _CommunityListState extends State<CommunityList> {
  List<CommunityDetail> communities = [];
  String appBarTitle = 'Community List You Are Involved In';

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
      appBar: CustomAppBar(title: appBarTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CommunityApplicationPage()),
                );
              },
              child: Text(
                'Create Community',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                ),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(vertical: 12.0, horizontal: 15.0),
                ),
                side: MaterialStateProperty.all(
                  const BorderSide(
                    width: 2.0,
                    color: Colors.blue,
                  ),
                ),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              itemCount: communities.length,
              itemBuilder: (context, index) {
                return CommunityCard(
                  community: communities[index],
                  onPressed: () =>
                      navigateToCommunityProfile(communities[index].id),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  void navigateToCommunityProfile(int communityId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CommunityProfilePage(communityId: communityId),
      ),
    );
  }
}

class CommunityCard extends StatelessWidget {
  final CommunityDetail community;
  final VoidCallback onPressed;

  CommunityCard({required this.community, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                community.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                community.description,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
