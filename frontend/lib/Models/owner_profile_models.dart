class PetOwnerProfile {
  final User user;
  final List<Pet> pets;
  final String bio;
  final String photo;

  PetOwnerProfile({
    required this.user,
    required this.pets,
    required this.bio,
    required this.photo,
  });

  factory PetOwnerProfile.fromJson(Map<String, dynamic> json) {
    return PetOwnerProfile(
      user: User.fromJson(json['user']),
      pets: (json['pets'] as List<dynamic>)
          .map((petJson) => Pet.fromJson(petJson))
          .toList(),
      bio: json['bio'],
      photo: json['photo'],
    );
  }
}

class User {
  final String username;
  final String firstName;
  final String lastName;

  User({
    required this.username,
    required this.firstName,
    required this.lastName,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      firstName: json['first_name'],
      lastName: json['last_name'],
    );
  }
}

class Pet {
  final String id;
  final String name;
  final String species;
  final String breed;
  final int age;
  final String? petphoto; // Assuming it can be null

  Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.breed,
    required this.age,
    this.petphoto,
  });

  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'],
      name: json['name'],
      species: json['species'],
      breed: json['breed'],
      age: json['age'],
      petphoto: json['petphoto'],
    );
  }
}
