// import 'package:flutter/material.dart';
// import 'package:flutter_spinbox/flutter_spinbox.dart';
// import '../../models/product.dart';
// // import '../../provider/provider.dart';
// import '../cart/carts_product.dart';
// import '../../helper/dbHelper.dart';
// import '../../helper/formatHelper.dart';

// class DetailProduct extends StatefulWidget {
//   final String email;
//   final Product product;

//   const DetailProduct({required this.email, required this.product});
//   @override
//   _DetailProductState createState() => _DetailProductState();
// }

// class _DetailProductState extends State<DetailProduct> {
//   late int totalComments;
//   late DatabaseHelper dbHelper;
//   bool _comments = false;

//   Future<void> _loadComments() async {
//     Map<String, dynamic> commentsData =
//         await dbHelper.getComments(widget.product.title);
//     List<Map<String, dynamic>> comments = commentsData['comments'];
//     setState(() {
//       totalComments = comments.length;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     totalComments = 0;
//     dbHelper = DatabaseHelper();
//     _loadComments();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           title: Text("Detail Produk"),
//           backgroundColor: Color(0xff186F65),
//           elevation: 2,
//           foregroundColor: Colors.white,
//           actions: [
//             Padding(
//                 padding: const EdgeInsets.only(right: 10),
//                 child: IconButton(
//                   onPressed: () {
//                     Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => CartsDetails()));
//                   },
//                   icon: Icon(Icons.shopping_cart),
//                 ))
//           ]),
//       body: detailProduk(context),
//     );
//   }

//   SingleChildScrollView detailProduk(BuildContext context) {
//     int qty = 1;
//     final DatabaseHelper dbHelper = DatabaseHelper();
//     TextEditingController commentController = TextEditingController();

