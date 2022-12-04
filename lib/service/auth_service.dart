import 'package:firebase_auth/firebase_auth.dart';
import 'package:groupchat_app/helper/helper_function.dart';
import 'package:groupchat_app/service/database_service.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  // login
  Future signInWithEmailandPassword(String email, String password) async {
    try {
      User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // register

  Future registerUserWithEmailandPassword(
      String username, String email, String password) async {
    try {
      User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: email, password: password))
          .user!;

      if (user != null) {
        await DatabaseService(uid: user.uid).updateUser(username, email);
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // signout
  Future signOut() async {
    try {
      await helper_function.saveUserLoggedInStatus(false);
      await helper_function.saveUserEmail("");
      await helper_function.saveUserName("");
      await firebaseAuth.signOut();
      print('successfully logged out');
    } catch (e) {
      print(e);
      return null;
    }
  }
}
