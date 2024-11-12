// -----------------------------------------------------------------------
// Filename: screen_files.dart
// Original Author: Mckayla Guznan
// Creation Date: 11/12/2024
// Description: This file contains the screen for managing and viewing files

//////////////////////////////////////////////////////////////////////////
// Imports
//////////////////////////////////////////////////////////////////////////
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:csc322_starter_app/widgets/navigation/widget_primary_app_bar.dart';

class ScreenFiles extends ConsumerStatefulWidget{
  const ScreenFiles({super.key});

  static const routeName = '/files';

  @override
  ConsumerState<ScreenFiles> createState() => _ScreenFilesState();
}

class _ScreenFilesState extends ConsumerState<ScreenFiles> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: WidgetPrimaryAppBar(
        title: const Text('Files')
      ),
      body: Center(
        child: Text('This is the files page'),
      ),
    );
  }
}