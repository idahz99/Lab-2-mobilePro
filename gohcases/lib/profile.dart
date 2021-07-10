import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import 'User.dart';
import 'mainscreen.dart';
 
void main() => runApp(Myprofile());
 
class Myprofile extends StatefulWidget {
  final User user;

  const Myprofile({Key key, this.user}) : super(key: key);
  @override
  _MyprofileState createState() => _MyprofileState();
}

class _MyprofileState extends State<Myprofile> {
   TextEditingController _username;
  TextEditingController _phonenumber;
  TextEditingController _address;
 
  @override
  void initState() {
    super.initState();

    _username = new TextEditingController(text:widget.user.username);
    _phonenumber = new TextEditingController(text:widget.user.phonenum );
    _address = new TextEditingController( text:widget.user.address);
   // _password = new TextEditingController(text: (widget.editedproduct[widget.index]["productquantity"]));
  }
  File _profileimage;
  String pathAsset = 'assets/images/defaultpic.jpg';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
         resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text("Profile Page"),
           backgroundColor: Colors.orange[100],
             leading: GestureDetector(
    onTap: () {Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                           MainScreen(user:widget.user),
                      ),
                    ); },
    child: Icon(
      Icons.arrow_back_rounded,  
    ),
  ),
        ),
        body: SingleChildScrollView(
                  child: Center(
            child: Column(
              children: [
                
                
                 _displayprofile(),
                  

 
             
             SizedBox(height:20),
                  //userenterdata
        //  Text(widget.user.username,style: TextStyle(fontSize: 14),),

                TextFormField(

                  controller: _username,
                  decoration: InputDecoration(
                    labelText: 'Name',
                     suffixIcon: Icon(Icons.edit) ,
                      border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50)
              ),
                   // Text fontSize: 16.0,
                  ),
                ),
               
                //Text(widget.user.password,style: TextStyle(fontSize: 14)),
                TextFormField(
                  controller: _phonenumber,
                    keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                     suffixIcon: Icon(Icons.edit) ,
                    labelText: 'Phone number',
                    border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50)
              ),
                  ),
                ),
                TextFormField(
                  controller: _address,
                    keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                     suffixIcon: Icon(Icons.edit) ,
                    labelText: 'Address',
                    border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(50)
              ),
                  ),
                  minLines: 1,
                  maxLines: 3,
                ),
                 SizedBox(height: 5),
                  Text(widget.user.email,style: TextStyle(fontSize: 14,color: Colors.red[200])),
                SizedBox(height: 5),
                 MaterialButton(
                  onPressed: () => {_savedialog()},
                  child:
                      Text('Save changes', style: TextStyle(color: Colors.black)),
                  color: Colors.redAccent[100],
                              shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
          
          
          
          
                      ],

                    ),
                  ),
        ),
              ),
            );
          }
        
  _savedialog() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return AlertDialog(
            title: new Text("Confirm to save new changes"),
            actions: <Widget>[
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('No'),
              ),
              TextButton(
                style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                ),
                onPressed: () {
                  _saveconfirmed();
                  Navigator.pop(context);
                },
                child: Text('Yes'),
              )
            ],
          );
        });
  }

  void _saveconfirmed() {
    String _cususername = _username.text.toString();
    String cusphonenum = _phonenumber.text.toString();
    String cusaddress = _address.text.toString();
  
    print(_cususername);
    print(cusphonenum );
    print((widget.user.id).toString());
    print(cusaddress);
   print(widget.user.getemail());
   if(_profileimage != null) {
      print("not null");
      String base64Image = base64Encode(_profileimage.readAsBytesSync());
      imageCache.clear();
      imageCache.clearLiveImages();
  
   
       http.post(
              Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/editprofile.php"),
        body: {
          "encoded_string": base64Image,
          "userid":(widget.user.id).toString(),
          "username": _cususername,
          "address": cusaddress,
          "email" : widget.user.getemail(),
          "phone" : cusphonenum,
        }).then((response) {
        print(response.body);
        if (response.body == "success") {
           widget.user.address = cusaddress;
           widget.user.phonenum = cusphonenum;
           widget.user.username = _cususername;
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
      print(" null");
http.post(
              Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/editprofile.php"),
        body: {
         // "encoded_string": base64Image,
           "userid":(widget.user.id).toString(),
          "username": _cususername,
          "address": cusaddress,
          "email" : widget.user.getemail(),
          "phone" : cusphonenum,
        }).then((response) {
        print(response.body);
        if (response.body == "success") {
            widget.user.address = cusaddress;
           widget.user.phonenum = cusphonenum;
           widget.user.username = _cususername;
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

  _cameraOrgallerydialog() {
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
      _profileimage = File(pickedFile.path);
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
      _profileimage = File(pickedFile.path);
      setState(() {});
    } else {
      print('No');
    }
  }

   _displayprofile() {
    if (_profileimage == null) {
      return Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[

        
             CircleAvatar(
                          child: ClipOval(
                            child: Image.network(
                  "https://crimsonwebs.com/s269349/GohCases/images/Profilepicture/${widget.user.id}.png",
                  errorBuilder : ( BuildContext context, Object exception, StackTrace stackTrace){  return  (Image.asset("assets/images/defaultpic.jpg") );  },
                    fit: BoxFit.cover,
                   height: 250,
                    width: 250,
                    
                            
                 
                  //  height: 250,
                ),
              ),
              radius: 100,
            ),
          //  ),
             IconButton(icon:Icon(Icons.camera), onPressed:()=>{_cameraOrgallerydialog()} )
                  
        
          ],
      );
    } else if (_profileimage != null) {

    //  DefaultCacheManager().removeFile("https://crimsonwebs.com/s269349/GohCases/images/products/${widget.editedproduct[int.parse(widget.index.toString())]['productid']}.png");
    return Stack(
            alignment: AlignmentDirectional.topCenter,
        children: <Widget>[
          CircleAvatar(
                      child: ClipOval(
                        child: Image.file(
               _profileimage,
                fit: BoxFit.cover,
                width: 250,
                height: 250,
              ),
            ),
            radius:100,
          ),
          
         IconButton(icon:Icon(Icons.camera), onPressed:()=>{_cameraOrgallerydialog()} )
        ],
      );

    }
  }
}
