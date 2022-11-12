import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shrine/provider/ApplicationState.dart';

class CartProvider extends ChangeNotifier {
  late CollectionReference cartReference;
  List<ProductDetail> cartItems = [];
  CartProvider({reference}) {
    cartReference = reference ?? FirebaseFirestore.instance.collection('cart');
  }

  Future<void> fetchCartItemsOrCreate(String uid) async {
    if (uid == '') {
      return;
    }
    final cartSnapshot = await cartReference.doc(uid).get();
    if (cartSnapshot.exists) {
      Map<String, dynamic> cartItemsMap =
          cartSnapshot.data() as Map<String, dynamic>;
      List<ProductDetail> temp = [];
      for (var item in cartItemsMap['items']) {
        temp.add(ProductDetail.fromMap(item));
      }
      cartItems = temp;
      notifyListeners();
    } else {
      await cartReference.doc(uid).set({'items': []});
      notifyListeners();
    }
  }

  Future<void> addCartItem(String uid, ProductDetail item) async {
    cartItems.add(item);
    Map<String, dynamic> cartItemsMap = {
      'items': cartItems.map((item) {
        return item.toSnapshot();
      }).toList()
    };
    await cartReference.doc(uid).set(cartItemsMap);
    notifyListeners();
  }

  Future<void> removeCartItem(String uid, ProductDetail item) async {
    cartItems.removeWhere((element) => element.docID == item.docID);
    Map<String, dynamic> cartItemsMap = {
      'items': cartItems.map((item) {
        return item.toSnapshot();
      }).toList()
    };

    await cartReference.doc(uid).set(cartItemsMap);
    notifyListeners();
  }

  bool isCartItemIn(ProductDetail item) {
    return cartItems.any((element) => element.docID == item.docID);
  }
}
