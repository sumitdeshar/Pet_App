import 'package:flutter/material.dart';

class PetOwnerProfile extends StatefulWidget {
  const PetOwnerProfile({super.key});

  @override
  State<PetOwnerProfile> createState() => _PetOwnerProfileState();
}

class _PetOwnerProfileState extends State<PetOwnerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pet Owner Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage(
                    'assets/pet_owner_image.jpg'), // Replace with the actual image path
              ),
              SizedBox(height: 16),
              Text(
                'Pet Lover',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Proud Owner of a Labrador Retriever',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 16),
              Text(
                'About Me:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'Passionate about animals and dedicated to providing the best care for my furry friend.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              Text(
                'My Pets:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildPetSegment('Buddy', 'Labrador Retriever'),
              _buildPetSegment('Whiskers', 'Persian Cat'),
              SizedBox(height: 16),
              Text(
                'Posts:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              _buildPostPreview(
                'Fun day at the park',
                'Enjoyed a lovely day outdoors with my furry friend! 🐾',
                'assets/fun_day_park.jpg',
              ),
              _buildPostPreview(
                'Pet grooming tips',
                'Sharing some tips for keeping your pets well-groomed. 🛁',
                'assets/pet_grooming_tips.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetSegment(String petName, String petBreed) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            petName,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            petBreed,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildPostPreview(
      String postTitle, String postPreview, String imagePath) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            postTitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            postPreview,
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Image.asset(
            imagePath,
            height: 150, // Adjust the height as needed
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}
