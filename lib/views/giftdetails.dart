import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GiftDetailsPage extends StatefulWidget {
  final String giftId; // Gift document ID
  final String friendId; // Owner ID of the gift

  const GiftDetailsPage({
    Key? key,
    required this.giftId,
    required this.friendId,
  }) : super(key: key);

  @override
  State<GiftDetailsPage> createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  bool _isPledged = false;
  Map<String, dynamic>? _giftData;

  @override
  void initState() {
    super.initState();
    _fetchGiftDetails();
  }

  // Fetch gift details
  void _fetchGiftDetails() async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('giftlist')
        .doc(widget.giftId)
        .get();

    if (docSnapshot.exists) {
      setState(() {
        _giftData = docSnapshot.data();
        _isPledged = _giftData?['status'] == 'Pledged';
      });
    }
  }

  // Update pledged status
  Future<void> _togglePledgedStatus() async {
    setState(() {
      _isPledged = !_isPledged;
    });

    await FirebaseFirestore.instance.collection('giftlist').doc(widget.giftId).update({
      'status': _isPledged ? 'Pledged' : 'Available',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gift marked as ${_isPledged ? "Pledged" : "Available"}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Details'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _giftData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Name: ${_giftData!['name']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Text(
              'Category: ${_giftData!['category']}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Description: ${_giftData!['description'] ?? 'No description'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 12),
            Text(
              'Price: \$${_giftData!['price'] ?? '0'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            SwitchListTile(
              title: const Text(
                'Pledged',
                style: TextStyle(fontSize: 18),
              ),
              value: _isPledged,
              onChanged: (value) => _togglePledgedStatus(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                ),
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Back',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
