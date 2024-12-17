
import 'package:firebase/views/pledgedgifts.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GiftDetailsPage extends StatefulWidget {
  final String userId;
  final String eventId;
  final String giftId;

  const GiftDetailsPage({super.key, required this.userId, required this.eventId, required this.giftId});

  @override
  _GiftDetailsPageState createState() => _GiftDetailsPageState();
}

class _GiftDetailsPageState extends State<GiftDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPledged = false;
  String? _selectedCategory;
  Map<String, dynamic>? _giftData;

  final List<String> _categories = ['Electronics', 'Books', 'Clothing'];

  @override
  void initState() {
    super.initState();
    _fetchGiftData();
  }

  // Fetch gift data from Firestore
  void _fetchGiftData() async {
    final giftSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('events')
        .doc(widget.eventId)
        .collection('gifts')
        .doc(widget.giftId)
        .get();

    if (giftSnapshot.exists) {
      setState(() {
        _giftData = giftSnapshot.data();
        _isPledged = _giftData?['status'] == 'Pledged';
        _selectedCategory = _giftData?['category'];

        if (_selectedCategory == null || !_categories.contains(_selectedCategory)) {
          _selectedCategory = _categories[0]; // Default to 'Electronics'
        }
      });
    }
  }

  // Update the status of the gift (Pledged or Available)
  void _updatePledgedStatus() async {
    final updatedStatus = _isPledged ? 'Pledged' : 'Available';
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .collection('events')
        .doc(widget.eventId)
        .collection('gifts')
        .doc(widget.giftId)
        .update({
      'status': updatedStatus,
    });
  }

  // Save the updated gift details
  void _saveGiftDetails() async {
    if (_formKey.currentState!.validate()) {
      final updatedGift = {
        'name': _giftData!['name'],
        'description': _giftData!['description'],
        'category': _selectedCategory,
        'price': _giftData!['price'],
        'status': _isPledged ? 'Pledged' : 'Available',
      };

      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .collection('events')
          .doc(widget.eventId)
          .collection('gifts')
          .doc(widget.giftId)
          .update(updatedGift);

      Navigator.pop(context); // Go back to the previous page (GiftListPage)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Gift Details',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: _giftData == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  initialValue: _giftData!['name'],
                  decoration:  InputDecoration(
                    labelText: 'Gift Name',
                    labelStyle: const TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter gift name';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() {
                      _giftData!['name'] = value; // Update name in _giftData
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _giftData!['description'],
                  decoration:  InputDecoration(
                    labelText: 'Description',
                    labelStyle: const TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _giftData!['description'] = value; // Update description in _giftData
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Dropdown for category selection
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration:  InputDecoration(
                    labelText: 'Category',
                    labelStyle: const TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please select a category';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  initialValue: _giftData!['price'].toString(),
                  decoration:  InputDecoration(
                    labelText: 'Price',
                    labelStyle: const TextStyle(color: Colors.green),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    setState(() {
                      _giftData!['price'] = double.tryParse(value) ?? _giftData!['price']; // Update price in _giftData
                    });
                  },
                ),
                const SizedBox(height: 16),
                // Switch to toggle "Pledged" status
                SwitchListTile(
                  title:  Text(
                    'Pledged',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.green[800],
                    ),
                  ),
                  value: _isPledged,
                  activeColor: Colors.green,
                  onChanged: (value) {
                    setState(() {
                      _isPledged = value;
                      // Update the pledged status in Firestore
                      _updatePledgedStatus();
                    });
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.greenAccent,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: _saveGiftDetails, // Save changes to Firestore
                    child: const Text(
                      'Save',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Button to navigate to Pledged Gifts Page
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {
                      // Navigate to Pledged Gifts Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PledgedGiftsPage(userId: widget.userId),
                        ),
                      );
                    },
                    child: const Text(
                      'View Pledged Gifts',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
