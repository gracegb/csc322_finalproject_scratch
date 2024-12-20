import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

class GoogleCalendarLoginScreen extends StatefulWidget {
  @override
  _GoogleCalendarLoginScreenState createState() =>
      _GoogleCalendarLoginScreenState();
}

class _GoogleCalendarLoginScreenState
    extends State<GoogleCalendarLoginScreen> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarScope],
  );

  bool _isSigningIn = false;
  bool _isSignedIn = false;
  String? _userName;
  String? _userEmail;

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn().timeout(Duration(seconds: 15),
              onTimeout: () {
        throw Exception('Sign-in process timed out. Please try again.');
      });

      if (googleUser != null) {
        setState(() {
          _isSignedIn = true;
          _userName = googleUser.displayName;
          _userEmail = googleUser.email;
        });
      }
    } catch (e) {
      // Show an error dialog
      _showErrorDialog('Error during Google Sign-In', e.toString());
      print("Error during Google Sign-In: $e");
    } finally {
      setState(() {
        _isSigningIn = false;
      });
    }
  }

  Future<void> _signOutGoogle() async {
    await _googleSignIn.signOut();
    setState(() {
      _isSignedIn = false;
      _userName = null;
      _userEmail = null;
    });
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Calendar Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: _isSignedIn
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome, $_userName",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text("Email: $_userEmail"),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _signOutGoogle,
                      child: Text("Sign Out"),
                    ),
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Sign in to Google Calendar",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _isSigningIn ? null : _handleGoogleSignIn,
                      child: _isSigningIn
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text("Sign in with Google"),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
