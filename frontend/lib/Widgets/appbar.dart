import 'package:flutter/material.dart';

class customAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  customAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: Color.fromARGB(255, 80, 196, 107),
      actions: [
        _buildDropDownMenu(context),
      ],
    );
  }

  Widget _buildDropDownMenu(BuildContext context) {
    return DropdownButton<String>(
      items: [
        DropdownMenuItem<String>(
          value: 'Settings',
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ),
        DropdownMenuItem<String>(
          value: 'Logout',
          child: ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Logout'),
          ),
        ),
      ],
      onChanged: (value) {
        switch (value) {
          case 'Settings':
            // Handle Settings
            break;
          case 'Logout':
            // Handle Logout
            // For example, you can navigate to the login screen
            Navigator.pushReplacementNamed(context, '/login');
            break;
        }
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
