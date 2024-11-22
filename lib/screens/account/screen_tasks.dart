// -----------------------------------------------------------------------
// Filename: screen_tasks.dart
// Original Author: Mckayla Guznan
// Creation Date: 11/12/2024
// Description: This file contains the screen for managing and viewing tasks

//////////////////////////////////////////////////////////////////////////
// Imports
//////////////////////////////////////////////////////////////////////////
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:csc322_starter_app/widgets/navigation/widget_primary_app_bar.dart';

class ScreenTasks extends ConsumerStatefulWidget{
  const ScreenTasks({super.key});

  static const routeName = '/tasks';

  @override
  ConsumerState<ScreenTasks> createState() => _ScreenTasksState();
}

class _ScreenTasksState extends ConsumerState<ScreenTasks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetPrimaryAppBar(
        title: const Text('Tasks')
      ),
      body: Center(
        child: Text('This is the tasks page'),
      ),
    );
  }
}