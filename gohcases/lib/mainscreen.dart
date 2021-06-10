import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'User.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MainScreen extends StatefulWidget {
  final User user;

  const MainScreen({Key key, this.user}) : super(key: key);
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List _productsList;
  TextEditingController _searchedproduct = new TextEditingController();
  
  double screenheight, screenwidth;
  @override
  void initState() {
    super.initState();
    _running();
     }

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //  title: 'Material App',
    screenheight = MediaQuery.of(context).size.height;
    screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.menu,
          color: Colors.black,
        ),
        automaticallyImplyLeading: false,
         //backgroundColor: HexColor ("#fdebea"),
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
                                  child: Card(
                                    child: Column(
                                      children: [
                                        Container(
                                          height: screenheight / 5,
                                          //width:screenwidth/2,
                                          child: CachedNetworkImage(
                                            imageUrl:
                                                "https://crimsonwebs.com/s269349/GohCases/images/products/${_productsList[index]['productid']}.png",
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) =>
                                                new Transform.scale(
                                                    scale: 0.1,
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget:
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
                                          onPressed: () => {},
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
                                  ));
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
}
