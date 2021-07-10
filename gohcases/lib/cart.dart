import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';

import 'User.dart';
import 'checkoutpage.dart';
import 'mainscreen.dart';

void main() => runApp(Cart());

class Cart extends StatefulWidget {
  final String email;
  final User user;
  const Cart({Key key, this.user, this.email}) : super(key: key);
  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  double screenheight, screenwidth;
  List _cartlist = [];
  double _totalprice = 0;
  int cartquantity = 0;
  @override
  void initState() {
    super.initState();
    _loadpersonalcart();
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
          title: Text('Cart'),
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
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                _cartlist == null
                    ? Flexible(child: Center(child: Text('Loading...')))
                    : Flexible(
                        child: Center(
                          child: GridView.count(
                            crossAxisCount: 1,
                            childAspectRatio: 1.8,
                            children: List.generate(
                              _cartlist.length,
                              (index) {
                                return Padding(
                                    padding: EdgeInsets.all(2),
                                    child: Container(
                                      child: Card(
                                        child: Row(
                                          children: [
                                            Container(
                                              height: 100,
                                              width: 100,
                                              child: Image.network(
                                                
                                                    "https://crimsonwebs.com/s269349/GohCases/images/products/${_cartlist[index]['productid']}.png",
                                                     fit: BoxFit.cover,
                                                    loadingBuilder:(context,child, loadingprogress){
                                                             if (loadingprogress == null){return child;}
                                                             return Center (child:Text("Loading Picture..."));},
                              
                                               
                                               errorBuilder:
                                                  (context, url, error) =>
                                                      new Icon(
                                                Icons.broken_image,
                                                size: 150,
                                                      ),
                                              ),
                                            ),
                                            VerticalDivider(color: Colors.grey),
                                            Container(
                                              child: Expanded(
                                                child: Column(
                                                  //  child: Column(
                                                  children: [
                                                    SizedBox(height: 10),
                                                    Text(
                                                      _cartlist[index]
                                                          ['productname'],
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Text("RM:" +
                                                        _cartlist[index]
                                                            ['productprice']),
                                                    Text("Stock left:" +
                                                        _cartlist[index][
                                                            'productquantity']),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(Icons
                                                              .remove_circle_rounded),
                                                          onPressed: () {
                                                            _modifycartqty(
                                                                index,
                                                                "remove");
                                                          },
                                                        ),
                                                        Text(_cartlist[index]
                                                                ['cartquantity']
                                                            .toString()),
                                                        IconButton(
                                                          icon: Icon(Icons
                                                              .add_circle_rounded),
                                                          onPressed: () {
                                                            _modifycartqty(
                                                                index, "add");
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        IconButton(
                                                          icon: Icon(
                                                              Icons.delete),
                                                          onPressed: () {
                                                            _modifycartqty(
                                                                index,
                                                                "delete");
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ));
                              },
                            ),
                          ),
                        ),
                      ),
                Container(
                  child: Column(
                    children: [
                      Text('Total Price'),
                      Text(_totalprice.toString()),
                      MaterialButton(
                        onPressed: () => {
                          _checktotal(),
                        },
                        child: Text('Proceed to checkout',
                            style: TextStyle(color: Colors.black)),
                        color: Colors.redAccent[100],
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _loadpersonalcart() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/loadusercart.php"),
        body: {"email": widget.user.email}).then((response) {
      print(response.body);
      if (response.body == "nodata") {
        _cartlist = [];
        return;
      } else {
          imageCache.clear();
      imageCache.clearLiveImages();
        var jsondata = json.decode(response.body);
        print(jsondata);
        _cartlist = jsondata["cart"];

        _totalprice = 0;
        for (int index = 0; index < _cartlist.length; index++) {
          _totalprice = _totalprice +
              double.parse(_cartlist[index]['productprice']) *
                  int.parse(_cartlist[index]['cartquantity']);
        }
      }
      setState(() {});
    });
  }

  Future<void> _modifycartqty(int index, String instr) async {
    ProgressDialog progressDialog =
        ProgressDialog(context, type: ProgressDialogType.Normal);
    progressDialog.style(message: 'loading...');
    progressDialog.show();
    await Future.delayed(Duration(seconds: 1));
    print(index);
    print(instr);
    print(widget.user.email);
    print((_cartlist[index]['productquantity'].toString()));
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/modifycartqty.php"),
        body: {
          "email": widget.user.email,
          "instruction": instr,
          "productid": _cartlist[index]['productid'],
          "cartquantity": _cartlist[index]['cartquantity']
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "update successfully",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
        _loadpersonalcart();
      } else {
        Fluttertoast.showToast(
            msg: "update failed please try again",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
      }
      progressDialog.hide();
    });
  }

  _checktotal() {
    if (_totalprice > 0) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Checkoutpage(user: widget.user),
        ),
      );
    } else {
      Fluttertoast.showToast(
          msg: "Please add product in to your cart.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.orange[100],
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }
}
