// -----------------------------------------------------------------------
// Filename: screen_sign_ups.dart
// Original Author: Mckayla Guznan
// Creation Date: 11/13/2024
// Description: This file contains the screen for managing and viewing sign-ups

//////////////////////////////////////////////////////////////////////////
// Imports
//////////////////////////////////////////////////////////////////////////
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:csc322_starter_app/widgets/navigation/widget_primary_app_bar.dart';

class ScreenSignUps extends ConsumerStatefulWidget{
  const ScreenSignUps({super.key});

  static const routeName = '/signUps';

  @override
  ConsumerState<ScreenSignUps> createState() => _ScreenSignUpsState();
}

class _ScreenSignUpsState extends ConsumerState<ScreenSignUps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetPrimaryAppBar(
        title: const Text('Sign-Ups')
      ),
      body: Center(
        child: Text('This is the sign-ups page'),
      ),
    );
  }
}