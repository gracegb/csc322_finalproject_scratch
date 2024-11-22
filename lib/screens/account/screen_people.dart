// -----------------------------------------------------------------------
// Filename: screen_files.dart
// Original Author: Mckayla Guznan
// Creation Date: 11/14/2024
// Description: This file contains the screen for managing and viewing people

//////////////////////////////////////////////////////////////////////////
// Imports
//////////////////////////////////////////////////////////////////////////
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:csc322_starter_app/widgets/navigation/widget_primary_app_bar.dart';

class ScreenPeople extends ConsumerStatefulWidget {
  const ScreenPeople({super.key});

  static const routeName = '/people';

  @override
  ConsumerState<ScreenPeople> createState() => _ScreenPeopleState();
}

class _ScreenPeopleState extends ConsumerState<ScreenPeople> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetPrimaryAppBar(title: const Text('People')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('people').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No people found'),
            );
          }

          final peopleDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: peopleDocs.length,
            itemBuilder: (context, index) {
              final personData =
                  peopleDocs[index].data() as Map<String, dynamic>;
              final name = personData['name'] ?? 'No Name';
              final role = personData['role'] ?? 'Unknown';
              final email = personData['email'] ?? '';
              final imageUrl =
                  personData['image_url'] ?? 'https://via.placeholder.com/150';

              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),
                title: Text(name),
                subtitle: Text(email),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: role == 'coach' ? Colors.blue : Colors.green,
                    borderRadius: BorderRadius.circular(8)
                  ),
                  child: Text(
                    role.toUpperCase(),
                    style: const TextStyle(color: Colors.white),
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
