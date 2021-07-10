import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'User.dart';
import 'adminmainscreen.dart';

class AddProducts extends StatefulWidget {
  final User user;

  const AddProducts({Key key, this.user}) : super(key: key);
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  File _productimage;
  String pathAsset = 'assets/images/noproduct.jpg';
  TextEditingController _productname = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _quantity = new TextEditingController();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.orange[100],
          title: Text('Add products'),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AdminmainS(user: widget.user),
                ),
              );
            },
            child: Icon(
              Icons.arrow_back_rounded,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Center(
              child: Column(
            children: [
              SizedBox(height: 10),
              GestureDetector(
                onTap: () => {_cameraOrGallery()},
                child: Container(
                  height: 250,
                  width: 250,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: _productimage == null
                          ? AssetImage(pathAsset)
                          : FileImage(_productimage),
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                  controller: _productname,
                  decoration: InputDecoration(hintText: 'Product Name')),
              SizedBox(height: 10),
              TextField(
                  controller: _price,
                  decoration: InputDecoration(hintText: 'Product Price')),
              SizedBox(height: 10),
              TextField(
                  controller: _description,
                  decoration: InputDecoration(hintText: 'Product Description')),
              SizedBox(height: 10),
              TextField(
                  controller: _quantity,
                  decoration: InputDecoration(hintText: 'Product Quantity')),
              SizedBox(height: 5),
              MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  child: Text('Add Product',
                      style: TextStyle(color: Colors.black)),
                  onPressed: _submitProduct),
            ],
          )),
        ),
      ),
    );
  }

  _cameraOrGallery() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_camera),
                      title: new Text('Camera'),
                      onTap: () {
                        _chooseCamera();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_album),
                    title: new Text('Gallery'),
                    onTap: () {
                      _chooseGallery();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future _chooseCamera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 500,
      maxWidth: 500,
    );

    if (pickedFile != null) {
      _productimage = File(pickedFile.path);
      setState(() {});
    } else {
      print('No');
    }
  }

  Future _chooseGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _productimage = File(pickedFile.path);
      setState(() {});
    } else {
      print('No');
    }
  }

  void _submitProduct() {
    String base64Image = base64Encode(_productimage.readAsBytesSync());
    String productname = _productname.text.toString();
    String productprice = _price.text.toString();
    String productquantity = _quantity.text.toString();
    String productdescription = _description.text.toString();
    print(productname);
    print(base64Image);
    print(productprice);
    print(productquantity);
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/addproduct.php"),
        body: {
          "productname": productname,
          "productquantity": productquantity,
          "productprice": productprice,
          "productdescription": productdescription,
          "encoded_string": base64Image
        }).then((response) {
      print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          _productimage = null;
          _price.text = "";
          _quantity.text = "";
          _description.text = "";
          _productname.text = " ";
        });
      } else {}
    });
  }
}
