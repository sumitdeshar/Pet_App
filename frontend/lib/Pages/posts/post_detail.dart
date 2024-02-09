// PostDetailScreen.dart

import 'package:cached_network_image/cached_network_image.dart';
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
            _buildPostImage(imagePath),
          ],
        ),
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
