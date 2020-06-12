import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

String formatCurrency(int i){
  final currecy = new NumberFormat("#,###");
  String s = currecy.format(i);
  return 'Rp. $s';
}

String formatDate(DateTime dt){
  final date = new DateFormat("dd-MM-yyyy");
  return date.format(dt);
}

void showSnackBar(String message, BuildContext context){
  Scaffold.of(context).showSnackBar(
    SnackBar(
      content: Text('$message'),
      duration: Duration(milliseconds: 750),
      backgroundColor: Colors.red,
    ),
  );
}