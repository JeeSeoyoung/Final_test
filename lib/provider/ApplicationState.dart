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

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        print('seoyoung sign in!!!');
        _productDetailSubscription = FirebaseFirestore.instance
            .collection('productDetail')
            .orderBy('price', descending: false)
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
                docID: document.id as String,
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
      'timestamp': FieldValue.serverTimestamp(),
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
    required this.docID,
  });
  final String productImgUrl;
  final String productName;
  final int price;
  final String description;
  final String userId;
  final String docID;
}
