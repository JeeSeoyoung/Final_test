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
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditProduct(documentSnapshot)));
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
                              Row(
                                children: [
                                  IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.thumb_up,
                                        color: Colors.red,
                                      )),
                                  Text(
                                    '0',
                                    style: TextStyle(color: Colors.red),
                                  )
                                ],
                              ),
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
                        ],
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

void deleteDoc(String docID) {
  FirebaseFirestore.instance.collection('productDetail').doc(docID).delete();
}
