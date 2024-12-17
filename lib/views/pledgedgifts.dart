import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PledgedGiftsPage extends StatelessWidget {
  final String userId;

  const PledgedGiftsPage({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pledged Gifts',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .collection('pledgedGifts')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No pledged gifts found.'));
          }

          final pledgedGifts = snapshot.data!.docs;

          return ListView.builder(
            itemCount: pledgedGifts.length,
            itemBuilder: (context, index) {
              final pledgedGift = pledgedGifts[index];
              final giftData = pledgedGift.data() as Map<String, dynamic>;

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    giftData['name'] ?? 'Unnamed Gift',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                  subtitle: Text(
                    '${giftData['category']} - ${giftData['status']}',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () async {
                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(userId)
                          .collection('pledgedGifts')
                          .doc(pledgedGift.id)
                          .delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
