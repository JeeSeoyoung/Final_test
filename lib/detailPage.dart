import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shrine/editProduct.dart';

import 'model/product.dart';
import 'model/products_repository.dart';
import 'package:shrine/services/firebase_auth_methods.dart';
import 'package:shrine/provider/ApplicationState.dart';
import 'dart:io';

class DetailPage extends StatelessWidget {
  late DocumentSnapshot documentSnapshot;
  // String docId;

  final user = FirebaseAuth.instance.currentUser;

  DetailPage(this.documentSnapshot, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Detail'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                // print(documentSnapshot.id);
                // updateDoc(documentSnapshot.id);
                if (user!.uid == documentSnapshot['userId']) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditProduct(documentSnapshot)));
                }
              },
              icon: Icon(Icons.create)),
          IconButton(
              onPressed: () {
                if (user!.uid == documentSnapshot['userId']) {
                  deleteDoc(documentSnapshot.id);
                  Navigator.pop(context);
                }
              },
              icon: Icon(Icons.delete)),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Image.network(
                documentSnapshot['ImgUrl'],
                fit: BoxFit.fitHeight,
              ),
              Container(
                padding: EdgeInsets.zero,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.0, vertical: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                documentSnapshot['name'],
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              // LikeButton(),
                              LikeButton()
                            ],
                          ),
                          Text(
                            '\$ ${documentSnapshot['price']}',
                            style: TextStyle(fontWeight: FontWeight.w300),
                          ),
                          Divider(
                            thickness: 3,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(documentSnapshot['description']),
                          SizedBox(
                            height: 30,
                          ),
                          Text('creator: <${documentSnapshot['userId']}>'),
                          Text(
                              '${(documentSnapshot['timestamp'] as Timestamp).toDate()} Created'),
                          // printModifyTimeStamp();
                          ModifiedTimestamp(documentSnapshot: documentSnapshot),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: FloatingActionButton(
                        onPressed: () {},
                        child: Icon(Icons.shopping_cart),
                      ),
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class LikeButton extends StatefulWidget {
  const LikeButton({
    Key? key,
  }) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  int likeCount = 0;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
            onPressed: () {
              if (likeCount == 0) {
                setState(() {
                  likeCount++;
                });
                // likeCount++;
                final snackBar = SnackBar(
                  content: const Text('I LIKE IT!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                final snackBar = SnackBar(
                  content: const Text('You can only do it once!'),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              }
            },
            icon: Icon(
              Icons.thumb_up,
              color: Colors.red,
            )),
        Text(
          likeCount.toString(),
          style: TextStyle(color: Colors.red),
        )
      ],
    );
  }
}

class ModifiedTimestamp extends StatelessWidget {
  ModifiedTimestamp({
    Key? key,
    required this.documentSnapshot,
  }) : super(key: key);

  final DocumentSnapshot<Object?> documentSnapshot;
  DateTime? modifiedDateTimeStamp;
  void printModifyTimeStamp() {
    Map<String, dynamic> dataMap =
        documentSnapshot.data() as Map<String, dynamic>;
    if (dataMap.containsKey('modifyTimeStamp')) {
      modifiedDateTimeStamp =
          (documentSnapshot['modifyTimeStamp'] as Timestamp).toDate();
    } else {
      print('haha....');
    }
  }

  @override
  Widget build(BuildContext context) {
    printModifyTimeStamp();
    return modifiedDateTimeStamp != null
        ? Text(
            '${(documentSnapshot['modifyTimeStamp'] as Timestamp).toDate()} Modified')
        : SizedBox();
  }
}

void deleteDoc(String docID) {
  FirebaseFirestore.instance.collection('productDetail').doc(docID).delete();
}