//     return SingleChildScrollView(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           Image.network(
//             widget.product.image,
//             height: 300,
//             fit: BoxFit.cover,
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   CurrencyFormat.convertToIdr(widget.product.price * 15000, 0),
//                   style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   widget.product.title,
//                   style: TextStyle(fontSize: 16),
//                 ),
//                 SizedBox(height: 10),
//                 Row(
//                   children: [
//                     Text(
//                       "Terjual: ${widget.product.rating.count}+",
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     SizedBox(width: 8),
//                     Card(
//                       shape: RoundedRectangleBorder(
//                           side: BorderSide(color: Colors.grey),
//                           borderRadius: BorderRadius.circular(10)),
//                       elevation: 0,
//                       child: Padding(
//                         padding: EdgeInsets.only(
//                             top: 3, bottom: 3, left: 12, right: 12),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Icon(
//                               Icons.star_rounded,
//                               color: Color(0xff186F65),
//                               size: 20,
//                             ),
//                             SizedBox(width: 3),
//                             Text(
//                               "${widget.product.rating.rate}",
//                               style: TextStyle(fontSize: 14),
//                             )
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(height: 12),
//                 Text(
//                   "Detail produk",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 6),
//                 Row(
//                   children: [
//                     Text("Kondisi", style: TextStyle(fontSize: 14)),
//                     SizedBox(width: 88),
//                     Text("Baru")
//                   ],
//                 ),
//                 Divider(),
//                 Row(
//                   children: [
//                     Text("Min. Pemesanan", style: TextStyle(fontSize: 14)),
//                     SizedBox(width: 24),
//                     Text("1 Buah")
//                   ],
//                 ),
//                 Divider(),
//                 Row(
//                   children: [
//                     Text("Kategori", style: TextStyle(fontSize: 14)),
//                     SizedBox(width: 80),
//                     Text(
//                       "${widget.product.category}",
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xff186F65)),
//                     )
//                   ],
//                 ),
//                 Divider(),
//                 SizedBox(height: 12),
//                 Text(
//                   "Deskripsi produk",
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 6),
//                 Text("${widget.product.description}")
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Text('Comments (${totalComments})'),
//           ),
//           FutureBuilder<Map<String, dynamic>>(
//             future: dbHelper.getComments(widget.product.title),
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return CircularProgressIndicator();
//               } else if (snapshot.hasError) {
//                 return Text('Error: ${snapshot.error}');
//               } else {
//                 List<Map<String, dynamic>> comments =
//                     snapshot.data!['comments'];
//                 return Column(
//                   children: comments.map((comment) {
//                     return ListTile(
//                       title: Text(
//                         comment['email'],
//                         style: TextStyle(fontSize: 14),
//                       ),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(comment['created_date'],
//                               style: TextStyle(fontSize: 11)),
//                           Text(
//                             comment['comment'],
//                             style: TextStyle(fontSize: 12),
//                           ),
//                         ],
//                       ),
//                       trailing: IconButton(
//                         icon: Icon(Icons.delete),
//                         onPressed: () async {
//                           await dbHelper.deleteComment(comment['id']);
//                           Map<String, dynamic> commentsData =
//                               await dbHelper.getComments(widget.product.title);
//                           List<Map<String, dynamic>> comments =
//                               commentsData['comments'];
//                           setState(() {
//                             totalComments = comments.length;
//                           });
//                         },
//                       ),
//                     );
//                   }).toList(),
//                 );
//               }
//             },
//           ),
//           Padding(
//             padding: EdgeInsets.all(8),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 TextField(
//                   onTap: () {
//                     setState(() {
//                       _comments = false;
//                     });
//                   },
//                   controller: commentController,
//                   decoration: InputDecoration(
//                     errorText: _comments
//                         ? (commentController.text.isEmpty
//                             ? "Comment tidak boleh kosong"
//                             : null)
//                         : null,
//                     hintText: "Comments",
//                     border: OutlineInputBorder(
//                       borderSide: BorderSide(style: BorderStyle.solid),
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                   ),
//                 ),
//                 ElevatedButton(
//                     style: ButtonStyle(
//                         backgroundColor:
//                             MaterialStatePropertyAll<Color>(Color(0xff186F65)),
//                         foregroundColor:
//                             MaterialStatePropertyAll<Color>(Colors.white),
//                         alignment: Alignment.centerRight),
//                     onPressed: () async {
//                       if (commentController.text.isEmpty) {
//                         setState(() {
//                           _comments = true;
//                         });
//                       } else {
//                         await dbHelper.saveComment(widget.email,
//                             widget.product.title, commentController.text);
//                         Map<String, dynamic> commentsData =
//                             await dbHelper.getComments(widget.product.title);
//                         List<Map<String, dynamic>> comments =
//                             commentsData['comments'];
//                         setState(() {
//                           totalComments = comments.length;
//                         });
//                       }
//                     },
//                     child: Text("Add Comment"))
//               ],
//             ),
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
//             child: SpinBox(
//               decoration: InputDecoration(
//                 border:
//                     OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
//               ),
//               value: qty.toDouble(),
//               min: 1,
//               step: 1,
//               onChanged: (value) {
//                 qty = value.toInt();
//               },
//             ),
//           ),
//           Padding(
//             padding:
//                 const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 16),
//             child: ElevatedButton(
//               onPressed: () {
//                 // // var cartProvider =
//                 // //     Provider.of<CartProviderV2>(context, listen: false);
//                 // cartProvider.addToCart(
//                 //     title: widget.product.title,
//                 //     price: widget.product.price,
//                 //     imageURL: widget.product.image,
//                 //     qty: qty);
//                 _showSnackBar(context);
//               },
//               child: Text(
//                 "Beli Produk",
//                 style: TextStyle(color: Colors.white),
//               ),
//               style: ButtonStyle(
//                   backgroundColor:
//                       MaterialStatePropertyAll<Color>(Color(0xff186F65))),
//             ),
//           )
//         ],
//       ),
//     );
//   }

//   void _showSnackBar(BuildContext context) {
//     final snackBar = SnackBar(
//       content: Text('Item telah ditambahkan ke keranjang'),
//       behavior: SnackBarBehavior.floating,
//       duration: Duration(milliseconds: 1400),
//       action: SnackBarAction(
//         label: 'Lihat',
//         onPressed: () {
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (builder) => CartsDetails()));
//         },
//       ),
//     );

//     ScaffoldMessenger.of(context).showSnackBar(snackBar);
//   }
// }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:intl/intl.dart';
import 'package:uas_project/helper/firestoreHelper.dart';
import '../../models/product.dart';
// import '../../provider/provider.dart';
import '../cart/carts_product.dart';
import '../../helper/dbHelper.dart';
import '../../helper/formatHelper.dart';

class DetailProduct extends StatefulWidget {
  final String email;
  final Product product;

  const DetailProduct({required this.email, required this.product});
  @override
  _DetailProductState createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  FirestoreHelper firestoreHelper = FirestoreHelper();

  late int totalComments;
  late DatabaseHelper dbHelper;
  bool _comments = false;

  Future<void> _loadComments() async {
    Map<String, dynamic> commentsData =
        await dbHelper.getComments(widget.product.title);
    List<Map<String, dynamic>> comments = commentsData['comments'];
    setState(() {
      totalComments = comments.length;
    });
  }

