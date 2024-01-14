import 'package:cloud_firestore/cloud_firestore.dart';

class CartProduct {
  String id;
  String email;
  int qty;
  String productTitle;
  double productPrice;
  String productDescription;
  String productCategory;
  String productImage;
  String datetime;

  CartProduct({
    required this.id,
    required this.email,
    required this.qty,
    required this.productTitle,
    required this.productPrice,
    required this.productDescription,
    required this.productCategory,
    required this.productImage,
    required this.datetime,
  });

  factory CartProduct.fromDocSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return CartProduct(
        id: doc.id,
        email: data['email'] ?? '',
        qty: data['qty'] ?? '',
        productTitle: data['productTitle'] ?? '',
        productPrice: data['productPrice']?.toDouble() ?? 0.0,
        productDescription: data['productDescription'] ?? '',
        productCategory: data['productCategory'] ?? '',
        productImage: data['productImage'] ?? '',
        datetime: data['datetime'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      // 'timestamp': timestamp,
      'qty': qty,
      'productTitle': productTitle,
      'productPrice': productPrice,
      'productDescription': productDescription,
      'productCategory': productCategory,
      'productImage': productImage,
      'datetime': datetime
    };
  }
}

class Product {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating rating;

  Product({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      title: json['title'],
      price: json['price'].toDouble(),
      description: json['description'],
      category: json['category'],
      image: json['image'],
      rating: Rating.fromJson(json['rating']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'category': category,
      'image': image,
      'rating': rating.toMap(),
    };
  }
}

class Rating {
  double rate;
  int count;

  Rating({
    required this.rate,
    required this.count,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      rate: json['rate'].toDouble(),
      count: json['count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'rate': rate,
      'count': count,
    };
  }
}
