import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:provider/provider.dart';
import '../../helper/formatHelper.dart';
import '../../provider/provider.dart';

class CartsDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProviderV2>(context);
    List<CartItem> cartItems = cartProvider.cartItems;
    double totalPrice = cartItems.fold(
        0, (sum, item) => sum + ((item.price * 15000) * item.qty));
    return Scaffold(
      appBar: AppBar(
        title: Text('Keranjang'),
        backgroundColor: Color(0xff186F65),
        elevation: 2,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                cartProvider.clearCart();
              },
              child: Text('Clear Items'),
            ),
            Text(
              'Cart Items:',
            ),
            _buildCartItemList(context),
            Padding(
              padding: EdgeInsets.all(8),
              child: cartProvider.cartItems.isEmpty
                  ? Container()
                  : Text(
                      'Total Harga: ${CurrencyFormat.convertToIdr(totalPrice, 0)}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  onPressed: () {
                    if (!cartProvider.cartItems.isEmpty) {
                      AwesomeNotifications().createNotification(
                        content: NotificationContent(
                          id: 1,
                          channelKey: "dida_pedia",
                          title: "Berhasil membeli produk!",
                          body:
                              "Selamat kamu telah berhasil membeli produk dari DidaPedia :)",
                        ),
                      );
                    }
                  },
                  child: Text("Beli Produk")),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCartItemList(BuildContext context) {
    var cartProvider = Provider.of<CartProviderV2>(context);
    if (cartProvider.cartItems.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: cartProvider.cartItems.length,
          itemBuilder: (context, index) {
            var cartItem = cartProvider.cartItems[index];
            return Card(
              margin: EdgeInsets.only(top: 8, left: 20, right: 20, bottom: 12),
              elevation: 5,
              child: ListTile(
                leading: Image.network(
                  cartItem.imageURL,
                  width: 50,
                  height: 50,
                ),
                title: Text(cartItem.title),
                subtitle: Text(
                    'Price: ${CurrencyFormat.convertToIdr(cartItem.price * 15000, 0)}'),
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
    } else {
      return Text('Cart is empty');
    }
  }

  void _bottomSheet(BuildContext context, CartItem cartItem) {
    var cartProvider = Provider.of<CartProviderV2>(context, listen: false);

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
                  onSubmitted: (value) {
                    cartProvider.updateCartItemQty(
                        title: cartItem.title, newQty: selectedQty);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    cartProvider.removeCartItem(cartItem.title);
                    Navigator.pop(context);
                  },
                  child: Text('Delete Item'),
                ),
              ],
            ),
          );
        });
  }
}
