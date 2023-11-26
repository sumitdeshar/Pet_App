class PetOwnerProfile {
  final int user; // Adjust fields based on your model
  final String phone_number;
  final String address;
  final List<dynamic> pet_info;

  PetOwnerProfile(
      {required this.user,
      required this.phone_number,
      required this.address,
      required this.pet_info});

  factory PetOwnerProfile.fromJson(Map<String, dynamic> json) {
    return PetOwnerProfile(
      user: json['user'],
      phone_number: json['phone_number'],
      address: json['address'],
      pet_info: List<dynamic>.from(json['pet_info']),
    );
  }
  factory PetOwnerProfile.fromMap(Map<String, dynamic> map) {
    return PetOwnerProfile.fromJson(map);
  }
}
