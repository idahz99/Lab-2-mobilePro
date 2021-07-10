import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'User.dart';
import 'adminaddProduct.dart';
import 'dashboard.dart';
import 'editproductpage.dart';

//void main() => runApp(AdminmainS());

class AdminmainS extends StatefulWidget {
  final User user;

  const AdminmainS({Key key, this.user}) : super(key: key);
  @override
  _AdminmainSState createState() => _AdminmainSState();
}

class _AdminmainSState extends State<AdminmainS> {
  List _productsList;
  double screenheight, screenwidth;
  @override
  void initState() {
    super.initState();
    _running();
  }

  @override
  Widget build(BuildContext context) {
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.orange[100],
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => Dashpage(user: widget.user)));
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text('Products'),
        ),
        body: Center(
          child: Container(
              child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              _productsList == null
                  ? Flexible(child: Center(child: Text('Loading...')))
                  : Flexible(
                      child: Center(
                          child: GridView.count(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              children:
                                  List.generate(_productsList.length, (index) {
                                return Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Container(
                                            child: Row(
                                          textDirection: TextDirection.rtl,
                                          children: [
                                            PopupMenuButton(
                                              itemBuilder: (context) {
                                                return [
                                                  PopupMenuItem(
                                                    value: 'edit',
                                                    child: Text('Edit'),
                                                  ),
                                                  PopupMenuItem(
                                                    value: 'delete',
                                                    child: Text('Delete'),
                                                  )
                                                ];
                                              },
                                              onSelected: (String value) {
                                                if (value == 'edit') {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (content) =>
                                                              Editproduct(
                                                                  user: widget
                                                                      .user,
                                                                  index: index,
                                                                  editedproduct:
                                                                      _productsList)));
                                                }
                                                if (value == 'delete') {
                                                  _deleteProductDialog(index);
                                                }
                                              },
                                            ),
                                          ],
                                        )),
                                        Container(
                                          height: screenheight / 5,
                                          
                                          child: Image.network(
                                            "https://crimsonwebs.com/s269349/GohCases/images/products/${_productsList[index]['productid']}.png",
                                            fit: BoxFit.cover,
                                            loadingBuilder:
                                                (BuildContext context,
                                                    Widget child,
                                                    ImageChunkEvent
                                                        loadingProgress) {
                                              return Center(child: child);
                                            },
                                            errorBuilder: (BuildContext context,
                                                    url, error) =>
                                                new Icon(
                                              Icons.broken_image,
                                              size: 150,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          _productsList[index]['productname'],
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text("RM:" +
                                            _productsList[index]
                                                ['productprice']),
                                        Text("Stock left:" +
                                            _productsList[index]
                                                ['productquantity']),
                                      ],
                                    ),
                                  ),
                                );
                              }))))
            ],
          )),
        ),
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(Icons.add),
            backgroundColor: Colors.black,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => AddProducts(user: widget.user)));
            }),
      ),
    );
  }

  void _loadproducts(String products) {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/loadproduct.php"),
        body: {"searchedpr": products}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        Fluttertoast.showToast(
            msg: "No product found",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
        return;
      } else {
        var jsondata = json.decode(response.body);
        _productsList = jsondata["products"];
        setState(() {
          print(_productsList);
        });
      }
    });
  }

  void _running() {
    _loadproducts("allproducts");
  }

  void _deleteProduct(int index) {
    print(index);
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/deleteproduct.php"),
        body: {
          "productid": ( _productsList[index]['productid']).toString(),
        }).then((response) {
      print(response.body);
      if (response.body == "success" ) {
        Fluttertoast.showToast(
            msg: "Successfully delete the product",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[100],
            textColor: Colors.black,
            fontSize: 16.0);
              _loadproducts("allproducts");
      } else {
       Fluttertoast.showToast(
            msg: "Failed to delete the product",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[100],
            textColor: Colors.black,
            fontSize: 16.0);

      }
  
    });
   
  }

  void _deleteProductDialog(int index) {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: new Text("Confirm to delete Product"),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  _deleteProduct(index);
                  Navigator.pop(context);
                },
                child: Text('Yes'),
              )
            ],
          );
        });
  }
}


