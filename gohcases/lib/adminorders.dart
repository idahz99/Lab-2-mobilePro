import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gohcase/adminmainscreen.dart';
import 'package:http/http.dart' as http;
import 'User.dart';
 
void main() => runApp(Adminorders());
 
class Adminorders extends StatefulWidget {
  final User user;

  const Adminorders({Key key, this.user}) : super(key: key);
  @override
  _AdminordersState createState() => _AdminordersState();
}

class _AdminordersState extends State<Adminorders> {
  List _adminorderslist = [];

  
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
    onTap: () {Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                          AdminmainS(user:widget.user),
                      ),
                    ); },
    child: Icon(
      Icons.arrow_back_rounded,  
    ),
  ),
          title: Text('Customers Orders'),
        ),
        body: Container(
                      child: Column(children: [
                        SizedBox(height:10),
                       _adminorderslist == null
             ?Flexible(child: Center(child: Text('Loadng...')))
             : Flexible(
                 child: Center(
                          child: GridView.count(
                        crossAxisCount: 1,
                        childAspectRatio: 2.6,

                       children: List.generate(_adminorderslist.length, (index){
                        return Padding(
                          padding: EdgeInsets.all(2.0),
                          child: Container(
                                     
                              child: Card(
                              child:Column(children: [
                                Row(
                                  children: [
                                    Text("Order id: "+_adminorderslist[index]['orderid'],style:TextStyle( fontWeight:FontWeight.bold)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Wrap(
                                      alignment: WrapAlignment.spaceBetween,
                                      spacing: 20,
                                      children: [
                                        Text("Ordered by: "+ _adminorderslist[index]['name'],style:TextStyle(fontSize:10)),
                                        Text("Date Ordered : " + _adminorderslist[index]['orderdate'],style:TextStyle(fontSize:10)),
                                      ],
                                    ),
                                  ],
                                ),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Text("Amount paid: " + _adminorderslist[index]['amount']),
                                  ],
                                  
                                ),
                                Divider(thickness: 2,),
                              // Flexible(
                               // child:
                                 Row(
                                   textDirection: TextDirection.ltr,
                                  children: [
                                  Flexible(child: Text("Delivery address: "+ _adminorderslist[index]['address'],style:TextStyle(fontSize:10))),
                                  ],
                                ),
                              Text("Email: "+ _adminorderslist[index]['email'],style:TextStyle(fontSize:10))  ,
                              //),
                              ])
                                
                           ),
                           // ),
                            ),
                        );}
                       ),
                       
              ),
                 ),
               )
            ],),
                    ) 
            
            ),
         // ),
        );
      }

      void _loadorders() {
    http.post(
        Uri.parse(
            "https://crimsonwebs.com/s269349/GohCases/php/adminorderlist.php"),
        body: {"email":widget.user.email}).then((response) {
      //print(response.body);
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
        _adminorderslist = jsondata["orders"];
        setState(() {
          print(_adminorderslist);
        });
      }
    });

      }
}