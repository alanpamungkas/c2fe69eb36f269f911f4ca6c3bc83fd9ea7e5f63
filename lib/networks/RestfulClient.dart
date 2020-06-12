import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:kulinapreliminarytest/models/Product.dart';

String url = 'https://kulina-recruitment.herokuapp.com/products';
String limit = '&_limit=30';

Future<List<Product>> getProduct(String _page) async {
  final response = await http.get('$url?_page=$_page$limit');
  return productFromJson(response.body);
}