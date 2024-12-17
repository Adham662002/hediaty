import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'giftlist.dart';  // Import Gift List Page

class EventListPage extends StatelessWidget {
  final String userId;
  final String friendId;

  const EventListPage({
    Key? key,
    required this.userId,
    required this.friendId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Friend\'s Events'),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard, color: Colors.white),
            onPressed: () {
              // Navigate to the GiftListPage of the selected friend
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GiftListPage(userId: userId, friendId: friendId),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('events')
            .where('owner', isEqualTo: friendId) // Fetch events for this friend
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No events found for this friend.'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final eventData = event.data() as Map<String, dynamic>;

              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text(
                    eventData['name'],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Text(
                    'Date: ${eventData['date']} \nLocation: ${eventData['location']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  trailing: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
                  onTap: () {
                    // On event tap, navigate to the Gift List of the friend
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftListPage(userId: userId, friendId: friendId),
                      ),
                    );
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
