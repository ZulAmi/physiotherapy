import 'package:flutter/material.dart';

class AppointmentListTile extends StatelessWidget {
  const AppointmentListTile({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: const Text('John Doe'),
        subtitle: Row(
          children: [
            const Icon(Icons.access_time, size: 16),
            const SizedBox(width: 4),
            Text(
              '10:00 AM',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(width: 12),
            const Icon(Icons.video_call, size: 16),
            const SizedBox(width: 4),
            Text(
              'Video Consultation',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'start',
              child: Text('Start Session'),
            ),
            const PopupMenuItem(
              value: 'reschedule',
              child: Text('Reschedule'),
            ),
            const PopupMenuItem(
              value: 'cancel',
              child: Text('Cancel'),
            ),
          ],
          onSelected: (value) {
            // Handle menu item selection
          },
        ),
      ),
    );
  }
}
