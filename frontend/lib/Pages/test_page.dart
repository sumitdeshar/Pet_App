import 'package:flutter/material.dart';

class Post {
  final String author;
  final String username;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  Post({
    required this.author,
    required this.username,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });
}

class Posts extends StatelessWidget {
  final List<Post> communityPosts;

  Posts({required this.communityPosts});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: ListView.builder(
        itemCount: communityPosts.length,
        itemBuilder: (context, index) {
          return CommunityPostCard(post: communityPosts[index]);
        },
      ),
    );
  }
}

class CommunityPostCard extends StatelessWidget {
  final Post post;

  CommunityPostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            post.imageUrl,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Posted by ${post.author}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Username: ${post.username}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  post.description,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
                Text(
                  'Created at: ${post.createdAt.toLocal()}',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 16),
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
    return Row(
      children: [
        Icon(icon, size: 20),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

// Sample data for community posts
List<Post> communityPosts = [
  Post(
    author: 'John Doe',
    username: 'user123',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
    imageUrl:
        'https://www.pinterest.com/pin/21251429480747181/', // Replace with actual image URL
    createdAt: DateTime.now().subtract(Duration(days: 1)),
  ),
  Post(
    author: 'Jane Doe',
    username: 'petlover45',
    description: 'Check out these adorable pictures of my pets! 🐾',
    imageUrl:
        'https://www.pinterest.com/pin/21251429480747181/', // Replace with actual image URL
    createdAt: DateTime.now().subtract(Duration(days: 2)),
  ),
  Post(
    author: 'Tech Guru',
    username: 'techguru',
    description:
        'Discussing the latest trends in technology. What are your thoughts?',
    imageUrl:
        'https://www.pinterest.com/pin/21251429480747181/', // Replace with actual image URL
    createdAt: DateTime.now().subtract(Duration(days: 3)),
  ),
  // Add more posts as needed
];
