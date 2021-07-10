import 'dart:convert';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'User.dart';
import 'adminmainscreen.dart';

void main() => runApp(Editproduct());

class Editproduct extends StatefulWidget {
  final User user;
  final List editedproduct;
  final int index;

  const Editproduct({Key key, this.user, this.index, this.editedproduct})
      : super(key: key);
  @override
  _EditproductState createState() => _EditproductState();
}

class _EditproductState extends State<Editproduct> {
  File _newimage;
  String pathAsset;
  TextEditingController _contproductname;
  TextEditingController _contproductprice;
  TextEditingController _contproductstock;
  TextEditingController _contproductdescription;
  @override
  void initState() {
    super.initState();

    _contproductname = new TextEditingController(
        text: (widget.editedproduct[widget.index]["productname"]));
    _contproductprice = new TextEditingController(
        text: (widget.editedproduct[widget.index]["productprice"]));
    _contproductdescription = new TextEditingController(
        text: (widget.editedproduct[widget.index]["productdescription"]));
    _contproductstock = new TextEditingController(
        text: (widget.editedproduct[widget.index]["productquantity"]));
  }
  
  String _imageUrl;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
         resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.orange[100],
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (content) => AdminmainS(user: widget.user)));
            },
            child: Icon(
              Icons.arrow_back,
              color: Colors.black,
            ),
          ),
          title: Text('Edit Product'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
            
              _displayImage(),
             

              Text(widget.editedproduct[int.parse(widget.index.toString())]
                      ['productid']
                  .toString()),

              TextFormField(
                controller: _contproductname,
                decoration: InputDecoration(
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                controller: _contproductprice,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              TextFormField(
                controller: _contproductdescription,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
                maxLines: 5,
              ),
              TextFormField(
                controller: _contproductstock,
                decoration: InputDecoration(
                  labelText: 'Stock',
                ),
              ),
              MaterialButton(
                onPressed: () => {_editdialog()},
                child:
                    Text('Save changes', style: TextStyle(color: Colors.black)),
                color: Colors.redAccent[100],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _editdialog() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: new Text("Confirm Edit"),
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
                  _editconfirmed();
                  Navigator.pop(context);
                },
                child: Text('Ok'),
              )
            ],
          );
        });
  }

  void _editconfirmed() {
    String productname = _contproductname.text.toString();
    String productprice = _contproductprice.text.toString();
    String productquantity = _contproductstock.text.toString();
    String productdescription = _contproductdescription.text.toString();
    print(productname);
    print(productprice);
    print((widget.editedproduct[widget.index]["productid"]).toString());
    print(productquantity);
   
   if(_newimage != null) {
      String base64Image = base64Encode(_newimage.readAsBytesSync());
      imageCache.clear();
      imageCache.clearLiveImages();
  // DefaultCacheManager().emptyCache();
  // imageCache.clear();
   // DefaultCacheManager().removeFile("https://crimsonwebs.com/s269349/GohCases/images/products/${widget.editedproduct[int.parse(widget.index.toString())]['productid']}.png");
   
   
    http.post(
              Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/editproduct.php"),
        body: {
          "encoded_string": base64Image,
          "productid":
          (widget.editedproduct[widget.index]["productid"]).toString(),
          "productname": productname,
          "productquantity": productquantity,
          "productprice": productprice,
          "productdescription": productdescription,
        }).then((response) {
        print(response.body);
        if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[100],
            textColor: Colors.black,
            fontSize: 16.0);
      }
    });

   }else{
http.post(
              Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/editproduct.php"),
        body: {
         // "encoded_string": base64Image,
          "productid":
          (widget.editedproduct[widget.index]["productid"]).toString(),
          "productname": productname,
          "productquantity": productquantity,
          "productprice": productprice,
          "productdescription": productdescription,
        }).then((response) {
        print(response.body);
        if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red[100],
            textColor: Colors.black,
            fontSize: 16.0);
      }
    });

   }

  }

  _cORg() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: new Text("Which option?"),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  _gallery();
                   Navigator.pop(context);
                },
                child: Text('Gallery'),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  _camera();
                   Navigator.pop(context);
                },
                child: Text('Camera'),
              )
            ],
          );
        });
  }

  Future _camera() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
      maxHeight: 500,
      maxWidth: 500,
    );

    if (pickedFile != null) {
      _newimage = File(pickedFile.path);
      setState(() {});
    } else {
      print('No');
    }
  }

  Future _gallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
      maxHeight: 800,
      maxWidth: 800,
    );

    if (pickedFile != null) {
      _newimage = File(pickedFile.path);
      setState(() {});
    } else {
      print('No');
    }
  }

  _displayImage() {
    if (_newimage == null) {
      return Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[

          Image.network(
            "https://crimsonwebs.com/s269349/GohCases/images/products/${widget.editedproduct[int.parse(widget.index.toString())]['productid']}.png",
           width:250,
            height: 250,
             fit: BoxFit.cover,
          ),
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: () => _cORg(),
          )
        ],
      );
    } else if (_newimage != null) {

    //  DefaultCacheManager().removeFile("https://crimsonwebs.com/s269349/GohCases/images/products/${widget.editedproduct[int.parse(widget.index.toString())]['productid']}.png");
    return Stack(
            alignment: AlignmentDirectional.bottomCenter,
        children: <Widget>[
          Image.file(
           _newimage,
            fit: BoxFit.cover,
            height: 250,
          ),
          IconButton(
            icon: Icon(Icons.camera),
            onPressed: () => _cORg(),
          )
        ],
      );

    }
  }
}
