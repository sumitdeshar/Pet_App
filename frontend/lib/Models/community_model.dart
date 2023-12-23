class CommunityDetail {
  final int id;
  final String name;
  final String description;
  final String creationDate;
  final String coverPhoto;
  final List<int> members;

  CommunityDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.creationDate,
    required this.coverPhoto,
    required this.members,
  });
}
