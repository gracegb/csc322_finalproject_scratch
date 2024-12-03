import 'package:flutter/material.dart';
import 'package:csc322_starter_app/screens/account/screen_forms.dart';
import 'package:csc322_starter_app/screens/account/screen_sign_ups.dart';
import 'package:csc322_starter_app/screens/account/screen_tasks.dart';
import 'package:go_router/go_router.dart';

class CustomAttentionCard extends StatelessWidget {
  const CustomAttentionCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116,
      height: 232,
      decoration: BoxDecoration(
        color: const Color(0xFFF2F2F2),
        borderRadius: BorderRadius.circular(25),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const Text(
            'Needs Attention',
            style: TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          _buildNavigationButton(
            context,
            label: '2 Forms',
            color: const Color(0xFFFFF3E3),
            textColor: const Color(0xFF7C3030),
            routeName: ScreenForms.routeName,
          ),
          const SizedBox(height: 16),
          _buildNavigationButton(
            context,
            label: '3 Sign-ups',
            color: const Color(0xFFFFF3E3),
            textColor: const Color(0xFF7C3030),
            routeName: ScreenSignUps.routeName,
          ),
          const SizedBox(height: 16),
          _buildNavigationButton(
            context,
            label: '4 Tasks',
            color: const Color(0xFFFFF3E3),
            textColor: const Color(0xFF7C3030),
            routeName: ScreenTasks.routeName,
          ),
        ],
      ),
    );
  }

  /// Helper function to build navigation buttons
  Widget _buildNavigationButton(
    BuildContext context, {
    required String label,
    required Color color,
    required Color textColor,
    required String routeName,
  }) {
    return GestureDetector(
      onTap: () {
        context.push(routeName); // Use `push` for proper navigation stack
      },
      child: Container(
        width: 85,
        height: 35,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}