import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'giftList.dart'; // Import GiftListPage

class EventListPage extends StatelessWidget {
  final String userId;
  final String friendId; // Added friendId to filter events by friend

  const EventListPage({Key? key, required this.userId, required this.friendId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Events',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId) // Use the passed userId here
            .collection('friends')
            .doc(friendId) // Filter events by specific friend
            .collection('events')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No events found.'));
          }

          final events = snapshot.data!.docs;

          return ListView.builder(
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final eventData = event.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    eventData['name'] ?? 'Unnamed Event',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.teal[800],
                    ),
                  ),
                  subtitle: Text(
                    '${eventData['category']} - ${eventData['status']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          _editEventDialog(context, event.id, userId, eventData);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection('friends')
                              .doc(friendId) // Delete event for the specific friend
                              .collection('events')
                              .doc(event.id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftListPage(
                          userId: userId,
                          eventId: event.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          _addEventDialog(context, userId, friendId);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addEventDialog(BuildContext context, String userId, String friendId) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final statusController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final category = categoryController.text.trim();
                final status = statusController.text.trim();

                if (name.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('friends')
                      .doc(friendId) // Add event for the specific friend
                      .collection('events')
                      .add({
                    'name': name,
                    'category': category,
                    'status': status,
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _editEventDialog(BuildContext context, String eventId, String userId, Map<String, dynamic> eventData) {
    final nameController = TextEditingController(text: eventData['name']);
    final categoryController = TextEditingController(text: eventData['category']);
    final statusController = TextEditingController(text: eventData['status']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
              ),
              TextField(
                controller: statusController,
                decoration: const InputDecoration(labelText: 'Status'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                final category = categoryController.text.trim();
                final status = statusController.text.trim();

                if (name.isNotEmpty) {
                  await FirebaseFirestore.instance
                      .collection('users')
                      .doc(userId)
                      .collection('friends')
                      .doc(friendId) // Edit event for the specific friend
                      .collection('events')
                      .doc(eventId)
                      .update({
                    'name': name,
                    'category': category,
                    'status': status,
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
