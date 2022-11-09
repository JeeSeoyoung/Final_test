import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthMethods {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() {
    return _googleSignIn.signIn();
  }

  static Future logout() async {
    bool isAnony = FirebaseAuth.instance.currentUser!.isAnonymous;

    await FirebaseAuth.instance.signOut();
    if (isAnony == false) {
      await _googleSignIn.disconnect();
    }
  }
}
