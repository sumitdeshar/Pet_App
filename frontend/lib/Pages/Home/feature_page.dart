import 'package:flutter/material.dart';
import 'package:frontend/Widgets/bottom_navigation_bar.dart';
import 'package:frontend/Widgets/appbar.dart';
import 'package:frontend/breeddt/breed_detection.dart';

class FeaturesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Features',
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureBox(
                  context,
                  Icons.healing,
                  'Symptom Analysis',
                  SymptomAnalysisScreen(),
                ),
                _buildFeatureBox(
                  context,
                  Icons.pets,
                  'Breed Detection',
                  BreedDetectionPage(),
                ),
              ],
            ),
            const SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFeatureBox(
                  context,
                  Icons.home,
                  'Adoption and Shelter',
                  AdoptionScreen(),
                ),
                _buildFeatureBox(
                  context,
                  Icons.notifications,
                  'Scheduling',
                  SchedulingScreen(),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(),
    );
  }

  Widget _buildFeatureBox(
    BuildContext context,
    IconData icon,
    String text,
    Widget screen,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
      child: Container(
        width: 160.0, // Increased width for a better aspect ratio
        height: 160.0, // Increased height for a better aspect ratio
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(
              20.0), // Increased border radius for a softer look
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48.0,
              color: Colors.blue,
            ),
            const SizedBox(
                height: 12.0), // Increased spacing between icon and text
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8.0), // Added padding for text
                child: Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // Center-aligned the text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Replace these with your actual screen widgets
class SymptomAnalysisScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Symptom Analysis')),
      body: Center(child: Text('Symptom Analysis Screen')),
    );
  }
}

class BreedDetectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Breed Detection')),
      body: Center(child: Text('Breed Detection Screen')),
    );
  }
}

class AdoptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Adoption and Shelter')),
      body: Center(child: Text('Adoption and Shelter Screen')),
    );
  }
}

class SchedulingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scheduling')),
      body: Center(child: Text('Scheduling Screen')),
    );
  }
}
