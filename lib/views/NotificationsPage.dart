import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationsPage extends StatelessWidget {
  final String userId;

  const NotificationsPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('giftlist')
            .where('owner', isEqualTo: userId)
            .where('status', isEqualTo: 'Pledged') // Fetch pledged gifts
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No notifications found.'));
          }

          final pledgedGifts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pledgedGifts.length,
            itemBuilder: (context, index) {
              final giftData = pledgedGifts[index].data() as Map<String, dynamic>;
              final pledger = giftData['pledger'] ?? 'Unknown';

              return ListTile(
                leading: const Icon(Icons.notifications, color: Colors.deepPurple),
                title: Text('Gift: ${giftData['name']}'),
                subtitle: Text('Pledged by: $pledger'),
                trailing: const Icon(Icons.arrow_forward_ios),
              );
            },
          );
        },
      ),
    );
  }
}
