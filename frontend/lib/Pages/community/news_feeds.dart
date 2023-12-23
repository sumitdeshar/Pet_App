import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key, required int community_id});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Community'),
      ),
      body: Column(
        children: [
          // Create Post Container
          Container(
            padding: EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Create a New Post',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.edit),
              ],
            ),
          ),
          // Community Posts
          Expanded(
            child: ListView.builder(
              itemCount: communityPosts.length,
              itemBuilder: (context, index) {
                return CommunityPostCard(post: communityPosts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CommunityPost {
  final String title;
  final String username;
  final String content;
  final String imageUrl;

  CommunityPost({
    required this.title,
    required this.username,
    required this.content,
    required this.imageUrl,
  });
}

class CommunityPostCard extends StatelessWidget {
  final CommunityPost post;

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
                  post.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  'Posted by ${post.username}',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  post.content,
                  style: TextStyle(fontSize: 16),
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
List<CommunityPost> communityPosts = [
  CommunityPost(
    title: 'Exciting News!',
    username: 'user123',
    content: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit...',
    imageUrl:
        'https://www.pinterest.com/pin/21251429480747181/', // Replace with actual image URL
  ),
  CommunityPost(
    title: 'New Pet Photos!',
    username: 'petlover45',
    content: 'Check out these adorable pictures of my pets! 🐾',
    imageUrl:
        'https://www.pinterest.com/pin/21251429480747181/', // Replace with actual image URL
  ),
  CommunityPost(
    title: 'Tech Talk',
    username: 'techguru',
    content:
        'Discussing the latest trends in technology. What are your thoughts?',
    imageUrl:
        'https://www.pinterest.com/pin/21251429480747181/', // Replace with actual image URL
  ),
  // Add more posts as needed
];
