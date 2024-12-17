import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyGiftDetailsPage extends StatefulWidget {
  final String giftId;
  final String userId;

  const MyGiftDetailsPage({
    Key? key,
    required this.giftId,
    required this.userId,
  }) : super(key: key);

  @override
  State<MyGiftDetailsPage> createState() => _MyGiftDetailsPageState();
}

class _MyGiftDetailsPageState extends State<MyGiftDetailsPage> {
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _categoryController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadGiftDetails();
  }

  // Load existing gift details
  Future<void> _loadGiftDetails() async {
    try {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('giftlist')
          .doc(widget.giftId)
          .get();

      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _categoryController.text = data['category'] ?? '';
          _priceController.text = data['price']?.toString() ?? '';
          _isLoading = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading details: $e')),
      );
    }
  }

  // Save gift details to Firestore
  Future<void> _saveGiftDetails() async {
    try {
      await FirebaseFirestore.instance
          .collection('giftlist')
          .doc(widget.giftId)
          .update({
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'category': _categoryController.text.trim(),
        'price': double.tryParse(_priceController.text.trim()) ?? 0.0,
        'owner': widget.userId,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gift details updated successfully!')),
      );
      Navigator.pop(context); // Go back to gift list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gift Details'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Gift Name', _nameController),
            _buildTextField('Description', _descriptionController),
            _buildTextField('Category', _categoryController),
            _buildTextField('Price', _priceController,
                isNumeric: true),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _saveGiftDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 32),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool isNumeric = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        keyboardType: isNumeric ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
