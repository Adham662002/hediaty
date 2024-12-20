import 'package:flutter/material.dart';
import '../services/sync_service.dart';

class SyncButton extends StatelessWidget {
  const SyncButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        // Add a slight delay to avoid blocking UI thread
        await Future.delayed(Duration(milliseconds: 200));

        // Create an instance of SyncServices and call syncData when the button is pressed
        SyncServices syncServices = SyncServices();
        await syncServices.syncData; // Sync the data and print it in the console
      },
      child: const Text('Sync Data'),
    );
  }
}
