import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import '../models/product.dart';

class HttpHelper {
  final String _urlBase = "https://fakestoreapi.com/";

  Future<List<Product>> getProducts() async {
    var urlParse = Uri.parse(_urlBase + "products");
    http.Response result = await http.get(urlParse);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body) as List<dynamic>;
      List<Product> products =
          jsonResponse.map((val) => Product.fromJson(val)).toList();
      return products;
    } else {
      return [];
    }
  }
}
