import 'package:flutter/material.dart';
import 'package:frontend/Pages/Community/create_community.dart';
import 'package:frontend/Pages/Home/home_page.dart';
import 'package:frontend/Pages/posts/new_feeds.dart';

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          label: 'Home',
          icon: Icon(Icons.home, color: Colors.green, size: 24.0),
        ),
        BottomNavigationBarItem(
          label: 'Profile',
          icon: Icon(Icons.person, color: Colors.grey, size: 24.0),
        ),
        BottomNavigationBarItem(
          label: 'Create',
          icon: Icon(Icons.add_outlined, color: Colors.grey, size: 24.0),
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => NewsFeed()),
            );
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MyHomePage(
                        title: 'Profile',
                      )),
            );
            break;
          case 2:
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => CommunityApplicationPage()),
            );
            break;
        }
      },
    );
  }
}
