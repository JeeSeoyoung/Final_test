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

class EditProduct extends StatelessWidget {
  late DocumentSnapshot documentSnapshot;
  EditProduct(this.documentSnapshot, {Key? key}) : super(key: key);
  void updateDoc(String url, String name, int price, String description) {
    var doc = FirebaseFirestore.instance
        .collection('productDetail')
        .doc(documentSnapshot.id);
    doc.update({
      'ImgUrl': url,
      'name': name,
      'price': price,
      'description': description,
      'modifyTimeStamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Container(
        child: EditingDetail(
          // writeDetail: (name, url, price, description) =>
          //     appState.createProductDetail(name, url, price, description),
          details: appState.productDtail,
          documentSnapshot: documentSnapshot,
          updateDetail: (url, name, price, description) =>
              updateDoc(url, name, price, description),
        ),
      ),
    );
  }
}

class EditingDetail extends StatefulWidget {
  EditingDetail(
      {Key? key,
      required this.updateDetail,
      required this.details,
      required this.documentSnapshot})
      : super(key: key);
  late DocumentSnapshot documentSnapshot;
  final FutureOr<void> Function(
      String url, String name, int price, String description) updateDetail;
  // final FutureOr<void> Function(
  //     String name, String url, int price, String description) writeDetail;
  final List<ProductDetail> details;

  @override
  State<EditingDetail> createState() => _EditingDetailState();
}

class _EditingDetailState extends State<EditingDetail> {
  final formKey = GlobalKey<FormState>(debugLabel: '_writingDetailState');
  // final formKey = GlobalKey<FormState>();
  TextEditingController _nameController = new TextEditingController();
  TextEditingController _priceController = new TextEditingController();
  TextEditingController _descriptionController = new TextEditingController();

  // Reference defaultRef = FirebaseStorage.instance.ref().child('userImage/defaultIMG.png');

  String _productImageUrl = '';
  String defaultUrl =
      'https://firebasestorage.googleapis.com/v0/b/final-test-1c6ad.appspot.com/o/userImage%2FdefaultIMG.png?alt=media&token=6f39aa6a-26b2-4c80-8c30-6f136428d00f';
  FirebaseStorage storage = FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("productIMG/${DateTime.now().millisecondsSinceEpoch}");

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        _productImageUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // downloadDefaultImage();
    _nameController.text = widget.documentSnapshot['name'];
    _descriptionController.text = widget.documentSnapshot['description'];
    _priceController.text = widget.documentSnapshot['price'].toString();
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black, fontSize: 13),
            )),
        title: const Text('Edit'),
        actions: <Widget>[
          TextButton(
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  await widget.updateDetail(
                      _productImageUrl == ''
                          ? widget.documentSnapshot['ImgUrl']
                          : _productImageUrl,
                      _nameController.text,
                      int.parse(_priceController.text),
                      _descriptionController.text);
                }
                Navigator.pushNamed(context, '/');
              },
              child: Text(
                'save',
                style: TextStyle(color: Colors.white),
              ))
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              _productImageUrl == ''
                  ? Image.network(widget.documentSnapshot['ImgUrl'])
                  : Image.network(_productImageUrl),
              IconButton(
                  onPressed: () {
                    pickUploadImage();
                  },
                  icon: Icon(Icons.camera)),
              Form(
                key: this.formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Product Name',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Write Product Name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _priceController,
                      decoration: const InputDecoration(
                        hintText: 'Price',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Write Price';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        hintText: 'Description',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Write Description';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
