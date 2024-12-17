import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

import 'eventlist.dart'; // Import EventListPage
import 'myevents.dart';  // Import MyEventsPage

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, 'login');
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Friends & Events',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            icon: const Icon(Icons.event, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyEventsPage(userId: user!.uid),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.add, color: Colors.white), // The new button
            onPressed: () {
              // Show dialog to create an event
              _createEventDialog(context, user);
            },
          ),
        ],
      ),
      body: user != null
          ? Container(
        color: Colors.grey[200],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome, ${user.email ?? 'User'}!',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.data() == null) {
                    return const Center(child: Text('No friends found.'));
                  }

                  final data = snapshot.data!.data() as Map<String, dynamic>;
                  final friends = List<String>.from(data['friends'] ?? []);

                  return ListView.builder(
                    itemCount: friends.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('users')
                            .doc(friends[index])
                            .get(),
                        builder: (context, friendSnapshot) {
                          if (friendSnapshot.connectionState == ConnectionState.waiting) {
                            return const ListTile(
                              title: Text('Loading friend...'),
                            );
                          }
                          if (!friendSnapshot.hasData || friendSnapshot.data!.data() == null) {
                            return const ListTile(
                              title: Text('Friend not found'),
                            );
                          }

                          final friendData = friendSnapshot.data!.data() as Map<String, dynamic>;

                          return FriendTile(
                            friend: Friend(
                              id: friends[index],
                              name: friendData['username'] ?? 'Unnamed', // Ensure 'username' is used
                              upcomingEvents: friendData['upcomingEvents'] ?? 0,
                            ),
                            userId: user.uid,
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      )
          : const Center(child: Text('No user is logged in.')),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        onPressed: () {
          _addFriendDialog(context, user);
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text('Log out'),
              onTap: () => _signOut(context),
            ),
          ],
        ),
      ),
    );
  }

  void _createEventDialog(BuildContext context, User? user) {
    final nameController = TextEditingController();
    final dateController = TextEditingController();
    final locationController = TextEditingController();
    final descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Create New Event'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Event Name'),
              ),
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Event Date'),
              ),
              TextField(
                controller: locationController,
                decoration: const InputDecoration(labelText: 'Event Location'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Event Description'),
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
                final date = dateController.text.trim();
                final location = locationController.text.trim();
                final description = descriptionController.text.trim();

                if (name.isNotEmpty && date.isNotEmpty && location.isNotEmpty && description.isNotEmpty && user != null) {
                  try {
                    // Generate UUID for the event ID
                    var uuid = Uuid();
                    String eventId = uuid.v4(); // Generate a unique ID

                    // Store the event in Firestore
                    await FirebaseFirestore.instance.collection('events').doc(eventId).set({
                      'name': name,
                      'date': date,
                      'location': location,
                      'description': description,
                      'gifts': [], // Empty array for gifts
                      'owner': user.uid, // ID of the user who created the event
                      'createdAt': FieldValue.serverTimestamp(),
                    });

                    // Optionally add the event to the user's list of events if needed
                    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
                      'events': FieldValue.arrayUnion([eventId]),
                    });

                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Event created successfully!')),
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
              child: const Text('Create Event'),
            ),
          ],
        );
      },
    );
  }

  void _addFriendDialog(BuildContext context, User? currentUser) {
    final phoneController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Friend by Phone Number'),
          content: TextField(
            controller: phoneController,
            decoration: const InputDecoration(labelText: 'Enter Phone Number'),
            keyboardType: TextInputType.phone,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final phone = phoneController.text.trim();

                if (phone.isNotEmpty && currentUser != null) {
                  try {
                    final querySnapshot = await FirebaseFirestore.instance
                        .collection('users')
                        .where('phone', isEqualTo: phone)
                        .get();

                    if (querySnapshot.docs.isNotEmpty) {
                      final friendData = querySnapshot.docs.first;
                      final friendId = friendData.id;

                      await FirebaseFirestore.instance
                          .collection('users')
                          .doc(currentUser.uid)
                          .update({
                        'friends': FieldValue.arrayUnion([friendId]),
                      });

                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Friend ${friendData['username']} added successfully!')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('No user found with this phone number.')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Phone number cannot be empty.')),
                  );
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}

class FriendTile extends StatelessWidget {
  final Friend friend;
  final String userId;

  const FriendTile({Key? key, required this.friend, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(
          friend.name,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.deepPurple,
          ),
        ),
        subtitle: Text(
          friend.upcomingEvents > 0
              ? 'Upcoming Events: ${friend.upcomingEvents}'
              : 'No Upcoming Events',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        trailing: const Icon(Icons.arrow_forward, color: Colors.deepPurple),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventListPage(
                userId: userId,
                friendId: friend.id,
              ),
            ),
          );
        },
      ),
    );
  }
}

class Friend {
  final String id;
  final String name;
  final int upcomingEvents;

  const Friend({
    required this.id,
    required this.name,
    required this.upcomingEvents,
  });
}
