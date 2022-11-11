import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'model/product.dart';
import 'model/products_repository.dart';
import 'package:shrine/services/firebase_auth_methods.dart';
import 'package:shrine/provider/ApplicationState.dart';
import 'dart:io';

class DetailPage extends StatelessWidget {
  String docId;

  final user = FirebaseAuth.instance.currentUser;
  DetailPage(this.docId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var documentSnapshot =
        FirebaseFirestore.instance.collection('productDetail').get();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detail'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                print(documentSnapshot);
              },
              icon: Icon(Icons.create)),
          IconButton(
              onPressed: () {
                // if(user.uid==documentSnapshot.){}
                deleteDoc(docId);
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete)),
        ],
      ),
      body: Text(docId),
    );
  }
}

void deleteDoc(String docID) {
  FirebaseFirestore.instance.collection('productDetail').doc(docID).delete();
}
