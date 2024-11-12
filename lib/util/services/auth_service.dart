// import 'package:google_sign_in/google_sign_in.dart';

// class AuthService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn(
//     scopes: [
//       'https://www.googleapis.com/auth/calendar.readonly',
//     ],
//   );

//   Future<String?> signInWithGoogle() async {
//     try {
//       final account = await _googleSignIn.signIn();
//       if (account == null) return null;
//       final auth = await account.authentication;
//       return auth.accessToken; // Returns the access token for further API calls
//     } catch (e) {
//       print("Error during Google Sign-In: $e");
//       return null;
//     }
//   }

//   Future<void> signOut() async {
//     await _googleSignIn.signOut();
//   }

//   bool isSignedIn() {
//     return _googleSignIn.currentUser != null;
//   }
// }
