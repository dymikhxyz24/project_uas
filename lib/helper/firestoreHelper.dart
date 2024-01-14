import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uas_project/models/product.dart';

class FirestoreHelper {
  Stream<List<CartProduct>> streamData(String userEmail) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    return db
        .collection('cartProducts')
        .where('email', isEqualTo: userEmail)
        .snapshots()
        .map(
          (querySnapshot) => querySnapshot.docs
              .map((doc) => CartProduct.fromDocSnapshot(doc))
              .toList(),
        );
  }

  Future<void> addProductToCart(CartProduct product) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    try {
      // Check if the product already exists in the cart
      QuerySnapshot cartItems = await db
          .collection('cartProducts')
          .where('productTitle', isEqualTo: product.productTitle)
          .where('email', isEqualTo: product.email)
          .get();

      if (cartItems.docs.isNotEmpty) {
        // Product already exists, update the quantity
        DocumentSnapshot cartItem = cartItems.docs.first;
        int newQty = cartItem['qty'] + product.qty;
        await db
            .collection('cartProducts')
            .doc(cartItem.id)
            .update({'qty': newQty});
      } else {
        // Product doesn't exist, add a new one
        await db.collection('cartProducts').add(product.toMap());
      }
    } catch (e) {
      print('Error adding product to cart: $e');
    }
  }

  Future<void> updateProductInCart(CartProduct product) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection('cartProducts')
        .doc(product.id)
        .update({'qty': product.qty});
  }

  Future<void> deleteProductFromCart(String productId) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('cartProducts').doc(productId).delete();
  }

  Future<void> clearCart(String userEmail) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot cartSnapshot = await db
        .collection('cartProducts')
        .where('email', isEqualTo: userEmail)
        .get();

    for (var doc in cartSnapshot.docs) {
      await doc.reference.delete();
    }
  }

  Future<void> updateCoins(String email, int newCoinCount) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db.collection('users').doc(email).set({
      'coins': newCoinCount,
    });
  }
}
