import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kulinapreliminarytest/pages/ProductList.dart';


void main() {
  runApp(HomePage());
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kulina',
      home: ProductList(title: 'Product List'),
    );
  }
}


