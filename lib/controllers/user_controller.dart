import 'package:cloud_firestore/cloud_firestore.dart';

class UserController {
  static Future<void> addUser({
    required String userId,
    required String username,
    required String email,
    required String phone,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'username': username,
        'email': email,
        'phone': phone,
        'friends':[],
        'events':[],
      });
    } catch (e) {
      throw Exception('Error adding user to Firestore: $e');
    }
  }
}
