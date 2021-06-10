import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'User.dart';

//void main() => runApp(AddProducts());

class AddProducts extends StatefulWidget {
  final User user;

  const AddProducts({Key key, this.user}) : super(key: key);
  @override
  _AddProductsState createState() => _AddProductsState();
}

class _AddProductsState extends State<AddProducts> {
  File _productimage;
  String pathAsset = 'assets/images/cover.png';
  TextEditingController _productname = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  TextEditingController _description = new TextEditingController();
  TextEditingController _quantity = new TextEditingController();
  @override
  Widget build(BuildContext context) {
   // return MaterialApp(
    //  title: 'Material App',
      home: Scaffold(
         resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text('Add products'),
        ),
        body: 
         SingleChildScrollView(
                  child: Center(
              child: Column(
            children: [
              SizedBox(height: 10),
              GestureDetector(
                  //click to show launchOptionson
                  onTap:()=>{ _cameraOrGallery()},
                  //where gesture detector
                  child: Container(
                    height:150,
                    width:150,
                    // height: screenHeight / 2.5,
              //            width: screenWidth / 1,
                          //constraints: BoxConstraints(
                          //  maxHeight: 150.0,
                          //  maxWidth: 150.0,
                         //   minWidth: 150.0,
                         //   minHeight: 150.0,
                           
                        //  ),
                          decoration: BoxDecoration(
                             image: DecorationImage(
                             image: _productimage == null
                                ? AssetImage(pathAsset)
                                : FileImage(_productimage),
                             fit: BoxFit.scaleDown,

                          ),
                           
                          ),
                  ) ,   
                     ),
                 
                  
                 SizedBox(height: 10),
                  TextField(controller: _productname, 
                  decoration:InputDecoration(
                    hintText:'Product Name')
                  ),
                    SizedBox(height: 10),
                  TextField(controller: _price, 
                  decoration:InputDecoration(
                    hintText:'Product Price')),
                    SizedBox(height: 10),
                  TextField(controller: _description, 
                  decoration:InputDecoration(
                    hintText:'Product Description')),
                    SizedBox(height: 10),
                  TextField(controller: _quantity, 
                  decoration:InputDecoration(
                    hintText:'Product Quantity')),
                    SizedBox(height:5),
                    
                   MaterialButton(
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          child: Text('Register',
                              style: TextStyle(color: Colors.black)),
                          onPressed: _submitProduct),
                                    ],
                                  )),
        ),
                              );
                          // i changed scafold from , to ; );
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
                            } else {
                              print('No');
                            }
                          }
                        
     void _submitProduct() {
    String base64Image = base64Encode(_productimage.readAsBytesSync());
    String productname = _productname.text.toString();
    String productprice = _price.text.toString();
    String productquantity= _quantity.text.toString();
    String productdescription= _description.text.toString();
    print(productname);
    print(base64Image);
    print(productprice);
    print(productquantity);
    http.post(
      Uri.parse(
         "https://crimsonwebs.com/s269349/GohCases/php/addproduct.php"),
        body: {
          "productname": productname,
           "productquantity":productquantity,
           "productprice": productprice,
           "productdescription": productdescription,
           "encoded_string": base64Image
        }).then((response) {
     // pr.hide().then((isHidden) {
     //   print(isHidden);
   //   });
        print(response.body);
      if (response.body == "success") {
        Fluttertoast.showToast(
            msg: "Success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
        setState(() {
          _productimage = null;
           _price.text = "";
            _quantity.text = "";
            _description.text = "";
            _productname.text =" ";

        });
       // Navigator.push(
       //     context,
         //   MaterialPageRoute(
            //    builder: (content) => TouringGramScreen(
             //         user: widget.user,
  }else{}

          }
          );
     }
}
