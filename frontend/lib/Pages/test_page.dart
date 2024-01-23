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
    try {
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
    } catch (e) {
      // Handle exception
      print('Error fetching communities: $e');
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
            CreateCommunity(onPressed: () => navigateToCreateCommunity()),
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

  void navigateToCreateCommunity() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => CommunityApplicationPage()),
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

class CreateCommunity extends StatelessWidget {
  final VoidCallback onPressed;

  const CreateCommunity({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueGrey, width: 2.0),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.grey[200],
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 12.0, horizontal: 10.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Text(
                  "Create a community",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10.0),
            ElevatedButton(
              onPressed: () {
                // Uncomment the lines below once you have the Create_Post widget
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => const Create_Post()),
                // );
              },
              child: Text(
                'Create Post',
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
          ],
        ),
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
      margin: EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: onPressed,
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
