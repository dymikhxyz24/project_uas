import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String title;
  final double price;
  final String imageURL;
  final int qty;

  CartItem({
    required this.title,
    required this.price,
    required this.imageURL,
    required this.qty,
  });
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'imageURL': imageURL,
      'qty': qty,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      title: map['title'],
      price: map['price'],
      imageURL: map['imageURL'],
      qty: map['qty'],
    );
  }
}

class CartProviderV2 extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<CartItem> get cartItems => _cartItems;
  String? _userEmail;
  static const String _titleKey = 'cart_title';
  static const String _priceKey = 'cart_price';
  static const String _imageURLKey = 'cart_imageURL';
  static const String _qtyKey = 'cart_qty';
  CartProviderV2() {
    _loadCart();
  }
  void setUserEmail(String email) {
    _userEmail = email;
  }

  void addToCart({
    required String title,
    required double price,
    required String imageURL,
    required int qty,
  }) {
    int existingIndex = _cartItems.indexWhere((item) => item.title == title);
    if (existingIndex != -1) {
      _cartItems[existingIndex] = CartItem(
        title: title,
        price: price,
        imageURL: imageURL,
        qty: _cartItems[existingIndex].qty + qty,
      );
    } else {
      _cartItems.add(CartItem(
        title: title,
        price: price,
        imageURL: imageURL,
        qty: qty,
      ));
    }
    _saveCart();
    notifyListeners();
  }

  void updateCartItemQty({required String title, required int newQty}) {
    int existingIndex = _cartItems.indexWhere((item) => item.title == title);

    if (existingIndex != -1) {
      _cartItems[existingIndex] = CartItem(
        title: title,
        price: _cartItems[existingIndex].price,
        imageURL: _cartItems[existingIndex].imageURL,
        qty: newQty,
      );

      _saveCart();
      notifyListeners();
    }
  }

  void removeCartItem(String title) {
    _cartItems.removeWhere((item) => item.title == title);
    _saveCart();
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _saveCart();
    notifyListeners();
  }

  Future<void> _loadCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String>? titles = prefs.getStringList('$_titleKey$_userEmail');
    List<double>? prices = prefs
        .getStringList('$_priceKey$_userEmail')
        ?.map((price) => double.parse(price))
        .toList();
    List<String>? imageUrls = prefs.getStringList('$_imageURLKey$_userEmail');
    List<String>? quantityStrings = prefs.getStringList('$_qtyKey$_userEmail');
    _cartItems.clear();
    if (titles != null &&
        prices != null &&
        imageUrls != null &&
        quantityStrings != null) {
      for (int i = 0; i < titles.length; i++) {
        _cartItems.add(CartItem(
          title: titles[i],
          price: prices[i],
          imageURL: imageUrls[i],
          qty: int.parse(
            quantityStrings[i],
          ),
        ));
      }
      notifyListeners();
    }
  }

  Future<void> _saveCart() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<String> titles = _cartItems.map((item) => item.title).toList();
    List<String> prices =
        _cartItems.map((item) => item.price.toString()).toList();
    List<String> imageUrls = _cartItems.map((item) => item.imageURL).toList();
    List<String> quantities =
        _cartItems.map((item) => item.qty.toString()).toList();

    prefs.setStringList('$_titleKey$_userEmail', titles);
    prefs.setStringList('$_priceKey$_userEmail', prices);
    prefs.setStringList('$_imageURLKey$_userEmail', imageUrls);
    prefs.setStringList('$_qtyKey$_userEmail', quantities);
  }
}
