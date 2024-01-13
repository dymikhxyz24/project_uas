import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<bool> authSignUp(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);

    print("User Registered: ${userCredential.user!.email}");
    return true;
  } catch (e) {
    print("Error During Registration: ${e}");
    return false;
  }
}

Future<bool> authSignIn(String email, String password) async {
  try {
    UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    print("User Logged In: ${userCredential.user!.email}");
    return true;
  } catch (e) {
    print("Error During Logged In: ${e}");
    return false;
  }
}
