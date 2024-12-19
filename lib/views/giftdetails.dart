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
    if (_isPledged) {
      // If already pledged, show a message and prevent further action
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This gift is already pledged!')),
      );
      return;
    }

    setState(() {
      _isPledged = true;
    });

    await FirebaseFirestore.instance.collection('giftlist').doc(widget.giftId).update({
      'status': 'Pledged',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Gift marked as Pledged')),
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
            Container(
              decoration: BoxDecoration(
                color: _isPledged ? Colors.grey[700] : Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${_giftData!['name']}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: _isPledged ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Category: ${_giftData!['category']}',
                    style: TextStyle(
                      fontSize: 16,
                      color: _isPledged ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Description: ${_giftData!['description'] ?? 'No description'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: _isPledged ? Colors.white : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Price: \$${_giftData!['price'] ?? '0'}',
                    style: TextStyle(
                      fontSize: 16,
                      color: _isPledged ? Colors.white : Colors.black,
                    ),
                  ),
                ],
              ),
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
