// PostDetailScreen.dart

import 'package:flutter/material.dart';

class PostDetailScreen extends StatelessWidget {
  final String postTitle;
  final String postContent;
  final String imagePath;

  const PostDetailScreen({
    required this.postTitle,
    required this.postContent,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              postTitle,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              postContent,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            SizedBox(height: 16),
            Image.asset(
              imagePath,
              height: 200, // Adjust the height as needed
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ],
        ),
      ),
    );
  }
}
