import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[900],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Personal Information'),
            onTap: () {},
            subtitle: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.lock),
                  ),
                  obscureText: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) =>  PledgedGiftsPage()),
              // );

              // Navigate to the Pledged Gifts page when the button is pressed
            },
            child: const Text('Pledged Gifts'),
          ),
          const Divider(),
          ListTile(
            title: const Text('Notification Settings'),
            onTap: () {},
            subtitle: SwitchListTile(
              activeColor: Colors.white,
              activeTrackColor: Colors.black87,
              title: const Text('Notify when someone plugs into my events'),
              value: true,
              onChanged: (bool value) {},
            ),
          ),
          const Divider(),
          ListTile(
            title: const Text('My pledged gifts'),
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) =>  PledgedGiftsPage()),
              // );
            },
          ),
        ],
      ),
    );
  }
}
