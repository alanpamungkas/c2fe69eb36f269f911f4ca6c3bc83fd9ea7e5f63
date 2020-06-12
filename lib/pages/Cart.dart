import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:kulinapreliminarytest/database/DatabaseHelper.dart';
import 'package:kulinapreliminarytest/models/Product.dart';
import 'package:kulinapreliminarytest/networks/RestfulClient.dart';
import 'dart:async';

import 'package:kulinapreliminarytest/utils/Utils.dart';

class Cart extends StatefulWidget {
  Cart({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  int _page = 1;

  Future<List<Product>> data;

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
    data = getProduct('1');
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
                floating: false,
                pinned: true,
                expandedHeight: 150.0,
                flexibleSpace: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 250,
                      child: FlexibleSpaceBar(
                        title: Text("User Status"),
                      ),
                    ),
                  ],
                ),
              ),
            ];
          },
          body: FutureBuilder<List<Product>>(
              future: db.getAll(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.data.length > 0) {
                    return ListView(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Text(
                                'Daftar Pesanan',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Spacer(),
                              FlatButton(
                                onPressed: () {
                                  setState(() {
                                    db.deleteAll();
                                  });
                                },
                                child: Text(
                                  'Hapus Pesanan',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: snapshot.data
                              .map((e) => Card(
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Image.network(
                                            e.image,
                                            height: 100,
                                            width: 120,
                                            fit: BoxFit.cover,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: Text(
                                                          e.name,
                                                          maxLines: 2,
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 40,
                                                        child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              db.deleteDB(e.id);
                                                            });
                                                          },
                                                          icon: Icon(Icons.delete,
                                                            size: 20,
                                                          ),
                                                          ),
                                                      ),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        vertical: 5,
                                                        horizontal: 0,
                                                    ),
                                                    child: Text(
                                                      e.package,
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontWeight: FontWeight.normal,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Expanded(
                                                        child: Text(formatCurrency(e.price),
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 16,
                                                        ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 50,
                                                        child: Card(
                                                          child: Row(
                                                            children: [
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons.arrow_back_ios,
                                                                  size: 15,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if(e.qty>1) {
                                                                      e.qty -= 1;
                                                                      db.updateDB(e);
                                                                    } else {
                                                                      db.deleteDB(e.id);
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                              Text(e.qty.toString()),
                                                              IconButton(
                                                                icon: Icon(
                                                                  Icons.arrow_forward_ios,
                                                                  size: 15,
                                                                ),
                                                                onPressed: () {
                                                                  setState(() {
                                                                    if(e.qty<100){
                                                                    e.qty+=1;
                                                                    db.updateDB(e);
                                                                    }
                                                                  });
                                                                },
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ))
                              .toList(),
                        )
                      ],
                    );
                  } else {
                    return Container(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(Icons.warning),
                            Text('Pesanan Kosong'),
                          ],
                        ),
                      ),
                    );
                  }
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              })),
      bottomSheet: FutureBuilder(
        future: db.getTotalQty(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data[0] == 0)
              return FlatButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Card(
                  color: Colors.blueAccent,
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Psean Sekarang',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ]),
                  ),
                ),
              );
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
                            flex: 2,
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        'Checkout',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 15,
                                      )
                                    ]),
                              ),
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
