import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/product.dart';
import 'model/products_repository.dart';
import 'package:shrine/services/firebase_auth_methods.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  // TODO: Make a collection of cards (102)
  List<Card> _buildGridCards(BuildContext context) {
    List<Product> products = ProductsRepository.loadProducts(Category.all);

    if (products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    return products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 18 / 11,
              child: Image.asset(
                product.assetName,
                package: product.assetPackage,
                fit: BoxFit.fitWidth,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.subtitle2,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // TODO: Add a variable for Category (104)
  @override
  Widget build(BuildContext context) {
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
              print('Add button');
              Navigator.pushNamed(context, '/add');
            },
          ),
        ],
      ),
      // TODO: Add a grid view (102)
      // body:
      // GridView.count(
      //   crossAxisCount: 2,
      //   padding: const EdgeInsets.all(16.0),
      //   childAspectRatio: 8.0 / 9.0,
      //   children: _buildGridCards(context),
      // ),

      // drawer: Drawer(
      //   child: ListView(
      //     padding: EdgeInsets.zero,
      //     // ignore: prefer_const_literals_to_create_immutables
      //     children: [
      //       const DrawerHeader(
      //         padding: EdgeInsets.fromLTRB(30.0, 110.0, 0.0, 0.0),
      //         decoration: BoxDecoration(
      //           color: Colors.blue,
      //         ),
      //         child: Text(
      //           'Pages',
      //           style: TextStyle(
      //             color: Colors.white,
      //             fontSize: 24,
      //           ),
      //         ),
      //       ),
      //       DrawerMenu()
      //     ],
      //   ),
      // ),
      // TODO: Set resizeToAvoidBottomInset (101)
      resizeToAvoidBottomInset: false,
    );
  }
}

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 15.0),
      child: Column(
        children: [
          _buildMenu(Icons.home, 'Home', context),
          _buildMenu(Icons.search, 'Search', context),
          _buildMenu(Icons.location_city, 'Favorite Hotel', context),
          _buildMenu(Icons.person, 'My Page', context),
          _buildMenu(Icons.logout, 'Log Out', context),
        ],
      ),
    );
  }
}

ListTile _buildMenu(IconData icon, String label, BuildContext context) {
  return ListTile(
    leading: Icon(icon, color: Colors.blue),
    title: Text(label),
    onTap: () async {
      // Navigator.pushNamed(context, '/' + label);
      if (label == 'Home') {
        Navigator.pop(context);
      } else {
        if (label == 'Search')
          Navigator.pushNamed(context, '/Search');
        else if (label == 'Favorite Hotel') {
          Navigator.pushNamed(context, '/Search');
        } else if (label == 'My Page') {
          Navigator.pushNamed(context, '/Search');
        } else if (label == 'Log Out') {
          await FirebaseAuthMethods.logout();
          Navigator.pushNamed(context, '/login');
        }
      }
      // Navigator.pop(context);
    },
    // title: Row(
    //   children: [
    //     SizedBox(width: 10.0),
    //     Icon(
    //       icon,
    //       color: Colors.blue,
    //     ),
    //     SizedBox(
    //       width: 30.0,
    //     ),
    //     Text(label)
    //   ],
    // ),
    // onTap: () {
    //   Navigator.pop(context);
    // },
  );
}
