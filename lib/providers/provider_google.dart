import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

final googleSignInProvider = StateNotifierProvider<GoogleAuthNotifier, GoogleAuthState>(
  (ref) => GoogleAuthNotifier(),
);

class GoogleAuthState {
  final bool isSignedIn;
  final GoogleSignInAccount? user;

  GoogleAuthState({
    required this.isSignedIn,
    this.user,
  });
}

class GoogleAuthNotifier extends StateNotifier<GoogleAuthState> {
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarScope],
  );

  GoogleAuthNotifier() : super(GoogleAuthState(isSignedIn: false)) {
    _checkIfSignedIn();
  }

  Future<void> _checkIfSignedIn() async {
    final isSignedIn = await _googleSignIn.isSignedIn();
    if (isSignedIn) {
      state = GoogleAuthState(
        isSignedIn: true,
        user: _googleSignIn.currentUser,
      );
    }
  }

  Future<void> signIn() async {
    try {
      final user = await _googleSignIn.signIn();
      if (user != null) {
        state = GoogleAuthState(isSignedIn: true, user: user);
      }
    } catch (e) {
      print("Error signing in: $e");
    }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    state = GoogleAuthState(isSignedIn: false, user: null);
  }

  GoogleSignIn get googleSignInInstance => _googleSignIn;
}
