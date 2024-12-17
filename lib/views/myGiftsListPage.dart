import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyGiftsListPage extends StatelessWidget {
  final String userId;

  const MyGiftsListPage({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Gifts'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('giftlist')
            .where('owner', isEqualTo: userId) // Get gifts created by the user
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No gifts available.'));
          }

          final gifts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: gifts.length,
            itemBuilder: (context, index) {
              final giftData = gifts[index].data() as Map<String, dynamic>;
              final giftId = gifts[index].id; // Document ID

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  title: Text(
                    'Gift Name: ${giftData['name']}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 6),
                      Text(
                        'Category: ${giftData['category']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Status: ${giftData['status']}',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      await _deleteGift(context, giftId); // Pass context here
                    },
                  ),
                  onTap: () {
                    // Pass context here as well for the edit dialog
                    _editGiftDialog(context, giftId, giftData);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Delete gift from Firestore
  Future<void> _deleteGift(BuildContext context, String giftId) async {
    try {
      await FirebaseFirestore.instance
          .collection('giftlist')
          .doc(giftId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift deleted successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // Edit Gift Dialog
  void _editGiftDialog(BuildContext context, String giftId, Map<String, dynamic> giftData) {
    final nameController = TextEditingController(text: giftData['name']);
    final categoryController = TextEditingController(text: giftData['category']);
    final statusController = TextEditingController(text: giftData['status']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Gift'),
          content: SingleChildScrollView(
            child: Column(
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

                if (name.isNotEmpty && category.isNotEmpty && status.isNotEmpty) {
                  try {
                    await FirebaseFirestore.instance
                        .collection('giftlist')
                        .doc(giftId)
                        .update({
                      'name': name,
                      'category': category,
                      'status': status,
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Gift updated successfully!')),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All fields are required.')),
                  );
                }
              },
              child: const Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }
}
