import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shrine/services/firebase_auth_methods.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key? key}) : super(key: key);

  // // TODO: Add text editing controllers (101)
  // final _usernameController = TextEditingController();

  // final _passwordController = TextEditingController();

  Future<UserCredential?> LoginWithGoogle(BuildContext context) async {
    GoogleSignInAccount? user = await FirebaseAuthMethods.login();

    GoogleSignInAuthentication? googleAuth = await user!.authentication;
    var credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    UserCredential? userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    if (userCredential != null) {
      print('login success ===> Google');
      print(userCredential);

      Navigator.pop(context);
    } else {
      print('login FAIL');
    }
    return userCredential;
  }

  Future<void> signInAnonymously(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInAnonymously();
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('Anonymously Sign In FAIL');
    }
  }

  Future AddUser() async {
    final user = FirebaseAuth.instance.currentUser;
    String defaultUrl =
        'https://firebasestorage.googleapis.com/v0/b/final-test-1c6ad.appspot.com/o/userImage%2FdefaultIMG.png?alt=media&token=6f39aa6a-26b2-4c80-8c30-6f136428d00f';
    String profilePic = defaultUrl;
    if (user!.isAnonymous == false) {
      // Name, email address, and profile photo URL
      Reference ref = FirebaseStorage.instance.ref().child('profilepic.jpg');
      profilePic = await ref.getDownloadURL();
      final name = user.displayName;
      final email = user.email;
      final uid = user.uid;

      // final url = await ref.getDownloadURL();
      // final photoURL = await user.updatePhotoURL(url);

      final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

      final json = {
        'name': name,
        'email': email,
        'status_message': 'I promise to take the test honestly before GOD .',
        'uid': uid,
        'profileUrl': profilePic,
        // 'photoURL': photoURL,
      };

      await docUser.set(json);
    } else {
      final docUser = FirebaseFirestore.instance.collection('users').doc();
      final json = {
        'status_message': 'I promise to take the test honestly before GOD .',
        'uid': docUser.id,
        'profileUrl': profilePic,
      };
      await docUser.set(json);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          children: <Widget>[
            const SizedBox(height: 80.0),
            Column(
              children: <Widget>[
                Image.asset('assets/diamond.png'),
                const SizedBox(height: 16.0),
                const Text('SHRINE'),
              ],
            ),
            const SizedBox(height: 120.0),
            Material(
              color: Colors.redAccent,
              child: InkWell(
                onTap: () async {
                  await LoginWithGoogle(context);
                  AddUser();
                  Navigator.pushNamed(context, '/');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Image.asset(
                        'assets/diamond.png',
                        width: 20,
                        fit: BoxFit.cover,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 15),
                    Text(
                      'GOOGLE',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Material(
              color: Colors.grey,
              child: InkWell(
                onTap: () async {
                  await signInAnonymously(context);
                  AddUser();
                  Navigator.pushNamed(context, '/');
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(
                          Icons.question_mark,
                          color: Colors.white,
                        )),
                    SizedBox(width: 15),
                    // SizedBox(height: 6),
                    Text(
                      'Guest',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// class User {
//   final String name;
//   final String email;
//   // final String status_message;
//   String uid;

//   User({
//     required this.name,
//     required this.email,
//     // required this.status_message,
//     this.uid = '',
//   });
//   Map<String, dynamic> toJson() => {
//         'name': name,
//         'email': email,
//         'status_message': 'I promise to take the test honestly before GOD .',
//         'uid': uid,
//       };
// }
