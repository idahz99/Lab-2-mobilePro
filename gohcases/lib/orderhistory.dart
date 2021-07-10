import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'User.dart';
import 'mainscreen.dart';

void main() => runApp(CusOrder());

class CusOrder extends StatefulWidget {
  final User user;

  const CusOrder({Key key, this.user}) : super(key: key);
  @override
  _CusOrderState createState() => _CusOrderState();
}

class _CusOrderState extends State<CusOrder> {
  List _orderslist = [];

  @override
  void initState() {
    super.initState();
    _loadorders();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.orange[100],
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => MainScreen(user: widget.user),
                  ),
                );
              },
              child: Icon(
                Icons.arrow_back_rounded,
              ),
            ),
            title: Text('My Order History'),
          ),
          body: Container(
            child: Column(
              children: [
                SizedBox(height: 10),
                _orderslist == null
                    ? Flexible(child: Center(child: Text('Loadng...')))
                    : Flexible(
                        child: Center(
                          child: GridView.count(
                            crossAxisCount: 1,
                            childAspectRatio: 3,
                            children:
                                List.generate(_orderslist.length, (index) {
                              return Padding(
                                padding: EdgeInsets.all(2.0),
                                child: Container(
                                  child: Card(
                                      child: Column(children: [
                                    Row(
                                      children: [
                                        Text(
                                            "Order id: " +
                                                _orderslist[index]['orderid'],
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Wrap(
                                          alignment: WrapAlignment.spaceBetween,
                                          spacing: 20,
                                          children: [
                                            Text(
                                                "Ordered by: " +
                                                    _orderslist[index]['name'],
                                                style: TextStyle(fontSize: 10)),
                                            Text(
                                                "Date Ordered : " +
                                                    _orderslist[index]
                                                        ['orderdate'],
                                                style: TextStyle(fontSize: 10)),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      textDirection: TextDirection.rtl,
                                      children: [
                                        Text("Amount paid: " +
                                            _orderslist[index]['amount']),
                                      ],
                                    ),
                                    Divider(thickness: 2),
                                    Row(
                                      textDirection: TextDirection.ltr,
                                      children: [
                                        Flexible(
                                            child: Text(
                                                "Delivery address: " +
                                                    _orderslist[index]
                                                        ['address'],
                                                style:
                                                    TextStyle(fontSize: 10))),
                                      ],
                                    ),
                                  ])),
                                ),
                              );
                            }),
                          ),
                        ),
                      )
              ],
            ),
          )),
    );
  }

  void _loadorders() {
    http.post(
        Uri.parse("https://crimsonwebs.com/s269349/GohCases/php/orderlist.php"),
        body: {"email": widget.user.email}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        Fluttertoast.showToast(
            msg: "No products ordered yet",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      } else {
        var jsondata = json.decode(response.body);
        _orderslist = jsondata["orders"];
        setState(() {
          print(_orderslist);
        });
      }
    });
  }
}
