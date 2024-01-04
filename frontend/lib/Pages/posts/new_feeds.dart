import 'package:flutter/material.dart';
import 'package:frontend/Pages/navigation/bottom_navigation_bar.dart';
import 'package:frontend/Pages/posts/create_post.dart';
import 'package:frontend/Widgets/appbar.dart';

class NewsFeed extends StatefulWidget {
  @override
  State<NewsFeed> createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  TextEditingController postTextController = TextEditingController();
  String appBarTitle = 'New Feed';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppBar(title: appBarTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            createPost(),
            const SizedBox(height: 16),
            viewPosts(),
            const SizedBox(height: 16),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget createPost() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Create_Post()),
              );
            },
            child: const Text('Create Post'),
          ),
        ],
      ),
    );
  }

  Widget viewPosts() {
    return Container();
  }
}
