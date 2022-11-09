import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import 'model/product.dart';
import 'model/products_repository.dart';
import 'package:shrine/services/firebase_auth_methods.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shrine/services/storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // FirebaseStorage storage = FirebaseStorage.instance;

  // Future<void> _upload(String inpuSource) async {
  //   final picker = ImagePicker();
  //   XFile? pickedImage;
  //   try {
  //     pickedImage = await picker.pickImage(
  //         source:
  //             inpuSource == 'camera' ? ImageSource.camera : ImageSource.gallery,
  //         maxWidth: 1920);

  //     final String fileName = path.basename(pickedImage!.path);
  //     File imageFile = File(pickedImage.path);

  //     try {
  //       await storage.ref(fileName).putFile(
  //             imageFile,
  //           );
  //       setState(() {});
  //     } on FirebaseException catch (error) {
  //       if (kDebugMode) {
  //         print(error);
  //       }
  //     }
  //   } catch (err) {
  //     if (kDebugMode) {
  //       print(err);
  //     }
  //   }
  // }

  // Future<List<Map<String, dynamic>>> _loadImages() async {
  //   List<Map<String, dynamic>> files = [];

  //   final ListResult result = await storage.ref().list();
  //   final List<Reference> allFiles = result.items;

  //   await Future.forEach<Reference>(allFiles, (file) async {
  //     final String fileUrl = await file.getDownloadURL();
  //     final FullMetadata fileMeta = await file.getMetadata();
  //     files.add({
  //       "url": fileUrl,
  //       "path": file.fullPath,
  //       "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
  //       "description":
  //           fileMeta.customMetadata?['description'] ?? 'No description'
  //     });
  //   });

  //   return files;
  // }

  // // Delete the selected image
  // // This function is called when a trash icon is pressed
  // Future<void> _delete(String ref) async {
  //   await storage.ref(ref).delete();
  //   // Rebuild the UI
  //   setState(() {});
  // }
  // FirebaseAuth auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;
  String imageUrl = '';
  // String defaulturl = '';
  // Future<String> loadImg() async {
  //   final storageRef = FirebaseStorage.instance.ref();
  //   final defaultUrl =
  //       await storageRef.child('userImage/defaultIMG.png').getDownloadURL();
  //   setState(() {
  //     defaulturl = defaultUrl;
  //   });
  //   return defaulturl
  // }
  // FirebaseStorage storage = FirebaseStorage.instance;
  // File? _photo;
  // final ImagePicker _picker = ImagePicker();

  // Future imgFromGallery() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  //   setState(() {
  //     if (PickedFile != null) {
  //       _photo = File(pickedFile.path);
  //       uploadFile();
  //     } else {
  //       print('no image selected');
  //     }
  //   });
  // }

  // Future uploadFile() async {
  //   if (_photo == null) return;
  //   final fileName = basename(_photo!.path);
  //   final destination = 'files/$fileName';

  //   try {
  //     final ref = FirebaseStorage.instance.ref(destination).child('file/');
  //   } catch (e) {
  //     print('error occured');
  //   }
  // }
  void pickUploadImage() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 75,
    );

    Reference ref = FirebaseStorage.instance.ref().child("profilepic.jpg");

    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      print(value);
      setState(() {
        imageUrl = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              onPressed: () async {
                await FirebaseAuthMethods.logout();
                Navigator.pushNamed(context, '/login');
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Column(
            children: [
              //     IconButton(
              //         onPressed: () {
              //           _upload('gallery');
              //         },
              //         icon: Icon(Icons.camera)),

              // Expanded(child: FutureBuilder(
              //   future: _loadImages(),
              //   builder: (context,
              //     AsyncSnapshot
              //   ),
              // ))
              // imageUrl == ''
              //     ? IconButton(
              //         onPressed: () {
              //           pickUploadImage();
              //         },
              //         icon: Icon(Icons.person))
              //     : Image.network(imageUrl),
              // Image.network(),

              Text(
                '<${user!.uid}>',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Divider(
                height: 15,
                color: Colors.black,
              ),
              Text('${user!.email}'),

              Text('SeoYoung Jee'),
              Text('I promise to take the test honestly before GOD .'),
              // IconButton(
              //     onPressed: () {
              //       pickUploadImage();
              //     },
              //     icon: Icon(Icons.camera))
            ],
          ),
        ),
      ),
    );
  }
}
