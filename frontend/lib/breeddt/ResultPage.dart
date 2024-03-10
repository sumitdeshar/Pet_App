import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class BreedDetectionPage extends StatefulWidget {
  const BreedDetectionPage({
    Key? key,
    this.dogBreed = '',
    this.dogProb = '',
    this.image,
  }) : super(key: key);

  final String dogBreed;
  final String dogProb;
  final File? image;

  @override
  State<BreedDetectionPage> createState() => _BreedDetectionPageState();
}

class _BreedDetectionPageState extends State<BreedDetectionPage> {
  final picker = ImagePicker();
  String dogBreed = '';
  String dogProb = '';
  var image;

  @override
  void initState() {
    super.initState();
    dogBreed = widget.dogBreed;
    dogProb = widget.dogProb;
    image = widget.image;
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(
      source: source,
      maxHeight: 300,
      maxWidth: 300,
    );

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (image == null) {
      // Handle case when no image is selected
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/breed_detection/detection'),
      );
      request.headers['Content-Type'] = 'multipart/form-data';
      request.files
          .add(await http.MultipartFile.fromPath('image', image!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());

        String breed = jsonResponse['prediction_result']['breed'];
        String accuracy =
            jsonResponse['prediction_result']['accuracy'].toString();

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(
              initialBreed: breed,
              accuracy: accuracy,
              initialImage: image,
            ),
          ),
        );
      } else {
        print('Failed to detect breed. Status code: ${response.statusCode}');
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print('Error during image upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            height: size.height * 0.4,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image != null
                      ? Image.file(image!).image
                      : AssetImage("assets/Images/dogphoto.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.35,
            height: size.height * 0.65,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    dogBreed.isNotEmpty ? dogBreed : "Enter Photo",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${dogProb.isNotEmpty ? dogProb : '%'} Accuracy",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildImageButton(
                        Icons.camera_alt,
                        Colors.yellow,
                        "Take Photo",
                        () => _getImage(ImageSource.camera),
                      ),
                      const SizedBox(width: 60),
                      _buildImageButton(
                        Icons.photo,
                        Colors.blue,
                        "Upload Photo",
                        () => _getImage(ImageSource.gallery),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageButton(
    IconData icon,
    Color color,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            side: const BorderSide(width: 2, color: Colors.grey),
            padding: const EdgeInsets.all(16.0),
          ),
          child: Icon(
            icon,
            size: 35,
            color: color,
          ),
          onPressed: onPressed,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        )
      ],
    );
  }
}

class ResultPage extends StatefulWidget {
  String initialBreed;
  String accuracy;
  File? initialImage;

  ResultPage({
    required this.initialBreed,
    required this.accuracy,
    required this.initialImage,
  });

  @override
  _ResultPageState createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
  late String breed;
  late File? image;

  @override
  void initState() {
    super.initState();
    breed = widget.initialBreed;
    image = widget.initialImage;
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(
      source: source,
      maxHeight: 300,
      maxWidth: 300,
    );

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path);
        _uploadImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _uploadImage() async {
    if (image == null) {
      // Handle case when no image is selected
      return;
    }

    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://10.0.2.2:8000/breed_detection/detection'),
      );
      request.headers['Content-Type'] = 'multipart/form-data';
      request.files
          .add(await http.MultipartFile.fromPath('image', image!.path));

      var response = await request.send();

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(await response.stream.bytesToString());

        String newBreed = jsonResponse['prediction_result']['breed'];
        String accuracy =
            jsonResponse['prediction_result']['accuracy'].toString();

        // Update the breed and accuracy values
        setState(() {
          breed = newBreed;
          widget.accuracy = accuracy;
        });
      } else {
        print('Failed to detect breed. Status code: ${response.statusCode}');
        print(await response.stream.bytesToString());
      }
    } catch (e) {
      print('Error during image upload: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            height: size.height * 0.4,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: image != null
                      ? Image.file(image!).image
                      : AssetImage("assets/Images/dogphoto.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            top: size.height * 0.35,
            height: size.height * 0.65,
            width: size.width,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(36.0),
                  topRight: Radius.circular(36.0),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    breed.isNotEmpty ? breed : "Breed Not found",
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${widget.accuracy.isNotEmpty ? widget.accuracy : '%'} Accuracy",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 90,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildImageButton(
                        Icons.camera_alt,
                        Colors.yellow,
                        "Take Photo",
                        () => _getImage(ImageSource.camera),
                      ),
                      const SizedBox(width: 60),
                      _buildImageButton(
                        Icons.photo,
                        Colors.blue,
                        "Upload Photo",
                        () => _getImage(ImageSource.gallery),
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildImageButton(
    IconData icon,
    Color color,
    String label,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            shape: const CircleBorder(),
            side: const BorderSide(width: 2, color: Colors.grey),
            padding: const EdgeInsets.all(16.0),
          ),
          child: Icon(
            icon,
            size: 35,
            color: color,
          ),
          onPressed: onPressed,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        )
      ],
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: BreedDetectionPage(),
    ),
  );
}