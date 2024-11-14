// -----------------------------------------------------------------------
// Filename: screen_forms.dart
// Original Author: Mckayla Guznan
// Creation Date: 11/13/2024
// Description: This file contains the screen for managing and viewing forms

//////////////////////////////////////////////////////////////////////////
// Imports
//////////////////////////////////////////////////////////////////////////
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:csc322_starter_app/widgets/navigation/widget_primary_app_bar.dart';

class ScreenForms extends ConsumerStatefulWidget{
  const ScreenForms({super.key});

  static const routeName = '/forms';

  @override
  ConsumerState<ScreenForms> createState() => _ScreenFormsState();
}

class _ScreenFormsState extends ConsumerState<ScreenForms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetPrimaryAppBar(
        title: const Text('Forms')
      ),
      body: Center(
        child: Text('This is the forms page'),
      ),
    );
  }
}