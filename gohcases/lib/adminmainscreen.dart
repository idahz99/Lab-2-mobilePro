import 'package:flutter/material.dart';
import 'User.dart';
import 'adminaddProduct.dart';

 
//void main() => runApp(AdminmainS());

class AdminmainS extends StatefulWidget {
  final User user;

  const AdminmainS({Key key, this.user}) : super(key: key);
  @override
  _AdminmainSState createState() => _AdminmainSState();
}

class _AdminmainSState extends State<AdminmainS> {
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Material App Bar'),
        ),
        body: Center(
          child: Container(
            child: FloatingActionButton( shape : RoundedRectangleBorder( borderRadius: BorderRadius.circular(15), ),child: Icon(Icons.add),
             backgroundColor:Colors.black, onPressed: ()
             { Navigator.push(context, MaterialPageRoute(builder: (content) => AddProducts ( user: widget.user)));
              }
            ), 
            ),
        ),
      ),
    );
  }
}
//Navigator.push(context, MaterialPageRoute(builder: (content) => AddProducts(user: user)));
//reminder you have changed the routing in login screen do not forget to put AdminmainS back 