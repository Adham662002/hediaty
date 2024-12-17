import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GiftListPage extends StatelessWidget {
  final String userId;
  final String friendId;

  const GiftListPage({
    Key? key,
    required this.userId,
    required this.friendId, // Accept friendId
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift List'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('giftlist')
            .where('owner', isEqualTo: friendId) // Fetch gifts for this friend
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No gifts found for this friend.'));
          }

          final gifts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    gift['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Text(
                    'Category: ${gift['category']} \nStatus: ${gift['status']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
                  onTap: () {
                    // Optionally navigate to gift details if needed
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
