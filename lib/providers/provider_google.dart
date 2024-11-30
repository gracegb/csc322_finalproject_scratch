import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarScope],
  );

  GoogleSignInAccount? _user;
  GoogleSignInAccount? get user => _user;

  bool get isSignedIn => _user != null;

  Future<void> signIn() async {
    try {
      _user = await _googleSignIn.signIn();
      notifyListeners();
    } catch (e) {
      print("Error signing in: $e");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _user = null;
    notifyListeners();
  }
}
