// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:googleapis/calendar/v3.dart' as calendar;
// import 'package:http/http.dart' as http;
// import 'package:googleapis_auth/auth_io.dart';

// final GoogleSignIn _googleSignIn = GoogleSignIn(
//   scopes: [calendar.CalendarApi.calendarScope],
// );

// Future<calendar.CalendarApi?> authenticateGoogle() async {
//   try {
//     final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
//     if (googleUser == null) return null; // User canceled sign-in

//     final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

//     final httpClient = http.Client();
//     final credentials = AccessCredentials(
//       AccessToken('Bearer', googleAuth.accessToken!, DateTime.now().add(Duration(hours: 1))),
//       null,
//       [calendar.CalendarApi.calendarScope],
//     );

//     final authClient = authenticatedClient(httpClient, credentials);

//     return calendar.CalendarApi(authClient);
//   } catch (e) {
//     print("Error authenticating Google: $e");
//     return null;
//   }
// }
