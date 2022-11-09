import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

import 'model/product.dart';
import 'model/products_repository.dart';
import 'package:shrine/services/firebase_auth_methods.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.black, fontSize: 13),
            )),
        title: const Text('Add'),
        actions: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(
                'save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ListView(
        children: [detailViewContent()],
      ),
    );
  }
}

Column detailViewContent() {
  return Column(
    children: [
      // Image
    ],
  );
}

class productStorage extends ChangeNotifier {
  Future<DocumentReference> addProducts(String name, int price, String Image) {
    return FirebaseFirestore.instance
        .collection('productList')
        .add(<String, dynamic>{
      'name': name,
      'price': price,
      'Image': Image,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }
}
