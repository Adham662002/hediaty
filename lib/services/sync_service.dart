import '../database/local_database.dart';

class SyncServices {
  final LocalDatabase _localDatabase = LocalDatabase();

  // Constructor to initialize the database
  SyncServices();

  // Sync data for a specific user
  Future<void> syncData(String userId) async {
    await _localDatabase.init(); // Initialize the local database connection

    try {
      // Fetch user details by userId
      var users = await _localDatabase.getUsers();

      // Find the user in the list of users
      var user = users.firstWhere(
              (user) => user['id'] == userId,
          orElse: () => {} // Return an empty map if no user is found
      );

      if (user.isEmpty) {
        print('User not found in local database');
        return; // Early return if no user is found
      }

      print('Syncing data for user: ${user['name']}');

      // Fetch events for this user
      var events = await _localDatabase.getEvents();
      var userEvents = events.where((event) => event['userId'] == userId).toList();
      print('Syncing events for this user: $userEvents');

      // Fetch gifts related to this user's events
      var gifts = await _localDatabase.getGifts();
      var userGifts = gifts.where((gift) => userEvents.any((event) => event['id'] == gift['eventId'])).toList();
      print('Syncing gifts for this user: $userGifts');

      // Fetch friends related to this user
      var friends = await _localDatabase.getFriends();
      var userFriends = friends.where((friend) => friend['userId'] == userId).toList();
      print('Syncing friends for this user: $userFriends');

    } catch (e) {
      print('Error syncing data: $e');
    } finally {
      await _localDatabase.close(); // Close the database connection after syncing
    }
  }
}
