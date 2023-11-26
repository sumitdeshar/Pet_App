// home_page.dart
import 'package:flutter/material.dart';
import 'package:hellopet/Models/models.dart';
import 'package:hellopet/Constants/api.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PetOwnerProfile> ownProfile = [];

  Future<void> _fetchProfileData() async {
    try {
      Profile profileInstance = Profile();
      List<dynamic> profileData = await profileInstance.getProfile();

      profileData.forEach((profile) {
        PetOwnerProfile p = PetOwnerProfile(
          user: profile['user'],
          phone_number: profile['phone_number'],
          address: profile['address'],
          pet_info: List<int>.from(profile['pet_info']),
        );
        ownProfile.add(p);
      });
    } catch (e) {
      print('Error fetching profile: $e');
      // Handle the error as needed
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.blue,
      ),
      body: FutureBuilder<void>(
        // Use ownProfile instead of profileData here
        future: _fetchProfileData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (ownProfile.isEmpty) {
            return Center(
              child: Text('No data available'),
            );
          } else {
            return ListView.builder(
              itemCount: ownProfile.length,
              itemBuilder: (context, index) {
                final profile = ownProfile[index];
                return ListTile(
                  title: Text('User: ${profile.user}'),
                  subtitle: Text('Phone: ${profile.phone_number}'),
                );
              },
            );
          }
        },
      ),
    );
  }
}


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//         backgroundColor: Colors.blue,
//       ),
//       body: Container(
//         child: FutureBuilder<List<Map<String, dynamic>>>(
//           future: profileRetrieve.getProfile(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(
//                 child: CircularProgressIndicator(),
//               );
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text('Error: ${snapshot.error}'),
//               );
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return Center(
//                 child: Text('No data available'),
//               );
//             } else {
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 itemBuilder: (context, i) {
//                   final profileData = snapshot.data![i];
//                   return Card(
//                     child: ListTile(
//                       title: Text(
//                         'Name: ${profileData["user"]}',
//                         style: TextStyle(fontSize: 20.0),
//                       ),
//                       subtitle: Text(
//                         'Phone: ${profileData["phone_number"]}',
//                         style: TextStyle(fontSize: 16.0),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }
//           },
//         ),
//       ),
//     );
//   }
// }
