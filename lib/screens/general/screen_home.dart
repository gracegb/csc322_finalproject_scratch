// -----------------------------------------------------------------------
// Filename: screen_home.dart
// Original Author: Dan Grissom
// Creation Date: 10/31/2024
// Copyright: (c) 2024 CSC322
// Description: This file contains the screen for a dummy home screen
//               history screen.

//////////////////////////////////////////////////////////////////////////
// Imports
//////////////////////////////////////////////////////////////////////////

// Flutter imports
import 'dart:async';

// Flutter external package imports
import 'package:csc322_starter_app/widgets/home/widget_home_bigcalendar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

// App relative file imports
import '../../util/message_display/snackbar.dart';
import '../../widgets/home/widget_home_calendar.dart';
import '../../widgets/home/widget_home_attention.dart';
import '../../widgets/home/widget_home_chats.dart';
import '../../widgets/home/widget_home_bigcalendar.dart';

//////////////////////////////////////////////////////////////////////////
// StateFUL widget which manages state. Simply initializes the state object.
//////////////////////////////////////////////////////////////////////////
class ScreenHome extends ConsumerStatefulWidget {
  static const routeName = '/home';

  @override
  ConsumerState<ScreenHome> createState() => _ScreenHomeState();
}

//////////////////////////////////////////////////////////////////////////
// The actual STATE which is managed by the above widget.
//////////////////////////////////////////////////////////////////////////
class _ScreenHomeState extends ConsumerState<ScreenHome> {
  // The "instance variables" managed in this state
  bool _isInit = true;

  ////////////////////////////////////////////////////////////////
  // Runs the following code once upon initialization
  ////////////////////////////////////////////////////////////////
  @override
  void didChangeDependencies() {
    // If first time running this code, update provider settings
    if (_isInit) {
      _init();
      _isInit = false;
      super.didChangeDependencies();
    }
  }

  @override
  void initState() {
    print('testing');
    super.initState();
  }

  ////////////////////////////////////////////////////////////////
  // Initializes state variables and resources
  ////////////////////////////////////////////////////////////////
  Future<void> _init() async {}

  //////////////////////////////////////////////////////////////////////////
  // Primary Flutter method overridden which describes the layout and bindings for this widget.
  //////////////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Floating plus button on the bottom right or home screen corner removed cause it was ugly
      // floatingActionButton: FloatingActionButton(
      //   shape: ShapeBorder.lerp(CircleBorder(), StadiumBorder(), 0.5),
      //   onPressed: () => Snackbar.show(
      //     SnackbarDisplayType.SB_INFO,
      //     'You clicked the floating button on the home screen!',
      //     context,
      //   ),
      //   splashColor: Theme.of(context).primaryColor,
      //   child: Icon(FontAwesomeIcons.plus),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.all(16.0), // Adds padding around the content
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomEventCard(
                    date: '29',
                    month: 'OCT',
                    day: 'Tuesday',
                    events: [
                      Event(
                        time: '2:00 - \n3:00 PM',
                        label: 'STA310-A',
                        color: Color(0xFFA8F578),
                        location: 'LOC',
                      ),
                      Event(
                        time: '2:00 - \n3:00 PM',
                        label: 'Practice',
                        color: Color(0xFF79CCF5),
                        location: 'LOC',
                      ),
                      Event(
                        time: '2:00 - \n3:00 PM',
                        label: 'Weights',
                        color: Color(0xFFF5799C),
                        location: 'LOC',
                      ),
                    ],
                  ),
                  CustomAttentionCard(),
                ],
              ),
              SizedBox(height: 16),
              TeamChatCard(),
              SizedBox(height: 16),
              CalendarOverview(),
            ],
          ),
        ),
      ),
    );
  }
}
