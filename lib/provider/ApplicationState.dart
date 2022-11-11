import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shrine/firebase_options.dart';
import 'package:shrine/services/firebase_auth_methods.dart';

enum Like { liked }

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  // StreamSubscription<QuerySnapshot>? _
  int _liked = 0;
  int get liked => _liked;
  StreamSubscription<QuerySnapshot>? _productDetailSubscription;
  List<ProductDetail> _productDetail = [];
  List<ProductDetail> get productDtail => _productDetail;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    Future downloadUrl() async {
      // defaultIMG.png
      String path;
      String imageUrl;
      if (FirebaseAuth.instance.currentUser!.isAnonymous == false) {
        path = 'profilepic.jpg';
      } else {
        path = 'userImage/defaultIMG.png';
      }
      Reference ref = FirebaseStorage.instance.ref().child(path);
      imageUrl = await ref.getDownloadURL();
      notifyListeners();
    }

    //login
    // Future<UserCredential?> LoginWithGoogle(BuildContext context) async {
    //   GoogleSignInAccount? user = await FirebaseAuthMethods.login();

    //   GoogleSignInAuthentication? googleAuth = await user!.authentication;
    //   var credential = GoogleAuthProvider.credential(
    //       accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    //   UserCredential? userCredential =
    //       await FirebaseAuth.instance.signInWithCredential(credential);

    //   if (userCredential != null) {
    //     print('login success ===> Google');
    //     print(userCredential);

    //     Navigator.pop(context);
    //   } else {
    //     print('login FAIL');
    //   }
    //   return userCredential;
    // }

    // Future<void> signInAnonymously(BuildContext context) async {
    //   try {
    //     await FirebaseAuth.instance.signInAnonymously();
    //     Navigator.pop(context);
    //   } on FirebaseAuthException catch (e) {
    //     print('Anonymously Sign In FAIL');
    //   }
    // }

    // //Create Users Collection
    // Future CreateUserCollection() async {
    //   final user = FirebaseAuth.instance.currentUser;

    //   if (user != null) {
    //     Reference ref = FirebaseStorage.instance.ref().child('profilepic.jpg');
    //     final name = user.displayName;
    //     final email = user.email;
    //     final uid = user.uid;
    //     final imageUrl = await ref.getDownloadURL();
    //     // final photoURL = await user.updatePhotoURL(url);

    //     final docUser = FirebaseFirestore.instance.collection('users').doc(uid);

    //     final json = {
    //       'name': name,
    //       'email': email,
    //       'status_message': 'I promise to take the test honestly before GOD .',
    //       'uid': uid,
    //       'imageUrl': imageUrl,
    //       // 'photoURL': photoURL,
    //     };

    //     await docUser.set(json);
    //   } else {
    //     Reference ref =
    //         FirebaseStorage.instance.ref().child('userImage/defaultIMG.png');
    //     final docUser = FirebaseFirestore.instance.collection('users').doc();
    //     final imageUrl = await ref.getDownloadURL();
    //     final json = {
    //       'status_message': 'I promise to take the test honestly before GOD .',
    //       'uid': docUser.id,
    //       'imageUrl': imageUrl,
    //     };
    //     await docUser.set(json);
    //   }
    // }
    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        print('seoyoung sign in!!!');
        _productDetailSubscription = FirebaseFirestore.instance
            .collection('productDetail')
            // .orderBy('price', descending: true)
            .snapshots()
            .listen((snapshot) {
          _productDetail = [];
          for (final document in snapshot.docs) {
            _productDetail.add(
              ProductDetail(
                productImgUrl: document.data()['ImgUrl'] as String,
                productName: document.data()['name'] as String,
                price: document.data()['price'] as int,
                description: document.data()['description'] as String,
                userId: document.data()['userId'] as String,
              ),
            );
          }
          notifyListeners();
        });
      } else {
        print('what is this??????????????????');
        _productDetail = [];
        _productDetailSubscription?.cancel();
      }
      notifyListeners();
    });

    // Future<DocumentReference> createProductDetail(
    //     String name, String url, int price, String description) {
    //   if (FirebaseAuth.instance.currentUser!.isAnonymous != false) {
    //     throw Exception('Must be logged in');
    //   }
    //   return FirebaseFirestore.instance
    //       .collection('productDetail')
    //       .add(<String, dynamic>{
    //     'ImgUrl': url,
    //     'name': name,
    //     'price': price,
    //     'description': description,
    //     'timestamp': DateTime.now().millisecondsSinceEpoch,
    //     'userId': FirebaseAuth.instance.currentUser!.uid,
    //   });
    // }
  }

  Future<DocumentReference> createProductDetail(
      String name, String url, int price, String description) {
    if (FirebaseAuth.instance.currentUser!.isAnonymous != false) {
      throw Exception('Must be logged in');
    }
    return FirebaseFirestore.instance
        .collection('productDetail')
        .add(<String, dynamic>{
      'ImgUrl': url,
      'name': name,
      'price': price,
      'description': description,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  // createProductDetail(String name, String url, int price, String description) {}
}

class ProductDetail {
  ProductDetail({
    required this.productImgUrl,
    required this.productName,
    required this.price,
    required this.description,
    required this.userId,
  });
  final String productImgUrl;
  final String productName;
  final int price;
  final String description;
  final String userId;
}
