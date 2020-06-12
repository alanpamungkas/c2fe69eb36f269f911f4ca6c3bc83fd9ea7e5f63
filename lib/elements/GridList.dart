import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:kulinapreliminarytest/database/DatabaseHelper.dart';
import 'package:kulinapreliminarytest/models/Product.dart';
import 'package:kulinapreliminarytest/pages/ProductList.dart';
import 'package:kulinapreliminarytest/utils/Utils.dart';

class GridList extends StatefulWidget {
  const GridList({
    Key key,
    @required this.data,
    @required this.dates,
    @required this.fun,
  }) : super(key: key);

  final Function() fun;

  final Future<List<Product>> data;
  final DateTime dates;

  @override
  _GridListState createState() => _GridListState();
}

class _GridListState extends State<GridList> {

  Future<int> qty;

  final db = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Product>>(
        future: widget.data,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) if (snapshot
              .hasError)
            return ErrorWidget(snapshot.error);
          else
            return GridView.count(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 100),
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              scrollDirection: Axis.vertical,
              children: snapshot.data
                  .map((e) => Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.network(
                              e.image,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: EdgeInsets.all(5),
                              child: Text(
                                e.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 0),
                              child: Text(
                                'by ${e.brand}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 5),
                              child: Text(
                                e.package,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 10, 5, 5),
                                  child: Text(
                                    formatCurrency(e.price),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(0, 30, 0, 5),
                                  child: Text(
                                    'termasuk ongkir',
                                    textAlign: TextAlign.start,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            FutureBuilder<int>(
                              future: db.getProductQty(e.id),
                              builder: (context, snapshot) {
                                if(snapshot.connectionState == ConnectionState.done) {
                                  if (snapshot.data > 0) {
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Flexible(
                                            flex: 1,
                                            child: SizedBox(
                                              height: 40,
                                              child: Card(
                                                child: IconButton(
                                                  iconSize: 10,
                                                  icon:
                                                  Icon(Icons.arrow_back_ios),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (snapshot.data >= 1) {
                                                        e.qty =
                                                            snapshot.data - 1;
                                                        db.updateDB(e);
                                                      } else {
                                                        db.deleteDB(e.id);
                                                      }
                                                    });
                                                    widget.fun();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 3,
                                            child: SizedBox(
                                              height: 40,
                                              child: Card(
                                                child: Center(
                                                  child: Text(
                                                    '${snapshot.data}',
                                                    textAlign: TextAlign.center,
                                                    maxLines: 1,
                                                    style: TextStyle(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          Flexible(
                                            flex: 1,
                                            child: SizedBox(
                                              height: 40,
                                              child: Card(
                                                child: IconButton(
                                                  iconSize: 10,
                                                  icon: Icon(
                                                      Icons.arrow_forward_ios),
                                                  onPressed: () {
                                                    setState(() {
                                                      if (snapshot.data < 100) {
                                                        e.qty =
                                                            snapshot.data + 1;
                                                        db.updateDB(e);
                                                      }
                                                    });
                                                    widget.fun();
                                                  },
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  } else {
                                    return SizedBox(
                                      height: 50,
                                      child: Card(
                                        shadowColor: Colors.green,
                                        child: MaterialButton(
                                          onPressed: () {
                                            widget.fun();
                                            setState(() {
                                              e.qty = snapshot.data + 1;
                                              e.date = formatDate(widget.dates);
                                              db.insertDB(e);
                                            });
                                          },
                                          child: Text('Tambah Keranjang'),
                                          textColor: Colors.green,
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            );
          else
            return Center(
              child: CircularProgressIndicator(),
            );
        });
  }
}
