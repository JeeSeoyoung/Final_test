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

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  String imageUrl =
      'https://firebasestorage.googleapis.com/v0/b/final-test-1c6ad.appspot.com/o/userImage%2FdefaultIMG.png?alt=media&token=6f39aa6a-26b2-4c80-8c30-6f136428d00f';
  bool isAnomy = true;

  @override
  Widget build(BuildContext context) {
    if (user!.isAnonymous == false) {
      setState(() {
        imageUrl =
            'https://firebasestorage.googleapis.com/v0/b/final-test-1c6ad.appspot.com/o/profilepic.jpg?alt=media&token=21c7275a-c051-4078-afa4-c6de297a5636';
      });
    }
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
              Image.network(imageUrl),
              SizedBox(
                height: 30,
              ),
              Text(
                '<${user!.uid}>',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Divider(
                height: 15,
                color: Colors.black,
              ),
              user!.isAnonymous == false
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${user!.email}'),
                        SizedBox(
                          height: 40,
                        ),
                        Text('SeoYoung Jee'),
                        Text(
                            'I promise to take the test honestly before GOD .'),
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Anonymous'),
                        SizedBox(
                          height: 40,
                        ),
                        Text('SeoYoung Jee'),
                        Text(
                            'I promise to take the test honestly before GOD .'),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
