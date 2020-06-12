import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:kulinapreliminarytest/database/DatabaseHelper.dart';
import 'package:kulinapreliminarytest/elements/GridList.dart';
import 'package:kulinapreliminarytest/models/Product.dart';
import 'package:kulinapreliminarytest/networks/RestfulClient.dart';
import 'dart:async';
import 'package:kulinapreliminarytest/utils/Utils.dart';

import 'Cart.dart';

class ProductList extends StatefulWidget {
  ProductList({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProductListState createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  int _page = 1;
  DatePickerController _datePickerController = DatePickerController();

  Future<List<Product>> data;
  DateTime _selectedDate = DateTime.now();

  TextStyle selected = TextStyle(
    color: Colors.grey,
  );
  TextStyle unselected = TextStyle(
    color: Colors.white,
  );
  Color selection = Colors.black;

  final db = DatabaseHelper.instance;

  @override
  void initState() {
    data = getProduct(_page.toString());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('Alamat Pengiriman',
                          style: TextStyle(
                            fontSize: 10,
                          )),
                      Icon(
                        Icons.keyboard_arrow_down,
                        size: 14,
                      )
                    ],
                  ),
                  Text('Product List')
                ],
              ),
              pinned: true,
              floating: true,
              forceElevated: innerBoxIsScrolled,
              bottom: PreferredSize(
                  child: Builder(
                    builder: (context) => DatePicker(DateTime.now(),
                        daysCount: 57,
                        width: 50,
                        height: 80,
                        controller: _datePickerController,
                        monthTextStyle: unselected,
                        dateTextStyle: unselected,
                        dayTextStyle: unselected,
                        initialSelectedDate: DateTime.now(),
                        selectionColor: selection,
                        selectedTextColor: Colors.white, onDateChange: (date) {
                      if (date.day != DateTime.now().day)
                        _datePickerController.animateToDate(date);

                      if (date.weekday == 6 || date.weekday == 7) {
                        showSnackBar('Weekends Unavailable', context);
                        setState(() {
                          selection = Colors.red;
                          _selectedDate = null;
                        });
                      } else {
                        setState(() {
                          selection = Colors.black;
                          _selectedDate = date;
                        });
                      }
                    }),
                  ),
                  preferredSize: Size.fromHeight(80)),
            ),
          ];
        },
        body: GridList(
          data: data,
          dates: _selectedDate,
          fun: () {
            setState(() {});
          },
        ),
      ),
      bottomSheet: FutureBuilder(
        future: db.getTotalQty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data[0] == 0) return Text('');
            return Container(
              child: Row(
                children: [
                  Expanded(
                    child: Card(
                      color: Colors.blueAccent,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: SizedBox(
                              height: 60,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 10, 15, 0),
                                    child: Text(
                                      '${snapshot.data[0]} item | ${formatCurrency(snapshot.data[1])}',
                                      style: TextStyle(
                                        letterSpacing: 1,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(15, 0, 15, 10),
                                    child: Text(
                                      'termasuk ongkos kirim',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Cart()),
                                ).then((flag) {
                                  setState(() {});
                                });
                              },
                              icon: Icon(Icons.shopping_cart),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Text('');
          }
        },
      ),
    );
  }
}
