import 'package:flutter/material.dart';

class TeamChatCard extends StatelessWidget {
  const TeamChatCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 340,
      height: 153,
      child: Stack(
        children: [
          // Background container with rounded corners
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 340,
              height: 153,
              decoration: ShapeDecoration(
                color: Color(0xFFF2F2F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          // Title text
          Positioned(
            left: 60,
            top: 55,
            child: Text(
              'Team Group Chat 2',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Subtext message
          Positioned(
            left: 60,
            top: 76,
            child: Text(
              'Does anyone know the swim set...',
              style: TextStyle(
                color: Color(0xFF9D9D9D),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // Green dot icon for unread messages
          Positioned(
            left: 27,
            top: 66,
            child: Container(
              width: 10,
              height: 10,
              decoration: ShapeDecoration(
                color: Color(0xFF14AE5C),
                shape: OvalBorder(),
              ),
            ),
          ),
          // "Unread Messages" label
          Positioned(
            left: 20,
            top: 20,
            child: Text(
              'Unread Messages',
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Subtext message 2
          Positioned(
            left: 61,
            top: 128,
            child: Text(
              'What’s up guys it’s Caitlin Clar...',
              style: TextStyle(
                color: Color(0xFF9D9D9D),
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          // Name label
          Positioned(
            left: 60,
            top: 105,
            child: Text(
              'Caitlin Clark',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Green dot icon for another unread message
          Positioned(
            left: 27,
            top: 119,
            child: Container(
              width: 10,
              height: 10,
              decoration: ShapeDecoration(
                color: Color(0xFF14AE5C),
                shape: OvalBorder(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
