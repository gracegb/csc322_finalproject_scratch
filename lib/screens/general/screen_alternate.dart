//////////////////////////////////////////////////////////////////////////
// Filename: screen_alternative.dart
// Original Author: Dan Grissom
// Modified By: Grace Bergquist
// Modification Date: 11/20/2024
// Copyright: (c) 2024 CSC322
// Description: This file contains the messaging screen with a
//              layout including pinned and recent chats.
//////////////////////////////////////////////////////////////////////////

// Imports
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ScreenAlternate extends ConsumerStatefulWidget {
  static const routeName = '/messaging';

  @override
  ConsumerState<ScreenAlternate> createState() => _ScreenAlternateState();
}

class _ScreenAlternateState extends ConsumerState<ScreenAlternate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Pinned',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(5, (index) {
                  return CircleAvatar(
                    backgroundColor: Color(0xFFE1E1E1),
                    radius: 28.5,
                  );
                }),
              ),
              const SizedBox(height: 30),
              Text(
                'Recents',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 20),
              ..._buildRecentChats(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildRecentChats() {
    final List<Map<String, String>> recentChats = [
      {'name': 'John Smith', 'message': 'Thanks for the heads up, I...'},
      {'name': 'Team Group Chat', 'message': 'Team dinner @ 5 tomorrow...'},
      {'name': 'Team Group Chat 2', 'message': 'Does anyone know the swim set...'},
      {'name': 'Jane Doe', 'message': 'Hello?'},
      {'name': 'Caitlin Clark', 'message': 'What’s up guys it’s Caitlin Clar...'},
      {'name': 'Mike Jordan', 'message': 'What’s up guys it’s Michael Jor...'},
    ];

    return recentChats.map((chat) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Color(0xFFE1E1E1),
              radius: 28.5,
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  chat['name']!,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  chat['message']!,
                  style: TextStyle(
                    color: Color(0xFF9D9D9D),
                    fontSize: 12,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }).toList();
  }
}
