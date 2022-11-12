import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shrine/detailPage.dart';

import 'package:shrine/services/firebase_auth_methods.dart';
import 'package:shrine/provider/ApplicationState.dart';

const List<String> list = <String>['Desc', 'Asc'];

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      // TODO: Add app bar (102)
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.person),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        title: const Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              semanticLabel: 'Add',
            ),
            onPressed: () {
              if (user!.isAnonymous == false) {
                print('Add button');
                Navigator.pushNamed(context, '/add');
              }
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          Column(
            children: [
              Consumer<ApplicationState>(
                builder: (context, appState, _) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ProductList(
                      productlist: appState.productDtail,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}

// class DropdownMenu extends StatefulWidget {
//   const DropdownMenu({Key? key}) : super(key: key);

//   @override
//   State<DropdownMenu> createState() => _DropdownMenuState();
// }

// class _DropdownMenuState extends State<DropdownMenu> {
//   String dropdownValue = list.first;
//   @override
//   Widget build(BuildContext context) {
//     return DropdownButton(
//         value: dropdownValue,
//         items: list.map<DropdownMenuItem<String>>((String value) {
//           return DropdownMenuItem<String>(value: value, child: Text(value));
//         }).toList(),
//         onChanged: (String? value) {
//           setState(() {
//             isDescding = (value == 'Desc') ? true : false;
//             dropdownValue = value!;
//             print(isDescding);
//           });
//         });
//   }
// }

class ProductList extends StatefulWidget {
  const ProductList({Key? key, required this.productlist}) : super(key: key);
  final List<ProductDetail> productlist;

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  String dropdownValue = list.first;
  bool isDescding = true;
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('productDetail')
            .orderBy('price', descending: isDescding)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return Column(
              children: [
                DropdownButton(
                    value: dropdownValue,
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                          value: value, child: Text(value));
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        isDescding = (value == 'Desc') ? true : false;
                        dropdownValue = value!;
                        print(isDescding);
                      });
                    }),
                GridView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 8.0 / 9.0,
                  ),
                  itemCount: widget.productlist.length,
                  itemBuilder: ((context, index) {
                    late DocumentSnapshot documentSnapshot =
                        streamSnapshot.data!.docs[index];
                    return Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          AspectRatio(
                            aspectRatio: 20 / 11,
                            child: Image.network(documentSnapshot['ImgUrl']),
                          ),
                          Text(documentSnapshot['name']),
                          Text('\$ ${documentSnapshot['price']}'),
                          TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DetailPage(documentSnapshot)));
                              },
                              child: Text(
                                'more',
                                style: TextStyle(color: Colors.blue),
                              ))
                        ],
                      ),
                    );
                  }),
                ),
              ],
            );
          } else
            return Container();
        });
  }
}
