import 'package:flutter/material.dart';

class CustomAttentionCard extends StatelessWidget {
  const CustomAttentionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116,
      height: 232,
      child: Stack(
        children: [
          // Background container with rounded corners
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 116,
              height: 232,
              decoration: ShapeDecoration(
                color: Color(0xFFF2F2F2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
            ),
          ),
          // Grey button area for 'Tasks'
          Positioned(
            left: 16,
            top: 169,
            child: Container(
              width: 85,
              height: 35,
              decoration: ShapeDecoration(
                color: Color(0xFFD9D9D9),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Light orange button area for '3 Sign-ups'
          Positioned(
            left: 16,
            top: 119,
            child: Container(
              width: 85,
              height: 35,
              decoration: ShapeDecoration(
                color: Color(0xFFFFF3E3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Light orange button area for '2 Forms'
          Positioned(
            left: 16,
            top: 68,
            child: Container(
              width: 85,
              height: 35,
              decoration: ShapeDecoration(
                color: Color(0xFFFFF3E3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          // Text for 'Needs Attention'
          Positioned(
            left: 11,
            top: 31,
            child: Text(
              'Needs Attention',
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Text for '2 Forms'
          Positioned(
            left: 44,
            top: 79,
            child: Text(
              '2 Forms',
              style: TextStyle(
                color: Color(0xFF7C3030),
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Text for '3 Sign-ups'
          Positioned(
            left: 41,
            top: 130,
            child: Text(
              '3 Sign-ups',
              style: TextStyle(
                color: Color(0xFF7C3030),
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          // Text for 'Tasks'
          Positioned(
            left: 44,
            top: 180,
            child: Text(
              'Tasks',
              style: TextStyle(
                color: Color(0xFF9D9D9D),
                fontSize: 10,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}