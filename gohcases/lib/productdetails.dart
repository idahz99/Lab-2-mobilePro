import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'User.dart';
import 'mainscreen.dart';

void main() => runApp(Display());

class Display extends StatefulWidget {
 
  final int currentindex;
  final List productsList;
  final User user;
  const Display({Key key, this.currentindex, this.productsList, this.user})
      : super(key: key);

  @override
  _DisplayState createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
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
          title: Text('Product Details'),
        
        ),
        body: SingleChildScrollView(
                  child: Column(
           
            children: [
               SizedBox(height:10),
             Image.network(
                                                  
                                                      "https://crimsonwebs.com/s269349/GohCases/images/products/${widget.productsList[int.parse(widget.currentindex.toString())]['productid']}.png",
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

            Card(
                        child: Column(
               crossAxisAlignment:CrossAxisAlignment.start,
                children:[         
                           Text(widget.productsList[int.parse(widget.currentindex.toString())]
                          ['productname']
                      .toString(),style:TextStyle(fontWeight:FontWeight.bold)),
                   Divider(height:3),
                    SizedBox(height:5),
                Text("Price: RM"+widget.productsList[int.parse(widget.currentindex.toString())]
                        ['productprice']
                    .toString(),style:TextStyle(fontSize:14)),
                    Text("Product Description ",style:TextStyle(fontWeight:FontWeight.bold)),
                Text(widget.productsList[int.parse(widget.currentindex.toString())]
                        ['productdescription']
                    .toString()),
                Text("Stock: "+widget.productsList[int.parse(widget.currentindex.toString())]
                        ['productquantity']
                    .toString()),
                ]),
            ),
              MaterialButton(
                onPressed: () => {
                   {
                                                _insertcart(
                                                                                                 widget.currentindex,
                                                                                                  widget.productsList[  widget.currentindex]['productid'],
                                                                                                  email: widget.user.getemail())
                                                                                            },
                                                              },
                                                              child: Text('Add to Cart', style: TextStyle(color: Colors.black)),
                                                              color: Colors.redAccent[100],
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(20)),
                                                            ),
                                                            Center(
                                                              child: Container(
                                                
                                                                  // child: Text('Hello World'),
                                                                  ),
                                                            ),
                                                          ],
                                                        ),
        ),
                                                    ),
                                                  );
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
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        Fluttertoast.showToast(
            msg: "success",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 3,
            backgroundColor: Colors.orange[100],
            textColor: Colors.white,
            fontSize: 16.0);
        
      }
    });
  
  
                                                }
}
