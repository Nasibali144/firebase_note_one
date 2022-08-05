import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_note_one/pages/sign_in_page.dart';
import 'package:firebase_note_one/services/db_service.dart';
import 'package:firebase_note_one/services/util_service.dart';
import 'package:flutter/material.dart';

class AuthService {
  static final auth = FirebaseAuth.instance;

  static Future<User?> signUpUser(BuildContext context, String name, String email, String password) async {
    try{
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
      var user = userCredential.user;
      await auth.currentUser?.updateDisplayName(name);
      // await user?.updateDisplayName(name);
      return user;
    } catch(e) {
      debugPrint(e.toString());
      Utils.fireSnackBar(e.toString(), context);
    }
    return null;
  }

  static Future<User?> signInUser(BuildContext context, String email, String password) async {
    try{
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential.user;
    } catch(e) {
      debugPrint(e.toString());
      Utils.fireSnackBar(e.toString(), context);
    }
    return null;
  }

  static Future<void> signOutUser(BuildContext context) async {
    await auth.signOut();
    DBService.removeUserId().then((value) {});
  }
}