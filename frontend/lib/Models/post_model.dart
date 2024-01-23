class Post {
  final String id;
  final String author;
  final String username;
  final String description;
  final String imageUrl;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.author,
    required this.username,
    required this.description,
    required this.imageUrl,
    required this.createdAt,
  });
}
