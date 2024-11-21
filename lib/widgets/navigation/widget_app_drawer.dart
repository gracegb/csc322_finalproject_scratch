// -----------------------------------------------------------------------
// Filename: widget_app_drawer.dart
// Original Author: Dan Grissom
// Creation Date: 5/27/2024
// Copyright: (c) 2024 CSC322
// Description: This file contains the primary scaffold for the app.
// Mckayla: this file contains logic for navigationBar in top right corner

//////////////////////////////////////////////////////////////////////////
// Imports
//////////////////////////////////////////////////////////////////////////
// Flutter external package imports
import 'package:csc322_starter_app/screens/account/screen_files.dart';
import 'package:csc322_starter_app/screens/account/screen_forms.dart';
import 'package:csc322_starter_app/screens/account/screen_people.dart';
import 'package:csc322_starter_app/screens/account/screen_sign_ups.dart';
import 'package:csc322_starter_app/screens/account/screen_tasks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

// App relative file imports
import '../../screens/settings/screen_profile_edit.dart';
import '../../providers/provider_user_profile.dart';
import '../general/widget_profile_avatar.dart';
import '../../providers/provider_auth.dart';
import '../../main.dart';

enum BottomNavSelection { HOME_SCREEN, ALTERNATE_SCREEN, CALENDAR_SCREEN }

//////////////////////////////////////////////////////////////////
// StateLESS widget which only has data that is initialized when
// widget is created (cannot update except when re-created).
//////////////////////////////////////////////////////////////////
class WidgetAppDrawer extends StatelessWidget {
  ////////////////////////////////////////////////////////////////
  // Primary Flutter method overriden which describes the layout
  // and bindings for this widget.
  ////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Consumer(
        builder: (BuildContext context, WidgetRef ref, Widget? child) {
          final ProviderAuth _providerAuth = ref.watch(providerAuth);
          final ProviderUserProfile _providerUserProfile = ref.watch(providerUserProfile);

          return Column(
            children: <Widget>[
              AppBar(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    ProfileAvatar(
                      radius: 15,
                      userImage: _providerUserProfile.userImage,
                      userWholeName: _providerUserProfile.wholeName,
                    ),
                    const SizedBox(width: 10),
                    Text('Welcome ${_providerUserProfile.firstName}')
                  ],
                ),
                // ,
                automaticallyImplyLeading: false,
              ),
              ListTile(
                title: Text(
                  'My Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.people),
                title: Text('People'),
                onTap: () {
                  // Close the drawer
                  Navigator.of(context).pop();
                  context.push(ScreenPeople.routeName, extra: false);
                },
              ),
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Files'),
                onTap: () {
                  // Close the drawer
                  Navigator.of(context).pop();
                  context.push(ScreenFiles.routeName, extra: false);
                },
              ),
              ListTile(
                leading: Icon(Icons.assignment),
                title: Text('Forms'),
                onTap: () {
                  // Close the drawer
                  Navigator.of(context).pop();
                  context.push(ScreenForms.routeName, extra: false);
                },
              ),
              ListTile(
                leading: Icon(Icons.app_registration),
                title: Text('Sign-Ups'),
                onTap: () {
                  // Close the drawer
                  Navigator.of(context).pop();
                  context.push(ScreenSignUps.routeName, extra: false);
                },
              ),
              ListTile(
                leading: Icon(Icons.checklist),
                title: Text('Tasks'),
                onTap: () {
                  // Close the drawer
                  Navigator.of(context).pop();
                  context.push(ScreenTasks.routeName, extra: false);
                },
              ),
              ListTile(
                title: Text(
                  'Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
                onTap: () {
                  // Close the drawer
                  Navigator.of(context).pop();
                  context.push(ScreenProfileEdit.routeName);
                },
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  _providerAuth.clearAuthedUserDetailsAndSignout();
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
