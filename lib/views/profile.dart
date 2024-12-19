import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'NotificationsPage.dart';
import 'pledgedgifts.dart';

class MyProfilePage extends StatelessWidget {
  final String userId;

  const MyProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance.collection('users').doc(userId).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.data() == null) {
            return const Center(child: Text('User data not found.'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Name',
                    value: userData['username'] ?? 'No name provided',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Email',
                    value: userData['email'] ?? 'No email provided',
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Password',
                    value: '**********', // Masked for privacy
                    isReadOnly: true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    label: 'Phone Number',
                    value: userData['phone'] ?? 'No phone number provided',
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.card_giftcard),
                    label: const Text(
                      'My Pledged Gifts',
                      style: TextStyle(fontSize: 18),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MyPledgedGiftsPage(userId: userId),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String value,
    bool isReadOnly = true,
  }) {
    return TextField(
      readOnly: isReadOnly,
      controller: TextEditingController(text: value),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      style: const TextStyle(fontSize: 18),
    );
  }
}
