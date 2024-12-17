import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'giftdetails.dart';

class GiftListPage extends StatelessWidget {
  final String userId;
  final String eventId;

  const GiftListPage({super.key, required this.userId, required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gift List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.indigo,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('events')
            .doc(eventId)
            .collection('gifts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No gifts found.'));
          }

          final gifts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final gift = gifts[index];
              final giftData = gift.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    giftData['name'] ?? 'Unnamed Gift',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.indigo[800],
                    ),
                  ),
                  subtitle: Text(
                    '${giftData['category'] ?? 'Uncategorized'} - ${giftData['status'] ?? 'Unknown Status'}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueAccent),
                        onPressed: () {
                          _editGiftDialog(context, userId, eventId, gift.id, giftData);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(userId)
                              .collection('events')
                              .doc(eventId)
                              .collection('gifts')
                              .doc(gift.id)
                              .delete();
                        },
                      ),
                    ],
                  ),
                  tileColor: giftData['status'] == 'Pledged'
                      ? Colors.green[100]
                      : Colors.white,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GiftDetailsPage(
                          userId: userId,
                          eventId: eventId,
                          giftId: gift.id,
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
        backgroundColor: Colors.indigo,
        onPressed: () {
          _addGiftDialog(context, userId, eventId);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _addGiftDialog(BuildContext context, String userId, String eventId) {
    final nameController = TextEditingController();
    final categoryController = TextEditingController();
    final statusController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Gift'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Gift Name'),
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
                      .collection('events')
                      .doc(eventId)
                      .collection('gifts')
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

  void _editGiftDialog(BuildContext context, String userId, String eventId, String giftId, Map<String, dynamic> giftData) {
    final nameController = TextEditingController(text: giftData['name']);
    final categoryController = TextEditingController(text: giftData['category']);
    final statusController = TextEditingController(text: giftData['status']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Gift'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Gift Name'),
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
                      .collection('events')
                      .doc(eventId)
                      .collection('gifts')
                      .doc(giftId)
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
