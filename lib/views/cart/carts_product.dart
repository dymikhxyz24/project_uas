import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:uas_project/helper/firestoreHelper.dart';
import 'package:uas_project/models/product.dart';
import '../../helper/formatHelper.dart';

class CartsDetails extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    var firestoreHelper = FirestoreHelper();
    String? userEmail = _auth.currentUser!.email;
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        backgroundColor: Color(0xff186F65),
        elevation: 2,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<CartProduct>>(
        stream: firestoreHelper.streamData(userEmail!),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Text('Cart is empty');
          } else {
            List<CartProduct> cartItems = snapshot.data!;
            double totalPrice = cartItems.fold(0,
                (sum, item) => sum + ((item.productPrice * 15000) * item.qty));

            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await firestoreHelper.clearCart(userEmail);
                  },
                  child: Text('Clear Items'),
                ),
                Text('Cart Items:'),
                _buildCartItemList(cartItems, context),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Text(
                    'Total Harga: ${CurrencyFormat.convertToIdr(totalPrice, 0)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (!cartItems.isEmpty) {
                        AwesomeNotifications().createNotification(
                          content: NotificationContent(
                            id: 1,
                            channelKey: "dida_pedia",
                            actionType: ActionType.Default,
                            title: "Berhasil membeli produk!",
                            body:
                                "Selamat kamu telah berhasil membeli produk dari DidaPedia :)",
                          ),
                        );
                      }
                    },
                    child: Text("Beli Produk"),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}

Widget _buildCartItemList(List<CartProduct> cartItems, BuildContext context) {
  return Expanded(
    child: ListView.builder(
      itemCount: cartItems.length,
      itemBuilder: (context, index) {
        var cartItem = cartItems[index];
        return Card(
          margin: EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 12),
          elevation: 5,
          child: ListTile(
            leading: Image.network(
              cartItem.productImage,
              width: 50,
              height: 50,
            ),
            title: Text(cartItem.productTitle),
            subtitle: Text(
              'Price: ${CurrencyFormat.convertToIdr(cartItem.productPrice * 15000, 0)}',
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cartItem.qty.toString(),
                  style: TextStyle(fontSize: 15),
                ),
                Text("Qty"),
              ],
            ),
            onLongPress: () {
              _bottomSheet(context, cartItem);
            },
          ),
        );
      },
    ),
  );
}

void _bottomSheet(BuildContext context, CartProduct cartItem) {
  var firestoreHelper = FirestoreHelper();

  showModalBottomSheet(
    context: context,
    builder: (context) {
      int selectedQty = cartItem.qty;
      return Padding(
        padding: EdgeInsets.only(bottom: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text("Quantity"),
            ),
            SpinBox(
              min: 1,
              step: 1,
              value: selectedQty.toDouble(),
              onChanged: (value) {
                selectedQty = value.toInt();
              },
              onSubmitted: (value) async {
                cartItem.qty = selectedQty;
                await firestoreHelper.updateProductInCart(cartItem);
              },
            ),
            ElevatedButton(
              onPressed: () async {
                await firestoreHelper.deleteProductFromCart(cartItem.id);
                Navigator.pop(context);
              },
              child: Text('Delete Item'),
            ),
          ],
        ),
      );
    },
  );
}
