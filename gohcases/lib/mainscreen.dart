import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gohcase/productdetails.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'User.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'cart.dart';
import 'cusdrawer.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List _productsList;
  int cartnumber = 0;
  TextEditingController _searchedproduct = new TextEditingController();

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

    return Scaffold(
      drawer: CusDrawer(user: widget.user),
      appBar: AppBar(
        actions: [
          TextButton.icon(
              style: ButtonStyle(),
              onPressed: () async => {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            Cart(user: widget.user, email: widget.user.email),
                      ),
                    ),
                  },
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.brown[400],
              ),
              label: Text(
                cartnumber.toString(),
                style: TextStyle(color: Colors.brown[400]),
              )),
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/cover.png"),
                  fit: BoxFit.fill)),
        ),
      ),
      body: Center(
        child: Container(
            child: Column(
          children: <Widget>[
            //1.searchfunction
            SizedBox(height: 10),
            Container(
              height: 50,
              margin: EdgeInsets.symmetric(),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.white),
              child: TextField(
                controller: _searchedproduct,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => _loadproducts(_searchedproduct.text)),
                  hintText: "Search your case",
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
            ),
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
                                child: GestureDetector(
                                    onTap: () => showproduct(index),
                                    child: Card(
                                      child: Column(
                                        children: [
                                          Container(
                                            height: screenheight / 5,
                                            child: Image.network(
                                             // imageUrl:
                                                  "https://crimsonwebs.com/s269349/GohCases/images/products/${_productsList[index]['productid']}.png",
                                              fit: BoxFit.cover,
                                              
                                            errorBuilder:
                                                 (context, url, error) =>
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
                                          MaterialButton(
                                            onPressed: () => {
                                              _insertcart(
                                                  index,
                                                  _productsList[index]
                                                      ['productid'],
                                                  email: widget.user.getemail())
                                            },
                                            child: Text('Add to Cart',
                                                style: TextStyle(
                                                    color: Colors.black)),
                                            color: Colors.redAccent[100],
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                          ),
                                        ],
                                      ),
                                    )),
                              );
                            }))))
          ],
        )),
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
         imageCache.clear();
      imageCache.clearLiveImages();
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
    _loadtocart();
  }

  showproduct(int index) {
    print(index);
    print(_productsList[index]['productid']);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (content) => Display(
                currentindex: index,
                productsList: _productsList,
                user: widget.user)));
  }

  void _loadtocart() {
    print(widget.user.email);

    http.post(
        Uri.parse("https://crimsonwebs.com/s269349/GohCases/php/loadcart.php"),
        body: {"email": widget.user.email}).then((response) {
      setState(() {
        cartnumber = int.parse(response.body);
        print(cartnumber);
      });
    });
  }

  _insertcart(int index, String productid, {String email}) {
    print(index);
    print(productid);
    print(email);

    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/insertcart.php"),
        body: {"email": email, "productid": productid}).then((response) {
      print(response.body);
      if (response.body == "failed") {
        Fluttertoast.showToast(
            msg: "Failed",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "success",
            toastLength: Toast.LENGTH_SHORT,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        _loadtocart();
      }
    });
  }
}
