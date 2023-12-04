// home_page.dart
import 'package:flutter/material.dart';
import 'package:hellopet/Models/models.dart';
import 'package:hellopet/Constants/api.dart';
import 'package:hellopet/Widgets/appbar.dart';
import 'package:hellopet/Widgets/container.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<PetOwnerProfile> ownProfile = [];
  bool isLoading = true;

  Future<void> _fetchProfileData() async {
    try {
      Profile profileInstance = Profile();
      List<dynamic> profileData = await profileInstance.getProfile();

      ownProfile = profileData.map((profile) {
        return PetOwnerProfile(
          user: profile['user'],
          phone_number: profile['phone_number'],
          address: profile['address'],
          pet_info: profile['pet_info'] != null
              ? List<int>.from(profile['pet_info'])
              : [],
        );
      }).toList();
      setState(() {
        isLoading = false;
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
        appBar: customAppBar(),
        body: isLoading
            ? CircularProgressIndicator()
            : ListView(
                children: ownProfile.map((profile) {
                  return ProfileContainer(
                    user: profile.user,
                    phone_number: profile.phone_number,
                    address: profile.address,
                    pet_info: profile.pet_info,
                  );
                }).toList(),
              ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 4 / 5,
                      color: const Color.fromARGB(255, 140, 172, 226),
                      child: const Center(
                        child: Column(
                          children: [
                            Text('Profile',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: TextField(
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'User Name',
                                          hintText: 'Enter Your Name',
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(15),
                                      child: TextField(
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Password',
                                          hintText: 'Enter Password',
                                        ),
                                      ),
                                    ),
                                  ],
                                ))
                          ],
                        ),
                      ),
                    );
                  });
            },
            child: const Icon(
              Icons.add,
            )));
  }
}