  @override
  void initState() {
    super.initState();
    totalComments = 0;
    dbHelper = DatabaseHelper();
    _loadComments();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("Detail Produk"),
          backgroundColor: Color(0xff186F65),
          elevation: 2,
          foregroundColor: Colors.white,
          actions: [
            Padding(
                padding: const EdgeInsets.only(right: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CartsDetails()));
                  },
                  icon: Icon(Icons.shopping_cart),
                ))
          ]),
      body: detailProduk(context),
    );
  }

  SingleChildScrollView detailProduk(BuildContext context) {
    int qty = 1;
    final DatabaseHelper dbHelper = DatabaseHelper();
    TextEditingController commentController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            widget.product.image,
            height: 300,
            fit: BoxFit.cover,
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 10, left: 16, right: 16, bottom: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CurrencyFormat.convertToIdr(widget.product.price * 15000, 0),
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.product.title,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      "Terjual: ${widget.product.rating.count}+",
                      style: TextStyle(fontSize: 14),
                    ),
                    SizedBox(width: 8),
                    Card(
                      shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10)),
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 3, bottom: 3, left: 12, right: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: Color(0xff186F65),
                              size: 20,
                            ),
                            SizedBox(width: 3),
                            Text(
                              "${widget.product.rating.rate}",
                              style: TextStyle(fontSize: 14),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  "Detail produk",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Row(
                  children: [
                    Text("Kondisi", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 88),
                    Text("Baru")
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Min. Pemesanan", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 24),
                    Text("1 Buah")
                  ],
                ),
                Divider(),
                Row(
                  children: [
                    Text("Kategori", style: TextStyle(fontSize: 14)),
                    SizedBox(width: 80),
                    Text(
                      "${widget.product.category}",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xff186F65)),
                    )
                  ],
                ),
                Divider(),
                SizedBox(height: 12),
                Text(
                  "Deskripsi produk",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text("${widget.product.description}")
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Text('Comments (${totalComments})'),
          ),
          FutureBuilder<Map<String, dynamic>>(
            future: dbHelper.getComments(widget.product.title),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                List<Map<String, dynamic>> comments =
                    snapshot.data!['comments'];
                return Column(
                  children: comments.map((comment) {
                    return ListTile(
                      title: Text(
                        comment['email'],
                        style: TextStyle(fontSize: 14),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment['created_date'],
                              style: TextStyle(fontSize: 11)),
                          Text(
                            comment['comment'],
                            style: TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await dbHelper.deleteComment(comment['id']);
                          Map<String, dynamic> commentsData =
                              await dbHelper.getComments(widget.product.title);
                          List<Map<String, dynamic>> comments =
                              commentsData['comments'];
                          setState(() {
                            totalComments = comments.length;
                          });
                        },
                      ),
                    );
                  }).toList(),
                );
              }
            },
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  onTap: () {
                    setState(() {
                      _comments = false;
                    });
                  },
                  controller: commentController,
                  decoration: InputDecoration(
                    errorText: _comments
                        ? (commentController.text.isEmpty
                            ? "Comment tidak boleh kosong"
                            : null)
                        : null,
                    hintText: "Comments",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll<Color>(Color(0xff186F65)),
                        foregroundColor:
                            MaterialStatePropertyAll<Color>(Colors.white),
                        alignment: Alignment.centerRight),
                    onPressed: () async {
                      if (commentController.text.isEmpty) {
                        setState(() {
                          _comments = true;
                        });
                      } else {
                        await dbHelper.saveComment(widget.email,
                            widget.product.title, commentController.text);
                        Map<String, dynamic> commentsData =
                            await dbHelper.getComments(widget.product.title);
                        List<Map<String, dynamic>> comments =
                            commentsData['comments'];
                        setState(() {
                          totalComments = comments.length;
                        });
                      }
                    },
                    child: Text("Add Comment"))
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 16),
            child: SpinBox(
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              value: qty.toDouble(),
              min: 1,
              step: 1,
              onChanged: (value) {
                qty = value.toInt();
              },
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 16),
            child: ElevatedButton(
              onPressed: () async {
                print(DateTime.now());
                await addToCart(widget.product, qty);
                _showSnackBar(context);
              },
              child: Text(
                "Beli Produk",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStatePropertyAll<Color>(Color(0xff186F65))),
            ),
          )
        ],
      ),
    );
  }

  Future<void> addToCart(Product product, int qty) async {
    var now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);

    var cartProduct = CartProduct(
      id: '',
      email: widget.email,
      qty: qty,
      productTitle: product.title,
      productPrice: product.price,
      productDescription: product.description,
      productCategory: product.category,
      productImage: product.image,
      datetime: formattedDate,
    );

    await firestoreHelper.addProductToCart(cartProduct);
  }

  void _showSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text('Item telah ditambahkan ke keranjang'),
      behavior: SnackBarBehavior.floating,
      duration: Duration(milliseconds: 1400),
      action: SnackBarAction(
        label: 'Lihat',
        onPressed: () {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (builder) => CartsDetails()));
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
